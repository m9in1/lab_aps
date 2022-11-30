`timescale 1ns / 1ps

module sign_extend_imm_b(
    input [12:0] sein,
    output logic [31:0] seout
    );
    logic [18:0] sign;
    
    assign sign[18:0] = {19{sein[12]}};
    
    
    assign seout[31:0] = {sign ,sein[12:0]};
    
    
    
endmodule
