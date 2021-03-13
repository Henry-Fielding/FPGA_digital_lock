//
//Digital lock statemachine
//------------------------
//By: Henry Fielding
//Date: 13/03/2021
//
//Description
//------------
//Statemachine for a digital lock, Reads an inputs code then locks or unlocks 
//the lock if the code is correct

module digitalLock #(
	// declare parameters
	parameter DIGITS = 4, // number of digits in unlock code
	parameter CODE_LENGTH = 4*DIGITS, // bits required to store unlock code
	parameter COUNTER_WIDTH =  $clog2(DIGITS)
)(
	// declare ports
	input clock,
	input reset,
	
	input [3:0] key,

	
	output reg locked,
	output test1,
	output test2
);

	//input [CODE_LENGTH-1:0] pinCode;
	//output reg [CODE_LENGTH-1:0] pinEntry;
	//output reg [COUNTER_WIDTH:0] digitCounter;

// declare state register and statenames for top level statemachine
reg state_toplevel;
localparam UNLOCKED_STATE = 1'd0;
localparam LOCKED_STATE = 1'd1;

// declare state register and statenames for the unlocked state sub-statemachine
reg state_unlocked;
localparam TEST1_STATE = 1'd0;
localparam TEST2_STATE = 1'd1;

// toplevel statemachine
always @(posedge clock or posedge reset) begin
	if (reset) begin 
		locked <= 0;
		state_toplevel <= UNLOCKED_STATE;
	
	end else begin
		case (state_toplevel)
			UNLOCKED_STATE : begin
				unlocked_sub_statemachine();
				if (state_unlocked == TEST1_STATE) begin
					state_toplevel <= LOCKED_STATE;
				end
			end
			
			LOCKED_STATE : begin
				unlocked_sub_statemachine();
				if (state_unlocked == TEST1_STATE) begin
					state_toplevel <= UNLOCKED_STATE;
				end 
			
			end
		endcase
	end


end

// unlocked state sub-statemachine
task unlocked_sub_statemachine () ;
	case (state_unlocked)
		TEST1_STATE : begin
			state_unlocked <= TEST2_STATE;
		end 
		
		TEST2_STATE : begin
			state_unlocked <= TEST1_STATE;
		end 
		
		default state_unlocked <= TEST1_STATE;
	
	endcase

endtask
//	locked sub-statemachine



assign test1 = state_toplevel;
assign test2 = state_unlocked;
endmodule 