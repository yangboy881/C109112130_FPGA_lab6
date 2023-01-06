`timescale 1ns / 1ps


module Lab6_top(
        input SW_R,
        input clk,
        input rst,
        inout Dinout_top,
        output [7:0] LED_R
    );
    

wire clk_out_1,de_R;

de_jump de_right(.Din(~SW_R),.Dout(de_R),.clk(clk_out_1),.reset(~rst));  //«ö¶s¨¾¼u¸õ

div div_go(.divclk_1(clk_out_1),.clk(clk),.rst(~rst));  //°£ÀW[0]¡B[1]¡B[5]

Lab6_EASY Lab6_EASY_GO(.en(de_R),.clk(clk_out_1),.rst(~rst),.Dinout(Dinout_top),.LED_R(LED_R));


endmodule
