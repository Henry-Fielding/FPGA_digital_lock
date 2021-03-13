//
//Digital lock statemachine test bench
//------------------------
//By: Henry Fielding
//Date: 13/03/2021
//
//Description
//------------
// test bench form the Statemachine digital lock

`timescale 1 ns/100 ps

module digitalLock_tb;
// declare parameters
parameter DIGITS = 4; // number of digits in unlock code

// testbench generated signals
reg clock;
reg reset;

reg [3:0] key;

// DUT output signals
wire locked;

wire state;
wire [2:0] substate_unlocked;
wire [1:0] substate_locked;

digitalLock #(
	.DIGITS	(DIGITS	)

) digitalLock_tb (
	.clock	(clock	),
	.reset	(reset	),
	
	.key		(key		),

	
	.locked	(locked	),
	
	.state	(state),
	.substate_unlocked	(substate_unlocked),
	.substate_locked		(substate_locked)

);

//test bench variables 
integer i;

initial begin
clock = 1'b0;
reset = 1'b1;
#10
clock = !clock;
#10
clock = !clock;

reset = 1'b0;

$monitor("%d ns \t clock = %b \t reset = %b \t key = %b \t locked = %b \t state = %d \t state unlocked = %d, state locked = %d", $time, clock, reset, key, locked, state, substate_unlocked, substate_locked);
	for(i = 0; i < 40; i = i + 1) begin
		#10
		clock = !clock;
	end
end


endmodule 


