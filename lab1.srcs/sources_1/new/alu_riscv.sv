`timescale 1ns / 1ps

`include "operation_define.sv"


module alu(
    input [31:0] A,
    input [31:0] B,
    input [4:0] ALUOp,
    output logic FLAG,
    output logic [31:0] RES
    );
    
always @* begin
    case(ALUOp) 
        `ADD: RES=A+B;
        `SUB: RES=A-B;
        `SLL: RES=A<<B;
        `SLT: RES=$signed(A<B);
        `SLTU: RES=A<B;
        `XOR: RES=A^B;
        `SRL: RES=A>>B;
        `SRA: RES = $signed(A)>>>B;
        `OR: RES = A|B;
        `AND: RES = A&B;
        `BEQ: FLAG=(A==B);
        `BNE: FLAG=(A!=B);
        `BLT: FLAG=$signed(A<B);
        `BGE: FLAG = $signed(A>=B);
        `BLTU: FLAG = (A<B);
        `BGEU: FLAG = (A>=B);
        default: begin
            RES <= 0;
            FLAG<=0;
        
            end
        
        
    endcase

end
endmodule
