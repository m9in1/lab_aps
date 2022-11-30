`timescale 1ns / 1ps


module tb_register_file(

    );
    logic clk;
    logic [4:0] A1,A2,A3;
    logic [31:0] WD3;
    logic WE3 = 1;
    logic [31:0] RD1, RD2;
    parameter PERIOD = 10;

   always begin
      clk = 1'b0;
      #(PERIOD/2) clk = 1'b1;
      #(PERIOD/2);
   end
    register_file dut(.*);
    
    integer i;
    logic [31:0] new_data3;
    
    initial 
        for(i = 0;i < 32;i = i + 1) begin
            //new_data1 = $random()%32;
            //new_data2 = $random()%32;
            new_data3 = $random()%32;
            A3 = i;
            WD3 = new_data3;
            #10
            A1 = i;
            A2 = i;

            #10;
            if(RD1!=RD2 | RD1!=new_data3) 
                $display($time,"BAD! adr = %d, data = %h, memory = %h", A1, new_data3, RD1);
            
            
            
        end
    
    

endmodule
