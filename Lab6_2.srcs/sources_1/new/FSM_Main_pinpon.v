`timescale 1ns / 1ps


module FSM_Main_pinpon(
    input In_right_go,
    output [3:0] CNT_right_go,
	output [7:0] led_light,
	input clk_en,		//�����s�BFSM�P�_��
    input clk_fast,		//�����s�BFSM�P�_��
	input clk_slow,		//��FSM�窱�A�ΡAFOR����Ȧs��
    input rst_n,
    inout Dinout
    );

//reg [7:0] ball = 8'b0000_0001; //����Ȧs���Areg(7:1)�M(0)



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

//inout�P�_

assign Dinout=en? Dout:1'bz; //1�GDout�A0�GDin�A�eif ��else
always@(posedge clk_en or negedge rst_n) begin 
    if (~rst_n)
        Din<= 1'b0;
    else if(!en)
        Din <= Dinout;
end



// FSM�P�_   
always@(posedge clk_fast or negedge rst_n) begin
   if (~rst_n) begin
        curr_state <= IDLE; 
        in_right_en <= 2'b11;
   end  
   else begin
   case (curr_state)
   IDLE    : curr_state <= S0;  	//0
	//�k��o�y
   S0      : if (in_right && in_right_en >= 2'b11)begin
                 curr_state <= S1;	//1
                 in_right_en <= 0;
             end
             else begin
                     curr_state <= S0;			//0
                     in_right_en <= in_right_en+1'b1;
             end
	//��������
   S1      : if (led_out == 8'b0000_0000)begin
                 curr_state <= S2;	//1
             end
             else     curr_state <= S1;			//0
	//���y��
   S2      : if (in_right) curr_state <= S4;	//�����U=>��Ĺ���A			
			 else if (~Din)  curr_state <= S3;    //�y�ӤF=>�i�J�k��			
             else     curr_state <= S2;			//�_�h�~��
	//���k����
   S3      : if (in_right && led_out == 8'b0000_0001)     curr_state <= S1;	      //����y
		     else if (in_right && led_out > 8'b0000_0001) curr_state <= S0;       //�ڦ���
		     else if (led_out == 1'b0 && Din_go == 2'b11)   curr_state <= S0;       //�ڱ߫�
             else     curr_state <= S3;			//�_�h�~��
             
   S4      : if (~Din) curr_state <= S0;	    //����en
             else      curr_state <= S4;	    //�_�h�~��
             				 
    default :         curr_state <= IDLE;
  endcase
  end //rst   
end  

//en����
always@(posedge clk_fast or negedge rst_n) begin
   if (~rst_n) begin
        cnt_en <= 0;
        en <=0;
   end   
   else begin
   case (curr_state)
   S0      : cnt_en <= 0;
	//��������
   S1      : cnt_en <= 0;
	//���y��
   S2      : if (cnt_en < 3'b111) begin
                 cnt_en <= cnt_en+1;	//cnt_en�ƨ�6		
                 en <= 1;
             end	
			 else begin
			     cnt_en <= cnt_en;
			     en <= 0;    
			 end
	//���k����             				 
    default : begin  
                 en <= 0;
                 cnt_en <= 0;
              end
  endcase
  end //rst   
end  



always@(posedge clk_fast or negedge rst_n) begin  //�[���P�w
	if (~rst_n) begin
		cnt_right <= 4'b0;
		num_right <= 1;
	end
	else begin
	case (curr_state)
	S0      :  //�^��o�y�ܼƥd��
			num_right <=1;
	S1      :	;
	S2      :	;	
	S3      :												//����[������
		if ({in_right && led_out > 8'b0000_0001} || led_out == 1'b0) begin
			if(num_right)begin
				cnt_right		<= cnt_right+1'b1;			//����+1��(�w�]�p��誺���ơA�ҥH�O�k��+1��)
				num_right		<= 0;
			end
			else num_right  <= num_right;		//����
		end
		else cnt_right  <= cnt_right;//����
		
	S4      :												//����[������
		if (~Din) begin
			if(num_right)begin
				cnt_right		<= cnt_right+1'b1;			//����+1��(�w�]�p��誺���ơA�ҥH�O�k��+1��)
				num_right		<= 0;
	        end
		    else  num_right  <= num_right;		//����
		end
		else cnt_right  <= cnt_right;//����
		
	default :  ;
	endcase
	end
end


//����Ȧs��(���k��)�C��CLK
always@(posedge clk_slow or negedge rst_n)begin
	if (~rst_n) begin
		led_out <= 8'b0000_0001;  //�w�q0000_0001�A�k��o�y
		Din_go <= 1'b0;
	end
	else begin
	case (curr_state)
		S0		:	led_out <= 8'b0000_0001;
		S1		:	begin
		                 led_out <= {led_out[6:0],1'b0};  //����
		                 Din_go <= 1'b0;
		            end
		S2		:   begin
		                 led_out <= 8'b0000_0000;         //���y
		                 Din_go <= 1'b0;
		            end
		S3		:	if(Din_go < 2'b11)begin
		                 led_out <= 8'b1000_0000;
		                 Din_go <= Din_go+1'b1;
		            end
		            else led_out <= {1'b0,led_out[7:1]};  //��Din_go  Din_go <= 1'b1�ALED�W0��k��
		S4		:	led_out <= 8'b0000_0000;
		default :         led_out <= led_out;		 //�����O
	endcase
	end
end

//de_btn  ����`���s��o��(��) 1�i����A0����o��

endmodule
