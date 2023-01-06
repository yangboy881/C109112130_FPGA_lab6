`timescale 1ns / 1ps


module Mux2to1_forRandon(
    input  in_A,
    input  in_B,
    input  sel,
    output Mux_out
    );

reg  Mux_out;

always @(in_A or in_B or sel)begin
		case(sel)
			1'b0 : Mux_out = in_A;
			1'b1 : Mux_out = in_B;
			default : Mux_out = in_A;
		endcase
end    
    
endmodule
