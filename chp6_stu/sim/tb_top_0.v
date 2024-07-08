`timescale 1ns/100ps

module tb_top_0;

    reg clk;
    reg rst_n;

    reg [1:0] pe_ctl;
    reg pe_vld_i;

    reg [1:0] inst_addr;
    reg [8:0] weight_addr;
    reg [8:0] neuron_addr;
    reg [1:0] result_addr;

    integer i, j;

    reg [7:0] inst[3:0];
    reg [511:0] neuron[15:0];
    reg [511:0] weight[15:0];
    reg [31:0] result[3:0];

    wire [7:0] pe_inst;
    wire [511:0] pe_weight_line;
    wire [511:0] pe_neuron_line;
    wire [15:0] pe_weight;
    wire [15:0] pe_neuron;

    assign pe_inst = inst[inst_addr];
    assign pe_weight_line = weight[weight_addr[8:5]];
    assign pe_neuron_line = neuron[neuron_addr[8:5]];
    assign pe_weight = pe_weight_line[(16*weight_addr[4:0])+:16];
    assign pe_neuron = pe_neuron_line[(16*neuron_addr[4:0])+:16];

    initial begin
        /* TODO: 修改数据文件路径 */
        $readmemh("D:/Downloads/chp6_stu/data/inst", inst);
        $readmemh("D:/Downloads/chp6_stu/data/neuron", neuron);
        $readmemh("D:/Downloads/chp6_stu/data/weight", weight);
        $readmemh("D:/Downloads/chp6_stu/data/result", result);
    end

    initial begin
        // initial state
        clk = 1'b0;
        rst_n = 1'b0;

        pe_ctl = 2'b00;
        pe_vld_i = 1'b0;

        inst_addr = 2'b0;
        weight_addr = 9'b0;
        neuron_addr = 9'b0;
        result_addr = 2'b0;

        // reset finish
        #10 rst_n = 1'b1;

        // compute for the first output
        #1 pe_ctl = 2'b01;
           pe_vld_i = 1'b1;

           inst_addr = 2'b00;
           weight_addr = 9'b0;
           neuron_addr = 9'b0;
           result_addr = 2'b00;

        #1 pe_ctl = 2'b00;

           weight_addr = 9'b1;
           neuron_addr = 9'b1;

        for (j = 2; j < 32; j = j + 1) begin: inline_lone_o1
            #1 weight_addr = j;
               neuron_addr = j;
        end

        for (i = 1; i < pe_inst - 1; i = i + 1) begin: lines_o1
            for (j = 0; j < 32; j = j + 1) begin: inline_o1
                #1 weight_addr = 32*i + j;
                   neuron_addr = 32*i + j;
            end
        end

        for (j = 0; j < 31; j = j + 1) begin: inline_last_o1
            #1 weight_addr = 32 * (pe_inst - 1) + j;
               neuron_addr = 32 * (pe_inst - 1) + j;
        end

        #1 pe_ctl = 2'b10;
           weight_addr = 32 * (pe_inst - 1) + 31;
           neuron_addr = 32 * (pe_inst - 1) + 31;

        #1 pe_vld_i = 2'b00;

        // compute for the second output
        #1 pe_ctl = 2'b01;
           pe_vld_i = 1'b1;

           inst_addr = 2'b01;
           weight_addr = 9'd128;
           neuron_addr = 9'd128;
           result_addr = 2'b01;

        #1 pe_ctl = 2'b00;

           weight_addr = 9'd129;
           neuron_addr = 9'd129;

        for (j = 2; j < 32; j = j + 1) begin: inline_lone_o2
            #1 weight_addr = j + 128;
               neuron_addr = j + 128;
        end

        for (i = 1; i < pe_inst - 1; i = i + 1) begin: lines_o2
            for (j = 0; j < 32; j = j + 1) begin: inline_o2
                #1 weight_addr = 32*i + j + 128;
                   neuron_addr = 32*i + j + 128;
            end
        end

        for (j = 0; j < 31; j = j + 1) begin: inline_last_o2
            #1 weight_addr = 32 * (pe_inst - 1) + j + 128;
               neuron_addr = 32 * (pe_inst - 1) + j + 128;
        end

        #1 pe_ctl = 2'b10;
           weight_addr = 32 * (pe_inst - 1) + 31 + 128;
           neuron_addr = 32 * (pe_inst - 1) + 31 + 128;

        #1 pe_vld_i = 2'b00;

        // compute for the third output
        #1 pe_ctl = 2'b01;
           pe_vld_i = 1'b1;

           inst_addr = 2'b10;
           weight_addr = 9'd256;
           neuron_addr = 9'd256;
           result_addr = 2'b10;

        #1 pe_ctl = 2'b00;

           weight_addr = 9'd257;
           neuron_addr = 9'd257;

        for (j = 2; j < 32; j = j + 1) begin: inline_lone_o3
            #1 weight_addr = j + 256;
               neuron_addr = j + 256;
        end

        for (i = 1; i < pe_inst - 1; i = i + 1) begin: lines_o3
            for (j = 0; j < 32; j = j + 1) begin: inline_o3
                #1 weight_addr = 32*i + j + 256;
                   neuron_addr = 32*i + j + 256;
            end
        end

        for (j = 0; j < 31; j = j + 1) begin: inline_last_o3
            #1 weight_addr = 32 * (pe_inst - 1) + j + 256;
               neuron_addr = 32 * (pe_inst - 1) + j + 256;
        end

        #1 pe_ctl = 2'b10;
           weight_addr = 32 * (pe_inst - 1) + 31 + 256;
           neuron_addr = 32 * (pe_inst - 1) + 31 + 256;

        #1 pe_vld_i = 2'b00;

        // compute for the fourth output
        #1 pe_ctl = 2'b01;
           pe_vld_i = 1'b1;

           inst_addr = 2'b11;
           weight_addr = 9'd384;
           neuron_addr = 9'd384;
           result_addr = 2'b11;

        #1 pe_ctl = 2'b00;

           weight_addr = 9'd385;
           neuron_addr = 9'd385;

        for (j = 2; j < 32; j = j + 1) begin: inline_lone_o4
            #1 weight_addr = j + 384;
               neuron_addr = j + 384;
        end

        for (i = 1; i < pe_inst - 1; i = i + 1) begin: lines_o4
            for (j = 0; j < 32; j = j + 1) begin: inline_o4
                #1 weight_addr = 32*i + j + 384;
                   neuron_addr = 32*i + j + 384;
            end
        end

        for (j = 0; j < 31; j = j + 1) begin: inline_last_o4
            #1 weight_addr = 32 * (pe_inst - 1) + j + 384;
               neuron_addr = 32 * (pe_inst - 1) + j + 384;
        end

        #1 pe_ctl = 2'b10;
           weight_addr = 32 * (pe_inst - 1) + 31 + 384;
           neuron_addr = 32 * (pe_inst - 1) + 31 + 384;

        #1 pe_vld_i = 2'b00;

        #10 $finish;
    end

    always begin
        #0.5 clk = ~clk;
    end

    wire [31:0] pe_result;
    wire pe_vld_o;
    serial_pe uut(
        .clk(clk),
        .rst_n(rst_n),
        .neuron(pe_neuron),
        .weight(pe_weight),
        .ctl(pe_ctl),
        .vld_i(pe_vld_i),
        .result(pe_result),
        .vld_o(pe_vld_o));

    reg compare_pass;

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            compare_pass <= 1'b0;
        end
        else if (pe_vld_o && (pe_result == result[result_addr])) begin
            compare_pass <= 1'b1;
        end
        else if (~pe_vld_o) begin
            compare_pass <= 1'b0;
        end
    end

endmodule // tb_top_0