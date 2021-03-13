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

// testbench generated signals
reg clock;
reg reset;
reg [3:0] key;
reg [CODE_LENGTH-1:0] pinCode;

// DUT output signals
wire unlock;
wire [CODE_LENGTH-1:0] pinEntry;

// instantiate DUT

pinCodeTester #(
	.DIGITS 	(DIGITS	)
	
) pinCodeTester_dut (
	.clock	(clock	),
	.reset	(reset	),
	
	.key		(key		),
	.pinCode	(pinCode	),
	
	.unlock		(unlock		),
	.pinEntry	(pinEntry	)
);

// define testbench variables

// Define test regime
initial begin

end

endmodule 