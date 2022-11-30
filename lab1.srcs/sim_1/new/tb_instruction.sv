`timescale 1ns / 1ps


module tb_instruction(

    );
    
    logic [7:0] A;
    logic [31:0] RD;
    instruction_memory dut(.*);
    integer i;
    integer file_mem;
    
    logic [31:0] new_data;
    
    initial
        file_mem = $fopen(" D:/MIET/APS_labs/lab1/instruction.txt","r");
        
        
    initial begin
        for(i = 0; i < 4; i = i + 1) begin
            A = i;
            $fscanf(file_mem,"%b",new_data);
            #20;
            if(new_data!=RD) begin
                $display($time,"BAD! adr = %d, file = %h, memory = %h", A, 
                new_data, RD);
                
            end
        end    
        $fclose(file_mem);
        $finish;
    end
    
    endmodule
