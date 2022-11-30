`timescale 1ns / 1ps


module onplis(
    input CLK100MHZ,
    input BTNC,
    input CPU_RESETN,
    input [15:0] SW,
    output logic [15:0] LED
    );
    logic [31:0] IN;
    logic [31:0] OUT;
    assign IN = {{16{SW[15]}},SW[15:0]};
    assign LED = !BTNC ? OUT[15:0] : OUT[31:16];
    top test(.clk(CLK100MHZ),.rst(!CPU_RESETN),.in(IN),.out(OUT));
    
endmodule
