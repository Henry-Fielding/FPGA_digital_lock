//
//Digital lock statemachine
//------------------------
//By: Henry Fielding
//Date: 13/03/2021
//
//Description
//------------
//Statemachine for a digital lock, Reads an inputs code then locks or unlocks 
//the lock if the code is correct

module digitalLock #(
	// declare parameters
	parameter DIGITS = 4, // number of digits in unlock code
	parameter CODE_LENGTH = 4*DIGITS, // bits required to store unlock code
	parameter COUNTER_WIDTH =  $clog2(DIGITS)
)(
	// declare ports
	input clock,
	input reset,
	
	input [3:0] key,

	
	output reg locked,
);

	input [CODE_LENGTH-1:0] pinCode;
	output reg [CODE_LENGTH-1:0] pinEntry;
	output reg [COUNTER_WIDTH:0] digitCounter;


// toplevel statemachine

// Locked sub-statemachine

//	unlocked sub-statemachine

endmodule