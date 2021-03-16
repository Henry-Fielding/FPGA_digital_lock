//Digital lock statemachine
//------------------------
//By: Henry Fielding
//Date: 13/03/2021
//
//Description
//------------
//Statemachine for a digital lock, Reads an inputs code then locks or unlocks 
//the lock if the code is correct

module LockStateMachine #(
	// declare parameters
	parameter CLOCK_FREQ = 50000000,
	parameter TIMEOUT = 10 * CLOCK_FREQ,	// number of clock cycles for ten second timeout
	parameter TIMEOUT_COUNTER_WIDTH = $clog2(TIMEOUT + 1),
	
	parameter PASSCODE_LENGTH = 4,			// number of digits in unlock code
	parameter PASSCODE_WIDTH = 4*PASSCODE_LENGTH, // bits required to store unlock code
	parameter ENTRY_COUNTER_WIDTH =  $clog2(PASSCODE_LENGTH + 1)
)(
	// declare ports
	input clock,
	input reset,
	input [3:0] key,
	
	output reg locked,
	output reg error,
	output reg [PASSCODE_WIDTH-1:0] userEntry
);

//
// local registers
//
reg [ENTRY_COUNTER_WIDTH-1:0] entryLength;
reg [PASSCODE_WIDTH-1:0] savedPasscode = 16'h8148;
reg [TIMEOUT_COUNTER_WIDTH-1:0] timeoutCounter;
reg ready;

