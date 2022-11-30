`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2022 15:40:04
// Design Name: 
// Module Name: sim_proc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sim_proc(

    );
    logic clk,rst;
    initial begin
        #(PERIOD/4)
        assign rst = 1;
        #(PERIOD)
        assign rst = 0;
    end
    logic [31:0]  out;

   parameter PERIOD = 20;

   always begin
      clk = 1'b0;
      #(PERIOD/2) clk = 1'b1;
      #(PERIOD/2);
   end
    
    tract check(.clk(clk),.rst(rst),.out(out));
endmodule
