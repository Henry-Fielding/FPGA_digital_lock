//
//7 Segment statemachine
//------------------------
//By: Henry Fielding
//Date: 14/03/2021
//
//Description
//------------
//tatemachine to display user input and error codes on the seven segment display bank

module displayStateMachine #(
	//declare parameters
	parameter PASSCODE_LENGTH = 4, 					// digits in unlock code
	parameter PASSCODE_WIDTH = 4*PASSCODE_LENGTH // bits required to store unlock code
)(
	//declare ports
	input clock,
	input reset,
	input error,
	input [PASSCODE_WIDTH-1:0] userEntry,
	
	output [47:0] displays
);

//
// declare internal connections
//
reg [23:0] hexInput;

//
// instatiate submodules
//
HexTo7SegmentNBit #(
	// define parameters
	.DISPLAYS	(6	)
) converter (
	// define connections
	.hex		(hexInput	),
	.display	(displays	)
);

//
// declare statemachine registers and statenames
//
reg state;
localparam INPUT_STATE = 1'd0;
localparam ERROR_STATE = 1'd1;

//
// define state machine behaviour
//
always @(posedge clock or posedge reset) begin
	if (reset) begin
		state <= INPUT_STATE;
	end else begin
		case (state)
			INPUT_STATE : begin
				if (!error) begin
					hexInput <= {{(6-PASSCODE_LENGTH){4'hE}}, userEntry};	// display user input
					state <= INPUT_STATE;
				end else begin
					state <= ERROR_STATE;
				end
				
			end
			
			ERROR_STATE : begin
				if (error) begin
					hexInput <= 24'hFCDDED;	// display "error"
					state <= ERROR_STATE;
				end else begin
					state <= INPUT_STATE;
				end
			end
			
			default state <= INPUT_STATE;
		endcase
	end
end
endmodule 