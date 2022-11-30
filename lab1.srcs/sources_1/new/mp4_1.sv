`timescale 1ns / 1ps


module mp5_1(
    input [2:0]ch_sig,
    input [31:0] sig0,sig1,sig2,sig3,sig4,
    output logic [31:0] out
    );
    always@(*) begin
        case(ch_sig)
            3'b000: out<=sig0;
            3'b001: out<=sig1;
            3'b010: out<=sig2;
            3'b011: out<=sig3;
            3'b100: out<=sig4;
        endcase
    end
endmodule
