#include "inference.h"
#include "cnrt.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "stdlib.h"
#include <sys/time.h>
#include <time.h>

namespace StyleTransfer{

Inference :: Inference(std::string offline_model){
    offline_model_ = offline_model;
}

void Inference :: run(DataTransfer* DataT){
    cnrtInit(0);
    // TODO:load model
    // modelNAME: ../../models/offline_models/udnie_int8_power_diff.cambricon(_twins)
    //string offline_model_;
    cnrtModel_t model;
    cnrtLoadModel(&model, offline_model_.c_str());

    // TODO:set current device
    cnrtDev_t dev;
    cnrtGetDeviceHandle(&dev, 0);
    cnrtSetCurrentDevice(dev);

    // // get model total memory
    // int64_t totalMem;
    // cnrtGetModelMemUsed(model, &totalMem);
    // printf("total memory used: %ld Bytes\n", totalMem);
    // // get model parallelism
    // int model_parallelism;
    // cnrtQueryModelParallelism(model, &model_parallelism);
    // printf("model parallelism: %d.\n", model_parallelism);

    // TODO:load extract function
    cnrtFunction_t function;
    cnrtCreateFunction(&function);
    cnrtExtractFunction(&function, model, "subnet0"); //symbol. example: "cambricon"

    int inputNum, outputNum;
    int64_t *inputSizeS, *outputSizeS;
    cnrtGetInputDataSize(&inputSizeS, &inputNum, function); 
    cnrtGetOutputDataSize(&outputSizeS, &outputNum, function);

    // TODO:prepare data on cpu
    void **inputCpuPtrS = (void **)malloc(inputNum * sizeof(void *));
    void **outputCpuPtrS = (void **)malloc(outputNum * sizeof(void *));
    //DataT->imsplit_images; //(n, c, h, w)

    // TODO:allocate I/O data memory on MLU
    void **inputMluPtrS = (void **)malloc(inputNum * sizeof(void *));
    void **outputMluPtrS = (void **)malloc(outputNum * sizeof(void *));

    void **inputHalf = (void **)malloc(inputNum * sizeof(void *));
    void **outputHalf = (void **)malloc(outputNum * sizeof(void *));

    // TODO:prepare input buffer
    for(int i = 0; i < inputNum; i++){
        inputCpuPtrS[i] = malloc(inputSizeS[i] * 2); //FLOAT32.
        inputHalf[i] = malloc(inputSizeS[i]); //FLOAT16
        // malloc mlu memory
        cnrtMalloc(&(inputMluPtrS[i]), inputSizeS[i]);
        int dimValues[] = {1, 3, 256, 256};
        int dimOrder[] = {0, 2, 3, 1};
        //1.(n, c, h, w) -> (n , h , w, c)
        CNRT_CHECK(cnrtTransDataOrder(DataT->input_data, CNRT_FLOAT32, inputCpuPtrS[i], 4, dimValues, dimOrder)); //[0, 2, 3, 1]
        //2.convert float32 to int16;
        CNRT_CHECK(cnrtCastDataType(inputCpuPtrS[i], CNRT_FLOAT32, inputHalf[i], CNRT_FLOAT16, inputSizeS[i]/2, NULL));//NULL means dont need to Quantized.

        cnrtMemcpy(inputMluPtrS[i], inputHalf[i], inputSizeS[i], CNRT_MEM_TRANS_DIR_HOST2DEV);        
    }

    // TODO:prepare output buffer
    for (int i = 0; i < outputNum; i++) {
        // TODO:malloc cpu memory
        outputCpuPtrS[i] = malloc(outputSizeS[i] * 2);
        outputHalf[i] = malloc(outputSizeS[i]);
        // malloc mlu memory
        cnrtMalloc(&(outputMluPtrS[i]), outputSizeS[i]);
    }

    // prepare parameters for cnrtInvokeRuntimeContext
    void **param = (void **)malloc(sizeof(void *) * (inputNum + outputNum));
    for (int i = 0; i < inputNum; ++i) {
          param[i] = inputMluPtrS[i];
    }
    for (int i = 0; i < outputNum; ++i) {
          param[inputNum + i] = outputMluPtrS[i];
    }
    
    // TODO:setup runtime ctx
    cnrtRuntimeContext_t ctx;
    CNRT_CHECK(cnrtCreateRuntimeContext(&ctx, function, NULL));

    // TODO:bind device
    CNRT_CHECK(cnrtSetRuntimeContextDeviceId(ctx, 0));
    CNRT_CHECK(cnrtInitRuntimeContext(ctx, NULL));    

    // TODO:compute offline
    cnrtQueue_t queue;
    CNRT_CHECK(cnrtRuntimeContextCreateQueue(ctx, &queue));

    // invoke
    CNRT_CHECK(cnrtInvokeRuntimeContext(ctx, param, queue, NULL));
    
    // sync
    CNRT_CHECK(cnrtSyncQueue(queue));
    
    // copy mlu result to cpu
    for(int i = 0; i < outputNum; i++){
        //1.mlu->cpu
        CNRT_CHECK(cnrtMemcpy(outputHalf[i], outputMluPtrS[i], outputSizeS[i], CNRT_MEM_TRANS_DIR_DEV2HOST));
    }
     //2.float16->float32
    CNRT_CHECK(cnrtCastDataType(outputHalf[0], CNRT_FLOAT16, outputCpuPtrS[0], CNRT_FLOAT32, outputSizeS[0]/2, NULL));
    //3.(n,h,w,c)->(n, c, h, w)
    int dimValues[] = {1, 256, 256, 3};
    int dimOrder[] = {0, 3, 1, 2};
    DataT->output_data = (float *)malloc(outputSizeS[0]*2);
    CNRT_CHECK(cnrtTransDataOrder(outputCpuPtrS[0], CNRT_FLOAT32, DataT->output_data, 4, dimValues, dimOrder)); //[0, 3, 1, 2]

    // TODO:free memory spac
    for(int i = 0; i < inputNum; i++){
        free(inputCpuPtrS[i]);
        free(inputHalf[i]);
        cnrtFree(inputMluPtrS[i]);
    }
    for (int i = 0; i < outputNum; i++) {
          free(outputCpuPtrS[i]);
          free(outputHalf[i]);
          cnrtFree(outputMluPtrS[i]);
    }
    free(inputCpuPtrS);
    free(inputHalf);
    free(outputCpuPtrS);
    free(outputHalf);
    free(inputMluPtrS);
    free(outputMluPtrS);
    free(param);

    cnrtDestroyQueue(queue);
    cnrtDestroyRuntimeContext(ctx);
    cnrtDestroyFunction(function);
    cnrtUnloadModel(model);
    cnrtDestroy();
}

} // namespace StyleTransfer
