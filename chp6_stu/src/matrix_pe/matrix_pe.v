module matrix_pe(
    input                 clk,
    input                 rst_n,
    input         [511:0] nram_mpe_neuron,
    input                 nram_mpe_neuron_valid,
    output                nram_mpe_neuron_ready,
    input         [511:0] wram_mpe_weight,
    input                 wram_mpe_weight_valid,
    output                wram_mpe_weight_ready,
    input         [  7:0] ib_ctl_uop,
    input                 ib_ctl_uop_valid,
    output reg            ib_ctl_uop_ready,
    output        [ 31:0] result,
    output reg            vld_o
);

    wire pe_vld_i;
    wire [1:0] pe_ctl;
    reg inst_vld;
    reg [7:0] inst; // inst存放输入控制信号ib_ctl_uop的值
    always @ (posedge clk or negedge rst_n) begin
        /* TODO: inst_vld和inst赋值 */
        /* 提示： 分别考虑三种情况：
                （1）系统重置时，如何赋值
                （2）什么条件下两个信号有效，此时如何赋值
                （3）什么条件下inst_vld无效，此时如何赋值 */
        if (!rst_n) begin
            inst_vld <= 1'b0;
            inst <= 1'b0;
        end else if (ib_ctl_uop_valid && wram_mpe_weight_valid && nram_mpe_neuron_valid) begin
            inst_vld <= 1'b1;
            inst <= ib_ctl_uop;
        end else if(pe_ctl[1] && pe_vld_i) begin
            inst_vld <= 1'b0;
            inst <= 1'b0;
        end
    end

    reg [7:0] iter;
    
    always @ (posedge clk or negedge rst_n) begin
        /* TODO: iter赋值 */
        /* 提示： 分别考虑三种情况：
                （1）系统重置时，如何赋值
                （2）什么条件下需要将循环次数重置，如何赋值
                （3）什么条件下循环次数自增加，如何赋值 */
        if (!rst_n) begin
            iter <= 8'b0;
        end else if (pe_ctl[1] && pe_vld_i) begin
            iter <= 8'b0;
        end else if (pe_vld_i&& wram_mpe_weight_valid && nram_mpe_neuron_valid) begin
            iter <= iter + 1'b1;
        end
    end

    always @ (posedge clk or negedge rst_n) begin
        /* TODO: ib_ctl_uop_ready 赋值 */
        if (!rst_n) begin
            ib_ctl_uop_ready <= 1'b1;
        end else if (pe_ctl[1]) begin
            ib_ctl_uop_ready <= 1'b1;
        end else if(ib_ctl_uop_ready) begin
            ib_ctl_uop_ready <= 1'b0;
        end
    end

    wire [511:0] pe_neuron = nram_mpe_neuron;
    wire [511:0] pe_weight = wram_mpe_weight;
    

    /* TODO */
    assign pe_ctl[0] = (iter == 8'h0)&& nram_mpe_neuron_valid && wram_mpe_weight_valid;
    assign pe_ctl[1] = (iter == (inst -1'b1))&& nram_mpe_neuron_valid && wram_mpe_weight_valid ;
    assign pe_vld_i = inst_vld && nram_mpe_neuron_valid && wram_mpe_weight_valid&&!ib_ctl_uop_ready;

    wire [31:0] pe_result;
    wire pe_vld_o;
    parallel_pe u_parallel_pe (
        /* TODO: 调用parallel_pe模块 */
        .clk(clk),
        .rst_n(rst_n),
        .neuron(pe_neuron),
        .weight(pe_weight),
        .ctl(pe_ctl),
        .vld_i(pe_vld_i),
        .result(pe_result),
        .vld_o(pe_vld_o)
        );

    /* TODO */
    assign nram_mpe_neuron_ready = inst_vld && nram_mpe_neuron_valid;
    assign wram_mpe_weight_ready = inst_vld && wram_mpe_weight_valid;

    assign result = pe_result;
    assign vld_o = pe_vld_o;


endmodule
