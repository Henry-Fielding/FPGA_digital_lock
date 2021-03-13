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
	parameter PASSCODE_LENGTH = 4, // number of digits in unlock code
	parameter PASSCODE_WIDTH = 4*PASSCODE_LENGTH, // bits required to store unlock code
	parameter COUNTER_WIDTH =  $clog2(PASSCODE_LENGTH + 1)
)(
	// declare ports
	input clock,
	input reset,
	
	input [3:0] key,

	
	output reg locked,
	
	// testing outputs
	output [PASSCODE_WIDTH-1:0] entry1,
	output [COUNTER_WIDTH-1:0] entry_counter,
	output state,
	output [2:0] substate_unlocked,
	output [1:0] substate_locked

);

//
// local registers
//	
reg [COUNTER_WIDTH-1:0] entryLength;
reg [PASSCODE_WIDTH-1:0] userEntry1;
reg [PASSCODE_WIDTH-1:0] userEntry2;
reg [PASSCODE_WIDTH-1:0] savedPasscode = 16'h8148;

//
// local parameters
//
localparam ZERO_COUNTER = {COUNTER_WIDTH{1'b0}};
localparam ZERO_ENTRY = {PASSCODE_WIDTH{1'b0}};
	
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
localparam LOCK_UNLOCKED = 3'd3;
localparam CLEAR_UNLOCKED = 3'd4;


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
					locked <= 1;
					state_toplevel <= LOCKED_TOPLEVEL;
				end
			end
			
			LOCKED_TOPLEVEL : begin
				locked <= 1;
				
				locked_sub_statemachine(); // call the locked state sub-statemachine
				if (state_locked == UNLOCK_LOCKED) begin // move to unlocked state if substatemachine reaches unlock state
					locked <= 0;
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
			if (entryLength ==  PASSCODE_LENGTH) begin
				// if all digits have been entered move to Check state
				state_locked <= CHECK_LOCKED;
				
			end else if (key) begin
				// if a key is pressed shift in into the register in the 4 LSB
				userEntry1 = {userEntry1[PASSCODE_WIDTH-5:0], key};
				entryLength <= entryLength + 1'b1;
				state_locked <= READ_LOCKED;
				
			end else begin
				state_locked <= READ_LOCKED;
			end
		end 
		
		CHECK_LOCKED : begin
			if (userEntry1 == savedPasscode) begin
				state_locked <= UNLOCK_LOCKED;
			end else begin 
				state_locked <= CLEAR_LOCKED;
			end
		end 
		
		UNLOCK_LOCKED : begin
			state_locked <= CLEAR_LOCKED;
		end 
		
		CLEAR_LOCKED : begin
			entryLength <= ZERO_COUNTER;
			userEntry1 <= ZERO_ENTRY;
			
			state_locked <= READ_LOCKED;
		end 

		default state_locked <= CLEAR_LOCKED;
	
	endcase

endtask


//testing outputs
assign state = state_toplevel;
assign substate_unlocked = state_unlocked;
assign substate_locked = state_locked;
assign entry1 = userEntry1;
assign entry_counter = entryLength;

endmodule 