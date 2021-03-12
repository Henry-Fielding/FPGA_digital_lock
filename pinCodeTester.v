//
//Pincode check statemachine
//------------------------
//By: Henry Fielding
//Date: 12/03/2021
//
//Description
//------------
//Instatiates n buttonMonitor submodules to detect the rising edge of n buttons.

module pinCodeTester #(
	// declare parameters
	parameter CODE_LENGTH = 4 // number of input buttons
)(
	// declare ports
	input clock,
	input reset,
	
	input key,
	input [CODE_LENGTH-1:0] code,
	
	output unlock
);

// declare pin storage register
reg [CODE_LENGTH-1:0] pinEntry;

// declare state-machine register
reg state;

// define state names
localparam READ_STATE = 3'd0;
localparam CHECK_STATE = 3'd1;
localparam UNLOCK_STATE = 3'd3;

always @ (posedge clock or posedge reset) begin
	
	
end

endmodule