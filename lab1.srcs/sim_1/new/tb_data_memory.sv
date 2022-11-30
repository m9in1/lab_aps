`timescale 1ns / 1ps


module tb_data_memory(

    );
    
   logic clk;
   parameter PERIOD = 10;

   always begin
      clk = 1'b0;
      #(PERIOD/2) clk = 1'b1;
      #(PERIOD/2);
   end
    
    
    logic [31:0] A;
    logic [31:0] RD;
    logic WE;
    logic [31:0] WD;
    assign WE = 1;
    
    data_memory dut(.*);
    
    integer i;   
    logic [31:0] new_data;
        
    initial begin
        for(i = 0; i < 255; i = i + 1) begin
            A[9:2] = i;
            new_data = $random()%32;
            WD = new_data;
            #10;
            if(new_data!=RD) begin
                $display($time,"BAD READING! adr = %d, data = %h, memory = %h", A, new_data, RD);
                
            end
        end    
        $finish;
    end
    

    
    
    
    
    
    endmodule
