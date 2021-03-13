//
//Pincode check statemachine
//------------------------
//By: Henry Fielding
//Date: 12/03/2021
//
//Description
//------------
//Instatiates pincode tester submodules to test if the pin code entry works.

`timescale 1 ns/100 ps

module pinCodeTester_tb;
// declare testing parameters
localparam DIGITS = 4;
parameter CODE_LENGTH = 4*DIGITS; // bits required to store unlock code
parameter COUNTER_WIDTH =  $clog2(DIGITS);

// testbench generated signals
reg clock;
reg reset;
reg [3:0] key;
reg [CODE_LENGTH-1:0] pinCode;

// DUT output signals
wire unlock;
wire [CODE_LENGTH-1:0] pinEntry;
wire [COUNTER_WIDTH:0] digitCounter;
// instantiate DUT

pinCodeTester #(
	.DIGITS 	(DIGITS	)
	
) pinCodeTester_dut (
	.clock	(clock	),
	.reset	(reset	),
	
	.key		(key		),
	.pinCode	(pinCode	),
	
	.unlock		(unlock		),
	.pinEntry	(pinEntry	),
	.digitCounter	(digitCounter)
);

// define testbench variables

// Define test regime
initial begin
$monitor("%d ns \t clock = %b \t reset = %b \t key = %b \t pinEntry = %b \t digitcount = %d \t unlock = %b", $time, clock, reset, key, pinEntry, digitCounter, unlock);
	
	reset = 1'b1;
	clock = 1'b0;
	pinCode = 16'h8481;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	
	reset = 1'b0;
	
	
	//enter 1 digit
	key = 4'b0001;
	clock = !clock;
	#10
	key = 4'b0000;
	clock = !clock;
	#10
	
	//enter 2 digit
	key = 4'b0010;
	clock = !clock;
	#10
	key = 4'b0000;
	clock = !clock;
	#10
	
	//wait 2 clock cycles
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	
	// enter 3 digit
	key = 4'b0100;
	clock = !clock;
	#10
	key = 4'b0000;
	clock = !clock;
	#10
	
	// enter 4 digit
	key = 4'b1000;
	clock = !clock;
	#10
	key = 4'b0000;
	clock = !clock;
	#10
	
	//wait 2 clock cycles
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10

	// attempt 2 correct
	
		//enter 1 digit
	key = 4'b1000;
	clock = !clock;
	#10
	key = 4'b0000;
	clock = !clock;
	#10
	
	//enter 2 digit
	key = 4'b0100;
	clock = !clock;
	#10
	key = 4'b0000;
	clock = !clock;
	#10
	
	// enter 3 digit
	key = 4'b1000;
	clock = !clock;
	#10
	key = 4'b0000;
	clock = !clock;
	#10
	
	// enter 4 digit
	key = 4'b0001;
	clock = !clock;
	#10
	key = 4'b0000;
	clock = !clock;
	#10

	//wait 2 clock cycles
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;

end

endmodule 