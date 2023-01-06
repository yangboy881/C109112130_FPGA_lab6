`timescale 1ns / 1ps

module div_ch(divclk_c1,divclk_c2,divclk_c3,divclk_c4,divclk_c5,clk,rst,LED_Lin,LED_Rin,Randon_out); // divclk_2 約23一秒

output divclk_c1,divclk_c2,divclk_c3,divclk_c4,divclk_c5; //divclk_2
output [2:0] Randon_out;
input clk,rst,LED_Lin,LED_Rin;
reg [26:0] divclkcnt;
reg [2:0] rand;  //亂數魔球

assign divclk_c1 = divclkcnt[21]; //移位暫存
assign divclk_c2 = divclkcnt[22]; //移位暫存
assign divclk_c3 = divclkcnt[23]; //移位暫存
assign divclk_c4 = divclkcnt[24]; //移位暫存
assign divclk_c5 = divclkcnt[25]; //移位暫存
assign Randon_out= rand;
 


always@(posedge clk or negedge rst)begin
    if(~rst)
        divclkcnt <= 0;
    else
        divclkcnt <= divclkcnt + 1;
end

always@(posedge clk or negedge rst)begin
    if(~rst)
        rand <= 5'd0;
    else if(LED_Lin) rand <= {$random} % 3'd5; //0to4
    else if(LED_Rin) rand <= {$random} % 3'd5; //0to4
    else rand <= rand;
end


endmodule
