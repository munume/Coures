`timescale 1ns / 1ps

module adder(
    input  [31:0] operand1,
    input  [31:0] operand2,
    input         cin,
    output [31:0] result,
    output        cout
    );
     //实现加法功能，输出进位cout和结果result
    assign {cout,result} = operand1 + operand2 + cin;

endmodule