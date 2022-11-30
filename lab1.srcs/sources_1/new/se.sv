`timescale 1ns / 1ps

module sign_extend12(
    input [11:0] sein,
    output logic [31:0] seout
    );
    logic [18:0] sign;
    
    assign sign[19:0] = {20{sein[11]}};
    
    assign seout[31:0] = {sign,sein[11:0]};
    
    
    
endmodule
