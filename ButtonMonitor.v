//
//Button monitor
//---------------
//By: Henry Fielding
//Date: 11/03/2021
//
//Description
//------------
//Detects the rising edge of the button press and outputs 1 clock cycle.

module buttonMonitor (
	// port list
	input clock,
	input reset,
	
	input key,
	
	output reg keyEdge
);

// declare state-machine register
reg state;

// define state names
localparam LOW_STATE = 1'b0;
localparam HIGH_STATE = 1'b1;

// define state machine outputs and transitions
always @ (posedge clock or posedge reset) begin
	if (reset) begin
		keyEdge <= 1'b0;
		state <= LOW_STATE;
	end else begin
		case (state)
			LOW_STATE: begin
				// wait in low state until button pressed
				if (key) begin
					// when button pressed move to high state and 
					// set keyEdge high for 1 clock cycle
					keyEdge <= 1'b1;
					state = HIGH_STATE;
				end else begin 
					keyEdge <= 1'b0;
					state = LOW_STATE;
				end
			end
			
			HIGH_STATE: begin
				// wait in high state until button released
				if (!key) begin
					// if button released return to low state
					keyEdge <= 1'b0;
					state = LOW_STATE;
				end else begin 
					keyEdge <= 1'b0;
					state = HIGH_STATE;
				end
			end
			
			default state <= LOW_STATE;
			
		endcase
	end
end

endmodule
