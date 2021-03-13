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
	
	// testing outputs
	output state,
	output [2:0] substate_unlocked,
	output [1:0] substate_locked

);

	//input [CODE_LENGTH-1:0] pinCode;
	//output reg [CODE_LENGTH-1:0] pinEntry;
	//output reg [COUNTER_WIDTH:0] digitCounter;
	
	
	
	
	
//
// Declare statemachine registers and statenames	
//
// declare state register and statenames for top level statemachine
reg state_toplevel;
localparam UNLOCKED_TOPLEVEL = 1'd0;
localparam LOCKED_TOPLEVEL = 1'd1;

// declare state register and statenames for the unlocked state sub-statemachine
reg [2:0] state_unlocked;
localparam READ1_UNLOCKED = 3'd0;
localparam READ2_UNLOCKED = 3'd1;
localparam CHECK_UNLOCKED = 3'd2;
localparam CLEAR_UNLOCKED = 3'd3;
localparam LOCK_UNLOCKED = 3'd4;

// declare state register and statenames for the locked state sub-statemachine
reg [1:0] state_locked;
localparam READ_LOCKED = 2'd0;
localparam CHECK_LOCKED = 2'd1;
localparam UNLOCK_LOCKED = 2'd2;
localparam CLEAR_LOCKED = 2'd3;

//
// toplevel statemachine
//
always @(posedge clock or posedge reset) begin
	if (reset) begin 
		locked <= 0;
		state_toplevel <= UNLOCKED_TOPLEVEL;
	
	end else begin
		case (state_toplevel)
			UNLOCKED_TOPLEVEL : begin
				locked <= 0;
				
				unlocked_sub_statemachine(); // call the locked state sub-statemachine
				if (state_unlocked == LOCK_UNLOCKED) begin // move to locked state if substatemachine reaches lock state
					state_toplevel <= LOCKED_TOPLEVEL;
				end
			end
			
			LOCKED_TOPLEVEL : begin
				locked <= 1;
				
				locked_sub_statemachine(); // call the locked state sub-statemachine
				if (state_locked == UNLOCK_LOCKED) begin // move to unlocked state if substatemachine reaches unlock state
					state_toplevel <= UNLOCKED_TOPLEVEL;
				end 
			end
			
			default state_toplevel <= UNLOCKED_TOPLEVEL;
		
		endcase
	end


end

//
// unlocked state sub-statemachine
//
task unlocked_sub_statemachine () ;
	case (state_unlocked)
		READ1_UNLOCKED: begin
			state_unlocked <= state_unlocked + 1'b1;
		end 
		
		READ2_UNLOCKED : begin
			state_unlocked <= state_unlocked + 1'b1;
		end 
		
		CHECK_UNLOCKED : begin
			state_unlocked <= state_unlocked + 1'b1;
		end 
		
		LOCK_UNLOCKED : begin
			state_unlocked <= state_unlocked + 1'b1;
		end 
		
		CLEAR_UNLOCKED : begin
			state_unlocked <= READ1_UNLOCKED;
		end 

		default state_unlocked <= READ1_UNLOCKED;
	
	endcase

endtask

//
//	locked sub-statemachine
//
task locked_sub_statemachine () ;
	case (state_locked)
		READ_LOCKED: begin
			state_locked <= state_locked + 1'b1;
		end 
		
		CHECK_LOCKED : begin
			state_locked <= state_locked + 1'b1;
		end 
		
		UNLOCK_LOCKED : begin
			state_locked <= state_locked + 1'b1;
		end 
		
		CLEAR_UNLOCKED : begin
			state_locked <= READ_LOCKED;
		end 

		default state_locked <= READ_LOCKED;
	
	endcase

endtask


//testing outputs
assign state = state_toplevel;
assign substate_unlocked = state_unlocked;
assign substate_locked = state_locked;


endmodule 