`timescale 1ns / 1ps


module multiplexer_3_WD3_RF(
    input [1:0] choice,
    input [31:0] in1,in2,in3,
    
    output logic [31:0] out
    );
    
    always@(*) begin
        if(choice == 2'b01) 
            out<=in1;
        if(choice == 2'b10) 
            out<=in2;
        if(choice == 2'b11) 
            out<=in3;
    
    end
endmodule
