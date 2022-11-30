`timescale 1ns / 1ps


module tract(
    input clk,
    input rst,
    output [31:0] out
    );
    assign out = instr;
    logic [31:0] instr;
////////////////////////////////////////////////////////////Decoder    
    logic [1:0] a_sel;
    logic [2:0]b_sel;
    
    
    logic [4:0] alu_op_o;
    
    logic data_mem_req,
    alu_or_dm, 
    data_mem_w_req, 
    reg_w_req, 
    ii, 
    branch,
    jal,
    jalr;
    
    decoder_riscv main(
        .fetched_instr_i(instr),
        .ex_op_a_sel_o(a_sel),      // Управляющий сигнал мультиплексора для выбора первого операнда АЛУ
        .ex_op_b_sel_o(b_sel),      // Управляющий сигнал мультиплексора для выбора второго операнда АЛУ
        .alu_op_o(alu_op_o),           // Операция АЛУ
        .mem_req_o(data_mem_req),          // Запрос на доступ к памяти (часть интерфейса памяти)
        .mem_we_o(data_mem_w_req),           // Сигнал разрешения записи в память, «write enable» (при равенстве нулю происходит чтение)
        .mem_size_o(data_mem_size),         // Управляющий сигнал для выбора размера слова при чтении-записи в память (часть интерфейса памяти)
        .gpr_we_a_o(reg_w_req),         // Сигнал разрешения записи в регистровый файл
        .wb_src_sel_o(alu_or_dm),       // Управляющий сигнал мультиплексора для выбора данных, записываемых в регистровый файл
        .illegal_instr_o(ii),    // 
        .branch_o(branch),           // Сигнал об инструкции условного перехода
        .jal_o(jal),              // Сигнал об инструкции безусловного перехода jal
        .jalr_o(jalr));       
////////////////////////////////////////////////////////Sign extanders
    logic [31:0] imm_i,imm_s,imm_j,imm_b;
    
    sign_extend12 immi(
        .sein(instr[31:20]),
        .seout(imm_i));
        
    sign_extend12 imms(
        .sein({instr[31:25],instr[11:7]}),
        .seout(imm_s));
    
    sign_extend_imm_j immj(
        .sein({instr[31],instr[19:12],instr[20],instr[30:21],1'b0}),
        .seout(imm_j));
    
    sign_extend_imm_b immb(
        .sein({instr[31],instr[7],instr[30:25],instr[11:8],1'b0}),
        .seout(imm_b));
    /////////////////////////////////////////////////////Register file
    logic [31:0] from_RD1,from_RD2;
    logic [31:0] from_mp2_1_alu_dm;
    
    register_file rf(
        .clk(clk),
        .A1(instr[19:15]),
        .A2(instr[24:20]),
        .A3(instr[11:7]),
        .WD3(from_mp2_1_alu_dm),
        .WE3(reg_w_req),
        .RD1(from_RD1),
        .RD2(from_RD2));
    /////////////////////////////////////////////////////Multiplexer from RD1
    logic [31:0] from_mp3_1_RD1;
    logic [31:0] from_PC;
    mp3_1 RD1_PC_0(
        .ch_sig(a_sel),
        .sig0(from_RD1),
        .sig1(from_PC),
        .sig2(32'b0),
        .out(from_mp3_1_RD1));
    ////////////////////////////////////////////////////Multiplexer from RD2
    logic [31:0] from_mp5_1_RD2;
    mp5_1 RD2_immi_instr_imms_4(
        .ch_sig(b_sel),
        .sig0(from_RD2),
        .sig1(imm_i),
        .sig2({instr[31:12],12'b0}),
        .sig3(imm_s),
        .sig4(32'b100),
        .out(from_mp5_1_RD2));
    //////////////////////////////////////////////////ALU
    logic [31:0] from_alu;
    logic comp;
    alu alu_op(
        .A(from_mp3_1_RD1),
        .B(from_mp5_1_RD2),
        .FLAG(comp),
        .ALUOp(alu_op_o),
        .RES(from_alu));
    //////////////////////////////////////////////////Data Memory
    logic [31:0] from_dm;
    data_memory dm(
        .clk(clk),
        .A(from_alu),
        .WD(from_RD2),
        .WE(data_mem_w_req),
        .RD(from_dm));
    //////////////////////////////////////////////////Multiplexer from ALU
    
    mp2_1 alu_dm(
        .ch_sig(alu_or_dm),
        .sig1(from_dm),
        .sig0(from_alu),
        .out(from_mp2_1_alu_dm));
    /////////////////////////////////////////////////Adder + IM + PC
    
    logic sig_for_mp2_1_adder;
    logic [31:0] from_mp2_1_adder;
    logic [31:0]from_mp2_1_imm_j_imm_b;
    
    assign sig_for_mp2_1_adder = jal|(comp&branch);
    
    mp2_1 mp2_1_imm_j_imm_b(
        .ch_sig(branch),
        .sig0(imm_j),
        .sig1(imm_b),
        .out(from_mp2_1_imm_j_imm_b));
        
    logic [31:0] sig_4;
    assign sig_4 = 32'd4;
    
    mp2_1 mp2_1_4_mp2_1(
        .ch_sig(sig_for_mp2_1_adder),
        .sig0(sig_4),
        .sig1(from_mp2_1_imm_j_imm_b),
        .out(from_mp2_1_adder));
    
    logic [31:0] from_adder;
    
    adder adderPC(
        .A(from_PC),
        .B(from_mp2_1_adder),
        .out(from_adder));    
    
    
    logic[31:0] from_mp2_adder_rd1_immi;
    mp2_1  adder_RD1_imm_l(
        .ch_sig(jalr),
        .sig0(from_adder),
        .sig1(from_RD1+imm_i),
        .out(from_mp2_adder_rd1_immi));
    
    program_counter PC(
        .clk(clk),
        .rst(rst),
        .in(from_mp2_adder_rd1_immi),
        .out(from_PC));
        
    instruction_memory IM(
        .A(from_PC),
        .RD(instr));
    
endmodule
