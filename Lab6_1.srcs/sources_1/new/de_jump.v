`timescale 1ns / 1ps

module de_jump(Din,Dout,clk,reset);
input Din,clk,reset;
output Dout;

reg Dout;
reg [3:0] as,cs;

always @(*)begin
	case(cs)
	4'd0:
		as<=(Din)? 4'd0:4'd1;
	4'd1:
		as<=(Din)? 4'd0:4'd2;
	4'd2:
		as<=(Din)? 4'd0:4'd3;
	4'd3:
		as<=(Din)? 4'd0:4'd4;
	4'd4: //分界，0-4按下，4-8放開
		as<=(Din)? 4'd5:4'd4;
	4'd5:
		as<=(Din)? 4'd6:4'd4;
	4'd6:
		as<=(Din)? 4'd7:4'd4;
	4'd7:
		as<=(Din)? 4'd8:4'd4;
	4'd8:
		as<=(Din)? 4'd0:4'd4;
	default:
		as<=4'd0;
	endcase
end

always@(posedge clk or negedge reset)
	if(!reset)
		cs <= 4'd0;
	else
		cs <=as;
	
always@(*)begin
	case(cs)
	4'd0:
		Dout<=1'b0;
	4'd1:
		Dout<=1'b0;
	4'd2:
		Dout<=1'b0;
	4'd3:
		Dout<=1'b0;
	4'd4: //分界
		Dout<=1'b1;
	4'd5:
		Dout<=1'b1;
	4'd6:
		Dout<=1'b1;
	4'd7:
		Dout<=1'b1;
	4'd8:
		Dout<=1'b1;
	default:
		Dout<=1'b0;
	endcase
end

endmodule
