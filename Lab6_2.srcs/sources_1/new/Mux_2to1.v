`timescale 1ns / 1ps


module Mux2to1_8bit(
    input [7:0] in_A,
    input [7:0] in_B,
    input sel,
    output [7:0] Mux_out
    );

reg [7:0] Mux_out;

always @(in_A or in_B or sel)begin
		case(sel)
			1'b0 : Mux_out = in_A;
			1'b1 : Mux_out = in_B;
			default : Mux_out = in_A;
		endcase
end    
    
endmodule

