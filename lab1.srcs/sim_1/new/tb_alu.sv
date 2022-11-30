`timescale 1ns / 1ps

`include "operation_define.sv"

module tb_alu(

    );
logic [`N-1:0]A, B, RES;
logic [4:0]ALUOp;
logic FLAG;

    
    
    
alu_riscv dut(A,B,ALUOp,FLAG,RES);

    initial begin
            test(5,6, `ADD);
            test(6,7, `SUB);
            test(5,6, `SLL);
            test(7,6, `SLT);
            test(5,6, `SLTU);
            test(7,6, `XOR);
            test(5,6, `SRL);
            test(7,6, `SRA);
            test(5,6, `OR);
            test(7,6, `AND);
            test(5,6, `BEQ);
            test(7,6, `BNE);
            test(5,6, `BLT);
            test(7,6, `BGE);
            test(5,6, `BLTU);
            test(7,6, `BGEU);
            test(1,1,5'b10000);
        end
    
    task test;
    input [`N-1:0] a_t, b_t;
    input [4:0]aluop_t;
        begin
            A=a_t;
            B=b_t;
            ALUOp=aluop_t;
            #100
            if(aluop_t==`ADD)  
                if(RES==(a_t+b_t))
                    $display("GOOD");
                else
                    $display("BAD");
            if(aluop_t==`SUB)
                if(RES==(a_t-b_t))
                    $display("GOOD");
                else
                    $display("BAD");
             if(aluop_t==`SLL)   
                if(RES==(a_t<<b_t))
                    $display("GOOD");
                else
                    $display("BAD");
              if(aluop_t==`SLT)   
                if(RES==($signed(a_t<b_t)))
                    $display("GOOD");
                else
                    $display("BAD");  
                    
               if(aluop_t==`SLTU)   
                if(RES==(a_t<b_t))
                    $display("GOOD");
                else
                    $display("BAD");   
                    
               if(aluop_t==`XOR)   
                if(RES==(a_t^b_t))
                    $display("GOOD");
                else
                    $display("BAD");     
               
               if(aluop_t==`SRL)   
                if(RES==(a_t>>b_t))
                    $display("GOOD");
                else
                    $display("BAD");     
                    
               if(aluop_t==`SRA)   
                if(RES==($signed(a_t)>>>b_t))
                    $display("GOOD");
                else
                    $display("BAD");     
                    
               if(aluop_t==`OR)   
                if(RES==(a_t|b_t))
                    $display("GOOD");
                else
                    $display("BAD");      
                    
               if(aluop_t==`AND)   
                if(RES==(a_t&b_t))
                    $display("GOOD");
                else
                    $display("BAD");     
                    
                if(aluop_t==`BEQ)   
                    if(FLAG==(a_t==b_t))
                        $display("GOOD");
                    else
                        $display("BAD");  
                
                if(aluop_t==`BLT)   
                    if(FLAG==$signed(a_t<b_t))
                        $display("GOOD");
                    else
                        $display("BAD");   
                    
                if(aluop_t==`BGE)   
                    if(FLAG==$signed(a_t>=b_t))
                        $display("GOOD");
                    else
                        $display("BAD"); 
                    
                if(aluop_t==`BLTU)   
                    if(FLAG==a_t<b_t)
                        $display("GOOD");
                    else
                        $display("BAD");         
                    
                if(aluop_t==`BGEU)   
                    if(FLAG==a_t>=b_t)
                        $display("GOOD");
                    else
                        $display("BAD"); 
                        
        
                    
        end
    endtask    

endmodule
