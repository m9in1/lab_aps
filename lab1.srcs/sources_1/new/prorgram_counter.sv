`timescale 1ns / 1ps


module program_counter(
    input clk,
    input rst,
    input [31:0] in,
    output logic [31:0] out
    );
   /* initial
    cntd <= 0;*/

    always@(posedge clk or posedge rst)begin
        if(!rst) begin
           out<=in;
        end else begin
            out <= 0;
        end  
    end
endmodule
