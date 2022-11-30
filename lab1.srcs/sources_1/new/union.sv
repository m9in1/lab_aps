`timescale 1ns / 1ps


module top(
    input clk,rst,
    input [31:0] in,
    output logic [31:0] out
    );

    logic [7:0] cnt_pc;
   
    
    
    logic flagalu;
    logic [7:0] instruction_num;
    logic [31:0] RD_IM;
    logic [31:0] RD1_RF,RD2_RF,aluout,seout;
    
    
    
    
    
    instruction_memory im(.A(instruction_num),.RD(RD_IM));
    
    
    logic [31:0]WD3_RF; 
    multiplexer_3_WD3_RF mp(.choice(WS),.in1(in),
    .in2(seout),.in3(aluout),.out(WD3_RF));
    
    
    
    
    logic [7:0] multiplexer_2_pc;
    assign multiplexer_2_pc = ((flagalu&C)|B)==1 ?
    consta : 8'b00000001;     
    program_counter pc(.clk(clk),.rst(rst),.cnt(multiplexer_2_pc),
    .cntd(instruction_num));
    
    
    
   
    
    

    
    
    
    logic WE3_RF;
    assign WE3_RF = WS[1]|WS[0];
    register_file rf(.A1(RD_IM[19:15]),.A2(RD_IM[24:20]),.A3(RD_IM[11:7]),.WD3(....rd_or_alu),.clk(clk),
    .WE3(...),.RD1(RD1_RF),.RD2(RD2_RF));
    
    
    logic [31:0] imm_i, imm_s,imm_j,imm_b;
    sign_extend12 i(.sein(RD_IM[31:20]),.seout(imm_i));
    sign_extend12 s(.sein({RD_IM[31:25],RD_IM[11:7]}),.seout(imm_s));
    sign_extend20 j(.sein({RD_IM[31],RD_IM[19:12],RD_IM[20],RD_IM[30:21]}),.seout(imm_j));
    sign_extend20 b(.sein({RD_IM[31],RD_IM[7],RD_IM[30:25],RD_IM[11:8]}),.seout(imm_i));
    

    alu aluop(.A(RD1_RF),.B(RD2_RF),.RES(aluout),.ALUOp(ALUop),
    .FLAG(flagalu));
    
    assign out = RD1_RF;
    
    
endmodule
