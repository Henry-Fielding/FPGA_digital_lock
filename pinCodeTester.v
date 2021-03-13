//
//Pincode check statemachine
//------------------------
//By: Henry Fielding
//Date: 12/03/2021
//
//Description
//------------
//reads and stores the input code then checks value against a preset code.

module pinCodeTester #(
	// declare parameters
	parameter DIGITS = 4, // number of digits in unlock code
	parameter CODE_LENGTH = 4*DIGITS, // bits required to store unlock code
	parameter COUNTER_WIDTH =  $clog2(DIGITS)
)(
	// declare ports
	input clock,
	input reset,
	
	input [3:0] key,
	input [CODE_LENGTH-1:0] pinCode,
	
	output reg unlock,
	output reg [CODE_LENGTH-1:0] pinEntry,
	output reg [COUNTER_WIDTH:0] digitCounter
);

// declare pin storage register
//reg [CODE_LENGTH-1:0] pinEntry;
//reg [COUNTER_WIDTH-1:0] digitCounter;

// declare local variable
localparam ZERO_INPUT = {CODE_LENGTH{1'b0}};
localparam ZERO_COUNT = {(COUNTER_WIDTH-1){1'b0}};

// declare state-machine register
reg [2:0] state;

// define state names
localparam READ_STATE = 3'd0;
localparam COMPARE_STATE = 3'd1;
localparam UNLOCK_STATE = 3'd2;
localparam CLEAR_STATE = 3'd3;

// define state machine outputs and transitions
always @ (posedge clock or posedge reset) begin
	if (reset) begin
		unlock <= 1'b0;
		digitCounter <= ZERO_COUNT;
		pinEntry <= ZERO_INPUT;
		state <= READ_STATE;
	end else begin
		case (state)
			READ_STATE : begin
				unlock <= 1'b0;
				
				if (digitCounter ==  DIGITS) begin
					state <= COMPARE_STATE;
					
				end else if (key) begin
					pinEntry = {pinEntry[11:0], key};
					digitCounter <= digitCounter + 1'b1;
					state <= READ_STATE;
					
				end else begin
					state <= READ_STATE;
				end
			end
			
			COMPARE_STATE : begin
				unlock <= 1'b0;
				
				if (pinEntry == pinCode) begin
					state <= UNLOCK_STATE;
				end else begin 
					state <= CLEAR_STATE;
				end
			end
			
			UNLOCK_STATE : begin
				unlock <= 1'b1;	
				state <= CLEAR_STATE;
			end
			
			CLEAR_STATE : begin
				unlock <= 1'b0;
				digitCounter <= ZERO_COUNT;
				pinEntry <= ZERO_INPUT;
				state <= READ_STATE;
			end
			
			default state <= CLEAR_STATE;
		
		endcase
	end
end

endmodule