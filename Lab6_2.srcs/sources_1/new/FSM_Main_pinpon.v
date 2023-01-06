`timescale 1ns / 1ps


module FSM_Main_pinpon(
    input In_right_go,
    output [3:0] CNT_right_go,
	output [7:0] led_light,
	input clk_en,		//給按鈕、FSM判斷用
    input clk_fast,		//給按鈕、FSM判斷用
	input clk_slow,		//給FSM改狀態用，FOR移位暫存器
    input rst_n,
    inout Dinout
    );

//reg [7:0] ball = 8'b0000_0001; //移位暫存器，reg(7:1)和(0)



parameter IDLE = 3'b000;
parameter S0   = 3'b001;
parameter S1   = 3'b010;
parameter S2   = 3'b011;
parameter S3   = 3'b100;
parameter S4   = 3'b101;

reg sel;
reg num_right;
reg num_left;
reg [7:0] led_out;
reg [3:0] cnt_left;
reg [3:0] cnt_right;
reg [2:0] curr_state;

reg Din,Dout;
reg en;
reg en_up;
reg [2:0] cnt_en;
reg [2:0] Din_go;
reg [1:0] in_right_en;


assign in_right		      = In_right_go;
assign CNT_right_go[3:0]  =  cnt_right[3:0];
assign led_light[7:0]  =  led_out[7:0];

//inout判斷

assign Dinout=en? Dout:1'bz; //1：Dout，0：Din，前if 後else
always@(posedge clk_en or negedge rst_n) begin 
    if (~rst_n)
        Din<= 1'b0;
    else if(!en)
        Din <= Dinout;
end



// FSM判斷   
always@(posedge clk_fast or negedge rst_n) begin
   if (~rst_n) begin
        curr_state <= IDLE; 
        in_right_en <= 2'b11;
   end  
   else begin
   case (curr_state)
   IDLE    : curr_state <= S0;  	//0
	//右邊發球
   S0      : if (in_right && in_right_en >= 2'b11)begin
                 curr_state <= S1;	//1
                 in_right_en <= 0;
             end
             else begin
                     curr_state <= S0;			//0
                     in_right_en <= in_right_en+1'b1;
             end
	//往左移動
   S1      : if (led_out == 8'b0000_0000)begin
                 curr_state <= S2;	//1
             end
             else     curr_state <= S1;			//0
	//等球來
   S2      : if (in_right) curr_state <= S4;	//早按下=>輸贏狀態			
			 else if (~Din)  curr_state <= S3;    //球來了=>進入右移			
             else     curr_state <= S2;			//否則繼續
	//往右移動
   S3      : if (in_right && led_out == 8'b0000_0001)     curr_state <= S1;	      //打到球
		     else if (in_right && led_out > 8'b0000_0001) curr_state <= S0;       //我早按
		     else if (led_out == 1'b0 && Din_go == 2'b11)   curr_state <= S0;       //我晚按
             else     curr_state <= S3;			//否則繼續
             
   S4      : if (~Din) curr_state <= S0;	    //收到en
             else      curr_state <= S4;	    //否則繼續
             				 
    default :         curr_state <= IDLE;
  endcase
  end //rst   
end  

//en控制
always@(posedge clk_fast or negedge rst_n) begin
   if (~rst_n) begin
        cnt_en <= 0;
        en <=0;
   end   
   else begin
   case (curr_state)
   S0      : cnt_en <= 0;
	//往左移動
   S1      : cnt_en <= 0;
	//等球來
   S2      : if (cnt_en < 3'b111) begin
                 cnt_en <= cnt_en+1;	//cnt_en數到6		
                 en <= 1;
             end	
			 else begin
			     cnt_en <= cnt_en;
			     en <= 0;    
			 end
	//往右移動             				 
    default : begin  
                 en <= 0;
                 cnt_en <= 0;
              end
  endcase
  end //rst   
end  



always@(posedge clk_fast or negedge rst_n) begin  //加分判定
	if (~rst_n) begin
		cnt_right <= 4'b0;
		num_right <= 1;
	end
	else begin
	case (curr_state)
	S0      :  //回到發球變數卡住
			num_right <=1;
	S1      :	;
	S2      :	;	
	S3      :												//左邊加分條件
		if ({in_right && led_out > 8'b0000_0001} || led_out == 1'b0) begin
			if(num_right)begin
				cnt_right		<= cnt_right+1'b1;			//左邊+1分(預設計對方的分數，所以是右邊+1分)
				num_right		<= 0;
			end
			else num_right  <= num_right;		//不動
		end
		else cnt_right  <= cnt_right;//不動
		
	S4      :												//左邊加分條件
		if (~Din) begin
			if(num_right)begin
				cnt_right		<= cnt_right+1'b1;			//左邊+1分(預設計對方的分數，所以是右邊+1分)
				num_right		<= 0;
	        end
		    else  num_right  <= num_right;		//不動
		end
		else cnt_right  <= cnt_right;//不動
		
	default :  ;
	endcase
	end
end


//移位暫存器(左右移)慢的CLK
always@(posedge clk_slow or negedge rst_n)begin
	if (~rst_n) begin
		led_out <= 8'b0000_0001;  //定義0000_0001，右邊發球
		Din_go <= 1'b0;
	end
	else begin
	case (curr_state)
		S0		:	led_out <= 8'b0000_0001;
		S1		:	begin
		                 led_out <= {led_out[6:0],1'b0};  //左移
		                 Din_go <= 1'b0;
		            end
		S2		:   begin
		                 led_out <= 8'b0000_0000;         //等球
		                 Din_go <= 1'b0;
		            end
		S3		:	if(Din_go < 2'b11)begin
		                 led_out <= 8'b1000_0000;
		                 Din_go <= Din_go+1'b1;
		            end
		            else led_out <= {1'b0,led_out[7:1]};  //等Din_go  Din_go <= 1'b1，LED規0後右移
		S4		:	led_out <= 8'b0000_0000;
		default :         led_out <= led_out;		 //都不是
	endcase
	end
end

//de_btn  防止常按連續得分(左) 1可能分，0防止得分

endmodule
