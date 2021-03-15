//
//Digital lock toplevel
//------------------------
//By: Henry Fielding
//Date: 13/03/2021
//
//Description
//------------
//The toplevel file for the digital lock

module digitalLock #(
	// declare parameters
	parameter CLOCK_FREQ = 50000000,
	parameter PASSCODE_LENGTH = 4,					// number of digits in unlock code
	parameter PASSCODE_WIDTH = 4*PASSCODE_LENGTH	// bits required to store unlock code
)(
	// declare ports
	input clock,
	input reset,
	input [3:0] key,
	
	output locked,
	output error,
	output [47:0] displays
);

//
// declare internal connections
//
wire [PASSCODE_WIDTH-1:0] userEntry;

//
// instantiate modules
//
LockStateMachine #(
	// define parameters
	.CLOCK_FREQ 		(CLOCK_FREQ			),
	.PASSCODE_LENGTH 	(PASSCODE_LENGTH	)
) lock (
	// define connections
	.clock		(clock	),
	.reset		(reset	),
	.key			(key		),
	
	.locked		(locked		),
	.error		(error		),
	.userEntry	(userEntry	)
);

displayStateMachine #(
	// define parameters
	.PASSCODE_LENGTH (PASSCODE_LENGTH	)
) display (
	// define connections
	.clock		(clock		),
	.reset		(reset		),
	.error		(error		),
	.userEntry	(userEntry	),
	
	.displays	(displays	)
);

endmodule
