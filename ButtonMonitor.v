//
//Button monitor
//---------------
//By: Henry Fielding
//Date: 11/03/2021
//
//Description
//------------
//Detects the rising edge of the button press and outputs 1 clock cycle, .

// declare module
module buttonMonitor (
	input clock,
	input reset,
	
	input buttonPress,
	
	output reg buttonEdge
);

// declare state-machine register
reg state;

// define state names
localparam LOW_STATE = 1'b0;
localparam HIGH_STATE = 1'b1;

// define state machine outputs and transitions
always @ (posedge clock or posedge reset) begin
	if (reset) begin
		buttonEdge <= 1'b0;
		state <= LOW_STATE;
	end else begin
		case (state)
			LOW_STATE: begin
				// wait in low state until button pressed
				if (buttonPress) begin
					// when button pressed move to high state and 
					// set buttonedge high for 1 clock cycle
					buttonEdge <= 1'b1;
					state = HIGH_STATE;
				end else begin 
					buttonEdge <= 1'b0;
					state = LOW_STATE;
				end
			end
			
			HIGH_STATE: begin
				// wait in high state until button released
				if (!buttonPress) begin
					// if button released return to low state
					buttonEdge <= 1'b0;
					state = LOW_STATE;
				end else begin 
					buttonEdge <= 1'b0;
					state = HIGH_STATE;
				end
			end
		endcase
	end
end

endmodule
