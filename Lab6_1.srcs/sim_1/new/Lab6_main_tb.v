module two_bord_tb;

	// Inputs
	reg SW_R;
	reg clk;
	reg rst;

	// Outputs
	wire [7:0] LED_R;

	// Bidirs
	wire Dinout;

	// Instantiate the Unit Under Test (UUT)
	two_bord uut (
		.SW_R(SW_R), 
		.clk(clk), 
		.rst(rst), 
		.Dinout(Dinout), 
		.LED_R(LED_R)
	);

	initial begin
		// Initialize Inputs
		SW_R = 0;
		clk = 0;
		rst = 1;
		#20 rst = 0;
		#20 SW_R = 1;
		#50 Dinout = 1;
		#50 Dinout = 0;

		// Wait 100 ns for global reset to finish
		#1000;
        
		// Add stimulus here

	end
	
        initial forever #2 clk=~clk;
endmodule