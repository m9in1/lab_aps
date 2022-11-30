`timescale 1ns / 1ps
`include "operation_define.sv"

module decoder_riscv(
      input       [31:0]  fetched_instr_i,
      output  reg [1:0]   ex_op_a_sel_o,      // Управляющий сигнал мультиплексора для выбора первого операнда АЛУ
      output  reg [2:0]   ex_op_b_sel_o,      // Управляющий сигнал мультиплексора для выбора второго операнда АЛУ
      output  reg [4:0]   alu_op_o,           // Операция АЛУ
      output  reg         mem_req_o,          // Запрос на доступ к памяти (часть интерфейса памяти)
      output  reg         mem_we_o,           // Сигнал разрешения записи в память, «write enable» (при равенстве нулю происходит чтение)
      output  reg [2:0]   mem_size_o,         // Управляющий сигнал для выбора размера слова при чтении-записи в память (часть интерфейса памяти)
      output  reg         gpr_we_a_o,         // Сигнал разрешения записи в регистровый файл
      output  reg         wb_src_sel_o,       // Управляющий сигнал мультиплексора для выбора данных, записываемых в регистровый файл
      output  reg         illegal_instr_o,    // 
      output  reg         branch_o,           // Сигнал об инструкции условного перехода
      output  reg         jal_o,              // Сигнал об инструкции безусловного перехода jal
      output  reg         jalr_o              // Сигнал об инструкции безусловного перехода jalr
    
    );
    logic [31:0] f;
    assign f = fetched_instr_i;
    
    logic [6:0]opcode;
    logic [31:0] imm;
    logic [4:0] rs1,rs2;
    logic [6:0] func7;
    logic [2:0] func3;
    logic [4:0] rd;
    
    
    
    assign opcode = f[6:0];
    
    always@(f) begin
        if(opcode[1:0]!=2'b11)begin
            illegal_instr_o <= 1;
        end
        else begin
            case(opcode[6:2])
                7'b01100: begin //OP
                    illegal_instr_o <= 0;
                    gpr_we_a_o<=1;
                    ex_op_a_sel_o<=0;
                    ex_op_b_sel_o<=0;
                    wb_src_sel_o<=0;
                    mem_req_o<=0;
                    mem_we_o<=0;
                    mem_size_o<=0;
                    branch_o<=0;
                    jal_o<=0;
                    jalr_o<=0;
                    
                    func7<=f[31:25];
                    rs2<=f[24:20];
                    rs1<=f[19:15];
                    func3<=f[14:12];
                    rd<=f[11:7];
                    case(f[31:25])
                        7'b0000000: begin//add sll slt sltu xor srl or and
                             case(f[14:12]) 
                                3'b000: alu_op_o <= `ADD;
                                3'b001: alu_op_o<=`SLL;
                                3'b010: alu_op_o <= `SLT;
                                3'b011: alu_op_o <= `SLTU;
                                3'b100: alu_op_o <= `XOR;
                                3'b101: alu_op_o <= `SRL;
                                3'b110: alu_op_o <= `OR;
                                3'b111: alu_op_o <= `AND;
                             endcase
                        end
                        7'b0100000: begin //sub sra
                            case(f[14:12])
                                3'b000: alu_op_o<=`SUB;
                                3'b101: alu_op_o<=`SRA;
                                default: illegal_instr_o<=1;
                            endcase 
                        
                        end
                        default: illegal_instr_o<=1;
                    endcase
                end
                
                7'b00100: begin //OP_IMM
                    illegal_instr_o <= 0;
                    gpr_we_a_o<=1;
                    ex_op_a_sel_o<=0;
                    ex_op_b_sel_o<=1;
                    wb_src_sel_o<=0;
                    mem_req_o<=0;
                    mem_we_o<=0;
                    mem_size_o<=0;
                    branch_o<=0;
                    jal_o<=0;
                    jalr_o<=0;
                    
                    imm[11:0]<=f[31:20];
                    rs1<=f[19:15];
                    func3<=f[14:12];
                    rd<=f[11:7];
                    case(f[14:12])
                        3'b000: alu_op_o<=`ADD;
                        3'b010: alu_op_o<=`SLT;
                        3'b011: alu_op_o<=`SLTU;
                        3'b100: alu_op_o<=`XOR;
                        3'b110: alu_op_o<=`OR;
                        3'b111: alu_op_o<=`AND;
                        3'b001: begin
                            case(f[31:25]) 
                                7'b0000000: alu_op_o<=`SLL;
                                default: illegal_instr_o<=1;
                            endcase
                        end
                        3'b101: begin
                            case(f[31:25])
                                7'b0000000: alu_op_o<=`SRL;
                                7'b0100000: alu_op_o<=`SRA;
                                default: illegal_instr_o<=1;
                            endcase
                        
                        end
                    endcase
                end
                
                7'b00000: begin //LOAD
                    illegal_instr_o <= 0;
                    gpr_we_a_o<=1;
                    ex_op_a_sel_o<=0;
                    ex_op_b_sel_o<=1;
                    wb_src_sel_o<=1;
                    mem_req_o<=1;
                    mem_we_o<=0;
                    branch_o<=0;
                    jal_o<=0;
                    jalr_o<=0;
                    alu_op_o<=`ADD;
                    
                    imm[11:0]<=f[31:20];
                    rs1<=f[19:15];
                    func3<=f[14:12];
                    rd<=f[11:7];
                    case(f[14:12]) 
                        3'b000: begin//LB
                            mem_size_o<=0;
                        end
                        3'b001: begin//LH
                            mem_size_o<=1;
                        end
                        3'b010: begin//LW
                            mem_size_o<=2;
                        end
                        3'b100: begin//LBU
                            mem_size_o<=4;
                        end
                        3'b101: begin//LHU
                            mem_size_o<=5;
                        end
                        default: illegal_instr_o<=1;
                    endcase
                end
                
                7'b01000: begin//STORE
                    illegal_instr_o <= 0;
                    gpr_we_a_o<=0;
                    ex_op_a_sel_o<=0;
                    ex_op_b_sel_o<=3;
                    wb_src_sel_o<=0;
                    mem_req_o<=1;
                    mem_we_o<=1;
                    branch_o<=0;
                    jal_o<=0;
                    jalr_o<=0;
                    alu_op_o<=`ADD;
                    
                    {imm[11:5],imm[4:0]}<={f[31:25],f[11:7]};
                    rs2<=f[24:20];
                    rs1<=f[19:15];
                    func3<=f[14:12];
                    case(f[14:12])
                        3'b000: mem_size_o<=0;
                        3'b001: mem_size_o<=1;
                        3'b010: mem_size_o<=2;
                        default: illegal_instr_o<=1;
                    endcase
                end
                
                7'b11000: begin//BRANCH
                    illegal_instr_o <= 0;
                    gpr_we_a_o<=0;
                    ex_op_a_sel_o<=0;
                    ex_op_b_sel_o<=0;
                    wb_src_sel_o<=0;
                    mem_req_o<=0;
                    mem_we_o<=0;
                    mem_size_o<=0;
                    branch_o<=1;
                    jal_o<=0;
                    jalr_o<=0;
                    
                    {imm[12],imm[10:5],imm[4:1],imm[11]}<={f[31:25],f[11:7]};       
                    rs2<=f[24:20];
                    rs1<=f[19:15];
                    func3<=f[14:12];
                    case(f[14:12]) 
                        3'b000: alu_op_o<=`BEQ;
                        3'b001: alu_op_o<=`BNE;
                        3'b100: alu_op_o<=`BLT;
                        3'b101: alu_op_o<=`BGE;
                        3'b110: alu_op_o<=`BLTU;
                        3'b111: alu_op_o<=`BGEU;
                        default: illegal_instr_o<=1;
                    endcase
                end
                
                7'b11011: begin//JAL
                    illegal_instr_o <= 0;
                    gpr_we_a_o<=1;
                    ex_op_a_sel_o<=1;
                    ex_op_b_sel_o<=4;
                    wb_src_sel_o<=0;
                    mem_req_o<=0;
                    mem_we_o<=0;
                    mem_size_o<=0;
                    branch_o<=0;
                    jal_o<=1;
                    jalr_o<=0;
                    alu_op_o<=`ADD;
                    
                    {imm[20],imm[10:1],imm[11],imm[19:12]}<=f[31:12];
                    rd<=f[11:7];
                end
                
                 7'b11001: begin //JALR
                    illegal_instr_o <= 0;
                    gpr_we_a_o<=1;
                    ex_op_a_sel_o<=1;
                    ex_op_b_sel_o<=4;
                    wb_src_sel_o<=0;
                    mem_req_o<=0;
                    mem_we_o<=0;
                    mem_size_o<=0;
                    branch_o<=0;
                    jal_o<=0;
                    
                    alu_op_o<=`ADD;
                    
                    imm[11:0]<=f[31:20];
                    rs1<=f[19:15];
                    func3<=f[14:12];
                    rd<=f[11:7]; 
                    case(f[14:12])
                        3'b000: begin
                            jalr_o<=1;
                        
                        end
                        default: illegal_instr_o<=1;
                    
                    endcase
                end
                
                7'b01101: begin//LUI
                    illegal_instr_o <= 0;
                    gpr_we_a_o<=1;
                    ex_op_a_sel_o<=2;
                    ex_op_b_sel_o<=2;
                    wb_src_sel_o<=0;
                    mem_req_o<=0;
                    mem_we_o<=0;
                    mem_size_o<=0;
                    branch_o<=0;
                    jal_o<=0;
                    jalr_o<=0;
                    alu_op_o<=`ADD;
                    
                    imm[31:12]<=f[31:12];
                    rd<=f[11:7];
                end
                
                7'b00101: begin//AUIPC
                    illegal_instr_o <= 0;
                    gpr_we_a_o<=1;
                    ex_op_a_sel_o<=1;
                    ex_op_b_sel_o<=2;
                    wb_src_sel_o<=0;
                    mem_req_o<=0;
                    mem_we_o<=0;
                    mem_size_o<=0;
                    branch_o<=0;
                    jal_o<=0;
                    jalr_o<=0;
                    alu_op_o<=`ADD;
                    
                    imm[31:12]<=f[31:12];
                    rd<=f[11:7];
                end
                
                7'b00011: begin//MISC-MEM
                    illegal_instr_o <= 0;
                    gpr_we_a_o<=0;
                    ex_op_a_sel_o<=0;
                    ex_op_b_sel_o<=0;
                    wb_src_sel_o<=1;
                    mem_req_o<=0;
                    mem_we_o<=0;
                    branch_o<=0;
                    jal_o<=0;
                    jalr_o<=0;
                    
                    
                end
                7'b11100:begin//SYSTEM
                    illegal_instr_o <= 0;
                    gpr_we_a_o<=0;
                    ex_op_a_sel_o<=0;
                    ex_op_b_sel_o<=0;
                    wb_src_sel_o<=1;
                    mem_req_o<=0;
                    mem_we_o<=0;
                    branch_o<=0;
                    jal_o<=0;
                    jalr_o<=0;
                    
                end
                    
                
                
                default: illegal_instr_o<=1;
            endcase       
        end
    end
    
endmodule
