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

// declare state-machine register
reg [2:0] state;

// define state names
localparam IDLE_STATE = 3'd0;
localparam BUTTON0_STATE = 3'd0;
localparam BUTTON1_STATE = 3'd0;
localparam BUTTON2_STATE = 3'd0;
localparam BUTTON3_STATE = 3'd0;

// define state machine outputs and transitions
always @ (posedge clock or posedge reset) begin
	if (reset) begin
		
	end else begin
	
	
	end
end

endmodule
