`timescale 1ns / 1ps

module sign_extend_imm_j(
    input [20:0] sein,
    output logic [31:0] seout
    );
    logic [11:0] sign;
    
    assign sign[18:0] = {19{sein[20]}};
    
    
    assign seout[31:0] = {sign ,sein[20:0]};
    
    
    
endmodule
