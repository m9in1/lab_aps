`timescale 1ns / 1ps


module instruction_memory(
input [31:0] A,
output logic [31:0] RD
    );
    

    logic[7:0] A_to_word;
    assign A_to_word = A>>2;
    logic [31:0] RAM [0:255]; 
    initial begin
        $readmemh("D:/MIET/APS_labs/lab1/instruction.txt", RAM);
    end
    
    assign RD[31:0] = RAM[A_to_word];
    
endmodule
