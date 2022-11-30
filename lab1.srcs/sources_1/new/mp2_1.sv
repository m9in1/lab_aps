`timescale 1ns / 1ps


module mp2_1(
    input ch_sig,
    input [31:0] sig0,sig1,
    output [31:0] out
    );
    assign out = ch_sig ? sig1 : sig0;
endmodule
