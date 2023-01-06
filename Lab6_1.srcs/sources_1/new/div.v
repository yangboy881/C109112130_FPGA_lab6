`timescale 1ns / 1ps

module div(divclk_1,clk,rst); // divclk_2 ¬ù23¤@¬í

output divclk_1;
input clk,rst;
reg [15:0]divclkcnt;

assign divclk_1 = divclkcnt[13]; //«ö¶s¨¾¼u¸õ

always@(posedge clk or negedge rst)begin
    if(~rst)
        divclkcnt = 0;
    else
        divclkcnt = divclkcnt + 1;
end

endmodule

