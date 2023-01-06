`timescale 1ns / 1ps


  module two_bord(  //Τ埃繵
    input SW_R,
    input clk,
    input rst,
    inout Dinout,
    output [4:0] LED_R,
    output [1:0] LED_stat,
    output LED_in_or_out
    );

reg en;
reg Din,Dout;
reg [1:0]curr_state;
reg [4:0] LED_R;
reg [1:0] LED_stat;
reg LED_in_or_out;


parameter IDLE = 2'b00;
parameter S0   = 2'b01;
parameter S1   = 2'b10;
parameter S2   = 2'b11;

//inout

assign Dinout=en? Dout:1'bz; //1Dout0Din玡if else
always@(posedge clk or negedge rst) begin 
    if (~rst)
        Din<= 1'b0;
    else if(!en)
        Din <= Dinout;
end


//и璶北en
always@(posedge clk or negedge rst) begin  //北篈
    if (~rst) begin
		Dout <= 1'b0;
		Din  <= 1'b0;
	end
	else begin
    case (curr_state)
        IDLE    : if (~rst) curr_state <= IDLE;		//1
                  else     curr_state  <= S2;      //0
                     
         S0      : if (~rst) curr_state <= IDLE; //out
                   else if(SW_R)  begin
                            curr_state <= S1;    //1
                            Dout <=	1'b1;
                            Din  <= 1'b0;
                   end
                   else     curr_state <= S0;            //0
                   
         S1      : if (~rst) curr_state <= IDLE;  //in
                   else if (Din) begin
                            curr_state <= S0;    //1
                            Dout <=	1'b0;
                   end
                   else     curr_state <= S1;
                   
         S2      : if (~rst) curr_state <= IDLE;
                   else if (SW_R)curr_state <= S1;
                   else if (Din) curr_state <= S0;    //1                    
                   else      curr_state <= S2;  
                    
         default :  begin
                             Dout <=    1'b0;
                    end                
endcase                   
end 
end

always@(posedge clk or negedge rst) begin  //北篈ㄆン
    if (~rst) begin
		en   <= 1'b0;  //﹚竡秨﹍in篈ち传out祇癳1
		LED_stat <= 2'b00;
	end
	else begin
	case (curr_state)
		S0		:	begin              //Μ1
		               en   <= 1'b1;	   
		               LED_stat <= 2'b01;    
		            end
		            
		S1		:	begin
		               en   <= 1'b0;
		               LED_stat <= 2'b10; 
		            end
		S2		:	begin
		               en   <= 1'b0;
		               LED_stat <= 2'b11;  
		            end
		            
		default :   begin
		               en   <=  en;		 //常ぃ琌
		               LED_stat <= 2'b00;  
		            end
	endcase
	end

end

always@(posedge clk or negedge rst) begin
    if (~rst)
        LED_R <= 8'd0;
    else if(en)
        LED_R <= 8'b11111111;
    else
        LED_R <= 8'd0;
end

endmodule
