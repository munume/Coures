`timescale 1ns / 1ps

module tb;

    // Inputs
    reg clk;
    reg resetn;
    reg [4:0] rf_addr;
    reg [31:0] mem_addr;

    // Outputs
    wire [31:0] rf_data;
    wire [31:0] mem_data;
    wire [31:0] cpu_pc;
    wire [31:0] cpu_inst;

    // Instantiate the Unit Under Test (UUT)
    single_cycle_cpu uut (
        .clk(clk), 
        .resetn(resetn), 
        .rf_addr(rf_addr), 
        .mem_addr(mem_addr), 
        .rf_data(rf_data), 
        .mem_data(mem_data), 
        .cpu_pc(cpu_pc), 
        .cpu_inst(cpu_inst)
    );

    initial begin
        // Initialize Inputs
        clk = 1;
        resetn = 0;
        rf_addr = 0;
        mem_addr = 0;
        #100;
        resetn = 1;
    
        rf_addr = 1;
        #10;
        rf_addr = 2;
        #10;
        rf_addr = 3;
        #10;       
        rf_addr = 4;
        #10;  
        rf_addr = 5;
        #10;
        mem_addr = 32'H00000014;
        #10;          
        rf_addr = 6;
        #10;      
        rf_addr = 7;
        #10;      
        rf_addr = 8;
        #10;       
        rf_addr = 9;
        #10;
        mem_addr = 32'H0000001c;   
        #10;      
        rf_addr = 10;
        #10;       
        rf_addr = 11;
        mem_addr = 32'H00000000;
        #10;
      
    end
    always #5 clk=~clk;
endmodule
