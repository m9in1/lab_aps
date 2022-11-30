`timescale 1ns / 1ps

module sign_extend20(
    input [19:0] sein,
    output logic [31:0] seout
    );
    logic [11:0] sign;
    
    assign sign[11:0] = {12{sein[19]}};
    
    assign seout[31:0] = {sign,sein[19:0]};
    
    
    
endmodule
