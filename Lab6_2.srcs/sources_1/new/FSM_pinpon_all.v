
`timescale 1ns / 1ps

module FSM_pinpon_all(clk,rst,IN_right,Sel_IN,Sel_CH,Mux2_pinpon_out,Dinout_top); //CNT_left,CNT_right,CNT_seg7

input clk,rst;
input IN_right,Sel_IN,Sel_CH; //IN_left
//output [1:0] seg7_outselect;
output [7:0] Mux2_pinpon_out;
inout Dinout_top;

//output [3:0] CNT_left,CNT_right;
//wire [3:0] CNT_seg7;
//wire [3:0] s1_seg7;
wire clk_out_1,clk_out_2,clk_out_3,clk_out_4,de_L,de_R,divclk_been;
//wire divclk_c1,divclk_c2,divclk_c3,divclk_c4,divclk_c5,divclk_ran;
wire [3:0] CNT_right;
wire [7:0] led_pinpon,CNT_in;
wire [2:0] Randon_out;

assign CNT_in[3:0] = CNT_right [3:0];


//Div_web Div_forFSM(.CLK(clk), .RST(~rst), .CLK_Out1(clk_out_1), .CLK_Out2(clk_out_2), .CLK_Out3(clk_out_3));

//de_jump de_left (.Din(~IN_left),.Dout(de_L),.clk(clk_out_1),.reset(~rst));  //按鈕防彈跳
de_jump de_right(.Din(~IN_right),.Dout(de_R),.clk(clk_out_1),.reset(~rst)); //按鈕防彈跳

FSM_Main_pinpon Main_FSM_1(.In_right_go(de_R),.CNT_right_go(CNT_right),.led_light(led_pinpon),.clk_en(clk_out_1),
									.clk_fast(clk_out_2),.clk_slow(divclk_been),.rst_n(~rst),.Dinout(Dinout_top));

Mux2to1_8bit Mux2to1_forCNT(.in_A(led_pinpon),.in_B(CNT_in),.sel(Sel_IN),.Mux_out(Mux2_pinpon_out)); // in_A球，in_B分數
				
									
div div_1(.divclk_1(clk_out_1),.divclk_2(clk_out_2),.divclk_3(clk_out_3),.divclk_4(clk_out_4),.clk(clk),.rst(~rst));  //除頻[0]、[1]、[5]
div_ch Div_radon(.divclk_c1(divclk_c1),.divclk_c2(divclk_c2),.divclk_c3(divclk_c3),.divclk_c4(divclk_c4),.divclk_c5(divclk_c5),
                    .clk(clk),.rst(~rst),.LED_Lin({led_pinpon[0]}),.LED_Rin({led_pinpon[7]}),.Randon_out(Randon_out));

Mux2to1_forRandon Mux_ch(.in_A(clk_out_3),.in_B(clk_out_4),.sel(Sel_CH),.Mux_out(divclk_been)); // in_A球，in_B分數

//Mux5to1_forRandon M5(.in_A(divclk_c1),.in_B(divclk_c2),.in_C(divclk_c3),.in_D(divclk_c4),.in_E(divclk_c5),.sel_Randon(Randon_out),.Mux_out(divclk_ran));



//mux_sel m1(.in_cnt_R(CNT_right),.in_cnt_L(CNT_left),.sel(sel),.rst(~rst),.cnt_out(CNT_seg7));
//seg7 seg7_1(.seg7_out(seg7_out),.seg7_in(CNT_seg7));  //七段顯示器：計分數[左邊第1.2個值]、計時器[左邊第3.4個值]
//seg7out_switch S1(.seg7_selected(seg7_outselect),.seg7outvalue(s1_seg7),.in0(CNT_left),  //快速掃描7段顯示器，讓4個數字都能呈現 CNT_R:IN1 CNT_L:IN2
//					.in1(CNT_right),.clk(clk_out_1),.rst(rst));


endmodule


