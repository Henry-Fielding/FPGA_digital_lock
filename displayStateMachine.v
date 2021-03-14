//
//7 Segment statemachine
//------------------------
//By: Henry Fielding
//Date: 14/03/2021
//
//Description
//------------
//Statemachine for the sevensegment display

module displayStateMachine #(
	//declare parameters
	parameter PASSCODE_LENGTH = 4, // number of digits in unlock code
	parameter PASSCODE_WIDTH = 4*PASSCODE_LENGTH // bits required to store unlock code
)(
	//declare inputs and outputs
	input clock,
	input reset,
	
	input locked,
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
	// declare parameters
	.DISPLAYS	(6	)
) converter (
   // Declare input and output ports
   .hex 		(hexInput	),
	.display	(displays	)
);

//
// Declare statemachine registers and statenames
//
reg [2:0] state;
localparam INPUT_STATE = 3'd0;
localparam ERROR_STATE = 3'd1;
localparam LOCK_STATE = 3'd2;
localparam UNLOCK_STATE = 3'd3;

always @(posedge clock or posedge reset) begin
	if (reset) begin
	
	end else begin
		case (state)
			INPUT_STATE : begin
				if (!error) begin
					hexInput <= {{(6-PASSCODE_LENGTH){4'hE}},userEntry};
					state <= INPUT_STATE;
				end else begin
					state <= ERROR_STATE;
				end
				
			end
			
			ERROR_STATE : begin
				if (error) begin
					hexInput <= 24'hFCDDED;
					state <= ERROR_STATE;
				end else begin
					state <= INPUT_STATE;
				end
			end
		endcase
	end

end
endmodule 