//
// local parameters
//
localparam ZERO_ENTRY_COUNTER = {ENTRY_COUNTER_WIDTH{1'b0}};
localparam ZERO_ENTRY = {PASSCODE_WIDTH{1'b0}};
localparam ZERO_TIMEOUT_COUNTER = {TIMEOUT_COUNTER_WIDTH{1'b0}};
	
//
// Declare statemachine registers and statenames
//
reg state_toplevel;			// top level statemachine
localparam UNLOCKED_TOPLEVEL = 1'd0;
localparam LOCKED_TOPLEVEL = 1'd1;

reg [2:0] state_unlocked;	// unlocked state sub-statemachine
localparam READ1_UNLOCKED = 3'd0;
localparam READ2_UNLOCKED = 3'd1;
localparam CHECK_UNLOCKED = 3'd2;
localparam LOCK_UNLOCKED = 3'd3;
localparam CLEAR_UNLOCKED = 3'd4;

reg [1:0] state_locked;		// locked state sub-statemachine
localparam READ_LOCKED = 2'd0;
localparam CHECK_LOCKED = 2'd1;
localparam UNLOCK_LOCKED = 2'd2;
localparam CLEAR_LOCKED = 2'd3;

//
// define toplevel statemachine behaviour
//
always @(posedge clock or posedge reset) begin
	if (reset) begin 
		locked <= 1'b0;
		error <= 1'b0;
		ready <= 1'b0;
		state_toplevel <= UNLOCKED_TOPLEVEL;
	
	end else begin
		case (state_toplevel)
			UNLOCKED_TOPLEVEL : begin
				locked <= 0;
				
				unlocked_sub_statemachine();						// call the locked state sub-statemachine
				if (state_unlocked == LOCK_UNLOCKED) begin	// move to locked state if substatemachine reaches lock state
					locked <= 1;
					state_toplevel <= LOCKED_TOPLEVEL;
				end
			end
			
			LOCKED_TOPLEVEL : begin
				locked <= 1;
				
				locked_sub_statemachine();						// call the locked state sub-statemachine
				if (state_locked == UNLOCK_LOCKED) begin	// move to unlocked state if substatemachine reaches unlock state
					locked <= 0;
					state_toplevel <= UNLOCKED_TOPLEVEL;
				end 
				
			end
			
			default state_toplevel <= UNLOCKED_TOPLEVEL;
		
		endcase
	end


end

//
// define unlocked state sub-statemachine behaviour
//
task unlocked_sub_statemachine () ;
	case (state_unlocked)
		READ1_UNLOCKED: begin
			if (entryLength ==  PASSCODE_LENGTH) begin
				// if all digits have been entered move to Check state
				savedPasscode <= userEntry;
				userEntry <= ZERO_ENTRY;
				entryLength <= ZERO_ENTRY_COUNTER;
				ready <= 1'b0;
				state_unlocked <= READ2_UNLOCKED;
				
			end else if (key && !ready) begin
				// if a key is pressed shift in into the register in the 4 LSB
				userEntry = {userEntry[PASSCODE_WIDTH-5:0], key};
				entryLength <= entryLength + 1'b1;
				error <= 1'b0;		// turn off previous errors once any button is pressed
				ready <= 1'b1;
				timeoutCounter <= ZERO_TIMEOUT_COUNTER;
				state_unlocked <= READ1_UNLOCKED;
				
			end else if (timeoutCounter == TIMEOUT) begin
				// display error if timeout and clear entry
				error <= 1'b1;
				state_unlocked <= CLEAR_UNLOCKED;
				
			end else if (!key) begin
				// once key is released ready for next input
				ready <= 1'b0;
				state_locked <= READ1_UNLOCKED;
				
			end else begin
				state_unlocked <= READ1_UNLOCKED;
			end
			timeoutCounter <= timeoutCounter + 1'b1;
		end 
		
		READ2_UNLOCKED : begin
			if (entryLength ==  PASSCODE_LENGTH) begin
				// if all digits have been entered move to Check state
				timeoutCounter <= ZERO_TIMEOUT_COUNTER;
				state_unlocked <= CHECK_UNLOCKED;
				
			end else if (key && !ready) begin
				// if a key is pressed shift in into the register in the 4 LSB
				userEntry = {userEntry[PASSCODE_WIDTH-5:0], key};
				entryLength <= entryLength + 1'b1;
				ready <= 1'b1;
				timeoutCounter <= ZERO_TIMEOUT_COUNTER;
				state_unlocked <= READ2_UNLOCKED;
				
			end else if (timeoutCounter == TIMEOUT) begin
				// display error if timeout and clear entry
				error <= 1'b1;
				state_unlocked <= CLEAR_UNLOCKED;
				
			end else if (!key) begin
				// once key is released ready for next input
				ready <= 1'b0;
				state_locked <= READ2_UNLOCKED;
				
			end else begin
				state_unlocked <= READ2_UNLOCKED;
				
			end
			timeoutCounter <= timeoutCounter + 1'b1;
		end 
		
		CHECK_UNLOCKED : begin
			if (userEntry == savedPasscode) begin
				state_unlocked <= LOCK_UNLOCKED;
				
			end else begin 
				error <= 1'b1;
				state_unlocked <= CLEAR_UNLOCKED;
				
			end
		end 
		
		LOCK_UNLOCKED : begin
			state_unlocked <= CLEAR_UNLOCKED;
			
		end 
		
		CLEAR_UNLOCKED : begin
			entryLength <= ZERO_ENTRY_COUNTER;
			userEntry <= ZERO_ENTRY;
			timeoutCounter <= ZERO_TIMEOUT_COUNTER;
			state_unlocked <= READ1_UNLOCKED;
			
		end 

		default state_unlocked <= CLEAR_UNLOCKED;
	
	endcase

endtask

//
// define locked sub-statemachine behaviour
//
task locked_sub_statemachine () ;
	case (state_locked)
		READ_LOCKED: begin
			if (entryLength ==  PASSCODE_LENGTH) begin
				// if all digits have been entered move to Check state
				state_locked <= CHECK_LOCKED;
				
			end else if (key && !ready) begin
				// if a key is pressed shift in into the register in the 4 LSB
				userEntry = {userEntry[PASSCODE_WIDTH-5:0], key};
				entryLength <= entryLength + 1'b1;
				error <= 1'b0;
				ready <= 1'b1;
				timeoutCounter <= ZERO_TIMEOUT_COUNTER;
				state_locked <= READ_LOCKED;
				
			end else if (timeoutCounter == TIMEOUT) begin
				// display error if timeout and clear entry
				error <= 1'b1;
				state_locked <= CLEAR_LOCKED;
			
			end else if (!key) begin
				// once key is released ready for next input
				ready <= 1'b0;
				state_locked <= READ_LOCKED;
				
			end else begin
				state_locked <= READ_LOCKED;
				
			end
			timeoutCounter <= timeoutCounter + 1'b1;
		end 
		
		CHECK_LOCKED : begin
			if (userEntry == savedPasscode) begin
				state_locked <= UNLOCK_LOCKED;
				
			end else begin 
				state_locked <= CLEAR_LOCKED;
				error <= 1'b1;
				
			end
			
		end 
		
		UNLOCK_LOCKED : begin
			state_locked <= CLEAR_LOCKED;
			
		end 
		
		CLEAR_LOCKED : begin
			entryLength <= ZERO_ENTRY_COUNTER;
			userEntry <= ZERO_ENTRY;
			timeoutCounter <= ZERO_TIMEOUT_COUNTER;
			
			state_locked <= READ_LOCKED;
			
		end 

		default state_locked <= CLEAR_LOCKED;
	
	endcase

endtask

endmodule 