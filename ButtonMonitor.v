//
//Button monitor
//---------------
//By: Henry Fielding
//Date: 11/03/2021
//
//Description
//------------
//Reads the value of each button and outputs 1 for 1 clock cycle when a button is pressed.

module buttonMonitor (
	input clock,
	input reset,
	
	output reg [3:0] buttonPresses
);

// state machine outputs and transitions
always @ (posedge clock or posedge reset) begin

end

endmodule
