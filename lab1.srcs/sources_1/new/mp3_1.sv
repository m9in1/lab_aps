`timescale 1ns / 1ps


module mp3_1(
    input [1:0]ch_sig,
    input [31:0] sig0,sig1,sig2,
    output logic [31:0] out
    );
    always@(*) begin
        case(ch_sig)
            2'b00: out<=sig0;
            2'b01: out<=sig1;
            2'b10: out<=sig2;
        endcase
    end
endmodule
