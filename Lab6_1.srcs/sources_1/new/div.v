`timescale 1ns / 1ps

module div(divclk_1,clk,rst); // divclk_2 ��23�@��

output divclk_1;
input clk,rst;
reg [15:0]divclkcnt;

assign divclk_1 = divclkcnt[13]; //���s���u��

always@(posedge clk or negedge rst)begin
    if(~rst)
        divclkcnt = 0;
    else
        divclkcnt = divclkcnt + 1;
end

endmodule

