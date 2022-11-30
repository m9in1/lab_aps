`timescale 1ns / 1ps


module data_memory(
    input clk,
    input [31:0] A,
    input [31:0] WD,
    input WE,
   // input [2:0] I,
    output logic [31:0] RD
    
    );
    
    logic [31:0] RAM [0:255];
    logic [31:0]edge_of_mem;
    assign edge_of_mem=32'h72000000;
    assign RD = ((A[9:2]>=edge_of_mem)&(A[9:2]<=edge_of_mem+10'h3FC)) ? RAM[A[9:2]] : 0;
    
    always@(posedge clk) begin
        if(WE!=0)
            RAM[A[9:2]] <= WD;
    
    end
    
    
endmodule
