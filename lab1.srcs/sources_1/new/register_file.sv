`timescale 1ns / 1ps

module register_file(
    input clk,
    input [4:0] A1,A2,A3,
    input [31:0] WD3,
    input WE3,
    output logic [31:0] RD1, RD2
    );
    
    logic [31:0] RAM [0:31];
    assign RD1 = A1==5'b0 ? 0 : RAM[A1];
    assign RD2 = A2==5'b0 ? 0 : RAM[A2];
    
    always@(posedge clk) begin
        if(WE3)
            RAM[A3] = WD3; 
        
    end
    
    
endmodule
