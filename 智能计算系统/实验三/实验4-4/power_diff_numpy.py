#encoding=utf-8
import numpy as np

def power_diff_numpy(input_x,input_y,input_z):
    # 假设input_x 和 input_y的最后一个维度相同，input_y除了最后的维度维度，其余维度都是1
    # TODO:完成numpy实现的过程，参考实验教程示例
    x_shape = np.shape(input_x)
    y_shape = np.shape(input_y)
    x = np.reshape(input_x, (-1, y_shape[-1]))
    x_new_shape = np.shape(x)
    y = np.reshape(input_y, (-1))
    output = []
    # import pdb
    # pdb.set_trace()
    for i in range(x_new_shape[0]):
        output += list(np.power((x[i]-y), input_z))
    output = np.reshape(output, x_shape)
    return output

