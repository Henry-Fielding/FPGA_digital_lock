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
	parameter DIGITS = 4, // number of digits in unlock code
	parameter CODE_LENGTH = 4*DIGITS // bits required to store unlock code 
)(
	// declare ports
	input clock,
	input reset,
	
	input key,
	input [CODE_LENGTH-1:0] pinCode,
	
	output reg unlock
);

// declare pin storage register
reg [CODE_LENGTH-1:0] pinEntry;

// declare local variable
localparam ZERO = {CODE_LENGTH{1'b0}};

// declare state-machine register
reg state;

// define state names
localparam READ_STATE = 3'd0;
localparam CHECK_STATE = 3'd1;
localparam UNLOCK_STATE = 3'd3;

// define state machine outputs and transitions
always @ (posedge clock or posedge reset) begin
	if (reset) begin
		unlock <= 1'b0;
		pinEntry <= 
		state <= READ_STATE;
	end else begin
	
	end
	
end

endmodule