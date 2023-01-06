`timescale 1ns / 1ps


  module Lab6_EASY(  //�����W
    input en,
    input clk,
    input rst,
    inout Dinout,
    output [7:0] LED_R
    );

reg Din,Dout;
reg [7:0] LED_R;



assign Dinout=en? Dout:1'bz; //1�GDout�A0�GDin�A�eif ��else
always@(posedge clk or negedge rst) begin 
    if (~rst)
        Din<= 1'b0;
    else if(!en)
        Din <= Dinout;
end


always@(posedge clk or negedge rst) begin
    if (~rst)
        LED_R <= 8'd0;
    else if(~Din)
        LED_R <= 8'b11111111;
    else
        LED_R <= 8'd0;
end

endmodule
