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
parameter PASSCODE_LENGTH = 3; // number of digits in unlock code
parameter PASSCODE_MSB = (4 * PASSCODE_LENGTH) - 1;
parameter CLOCK_FREQ = 50000000;
parameter RST_CYCLES = 2;
parameter SIMULATION_CYCLES = 1000;

// testbench generated signals
reg clock;
reg reset;
reg [3:0] key;

// DUT output signals
wire locked;
wire error;

wire [11:0] entry;
wire [1:0] entry_counter;
wire state;
wire [2:0] substate_unlocked;
wire [1:0] substate_locked;

digitalLock #(
	.PASSCODE_LENGTH	(PASSCODE_LENGTH	),
	.CLOCK_FREQ 		(CLOCK_FREQ			)

) digitalLock_tb (
	.clock	(clock	),
	.reset	(reset	),
	.key		(key		),

	
	.locked	(locked	),
	.error (error),
	
	
	// testing only
	.entry (entry),
	.entry_counter (entry_counter),
	.state	(state),
	.substate_unlocked	(substate_unlocked),
	.substate_locked		(substate_locked)
);

//test bench variables 
integer i;
integer j;
integer random;
integer password;

reg [PASSCODE_MSB:0] Entry1;
reg [PASSCODE_MSB:0] Entry2;

localparam ZERO = {PASSCODE_LENGTH{1'b0}};
localparam ONE = {{PASSCODE_LENGTH-1{1'b0}}, 1'b1};

initial begin
//$monitor("clock = %b \t i = %d \t key = %b", clock, i, key);
repeat(5) @(posedge clock);
	
	
//
// unlocked state test
//
$display("unlocked state testing");

// generate a random password of the set length
for (i = 0; i < 4 * PASSCODE_LENGTH; i = i + 4) begin
	// generate key press value and save in entry register
	random = $urandom_range(PASSCODE_LENGTH-1, 0);	
	Entry1[PASSCODE_MSB-i -: 4] = ONE << random;
end

// Test the device with 10 randomly generated inputs and display device performance
for (i = 0; i <= 20; i = i + 1) begin
	// enter the predetermined password onto the keypad
	for (j = 0; j < 4 * PASSCODE_LENGTH; j = j + 4) begin
		@(posedge clock);
		key = Entry1[PASSCODE_MSB-j -: 4];
		@(posedge clock);
		key = ZERO;
	end
	
	repeat(5) @(posedge clock);
	
	// generate and input a random test input
	for (j = 0; j < 4 * PASSCODE_LENGTH; j = j + 4) begin
		random = $urandom_range(PASSCODE_LENGTH-1, 0);	
		Entry2[PASSCODE_MSB-j -: 4] = ONE << random;
		
		@(posedge clock);
		key = ONE << random;
		@(posedge clock);
		key = ZERO;
	end
	
	// wait a few clock cycles for statemachine
	repeat(5) @(posedge clock);
	
	// compare module output to expected behaviour
	if ((Entry1 == Entry2) && locked && !error) begin
		$display("pass: \t Password = %h \t Test entry = %h \t locked = %b \t error =", Entry1, Entry2, locked, error);
	end else if	((Entry1 != Entry2) && !locked && error) begin
		$display("pass: \t Password = %h \t Test entry = %h \t locked = %b \t error =", Entry1, Entry2, locked, error);
	end else begin
		$display("fail: \t Password = %h \t Test entry = %h \t locked = %b \t error =", Entry1, Entry2, locked, error);
	end
	
	// if locked, unlock device so testing can continue
	if (locked) begin
	// enter the stored password
		for (j = 0; j < 4 * PASSCODE_LENGTH; j = j + 4) begin
			@(posedge clock);
			key = Entry1[PASSCODE_MSB-j -: 4];
			@(posedge clock);
			key = ZERO;
		end
		
		// wait a few clock cycles for statemachine
		repeat(5) @(posedge clock);
	end
end

	
//
// timeout testing
//

// unlock device

// enter password

// wait for timeout period

// enter password

// check if locked, if not then passed

// lock device

// enter password first half

// wait for timeout

// enter password	

//// test unlocking
//for (i = 0; i <= 10; i = i + 1) begin
//	for (j = 0; j <= PASSCODE_LENGTH-1; j = j + 1) begin
//		@(posedge clock);
//		random = $urandom_range(4,1);
////		Entry1[PASSCODE_LENGTH-j] = random; //generate and store a random keypress
//		key = 4'b0001 << random - 1; // generate random key press
//		Entry1[PASSCODE_MSB-(4*j) -: 4] = key;
//		
//	end
//	@(posedge clock);
//	
//	
//	//check if unlocked
//	$display("Entry1 = %h", Entry1);
//end
//
//$stop;














//clock = 1'b0;
//reset = 1'b1;
//#10
//clock = !clock;
//#10
//clock = !clock;
//
//reset = 1'b0;
//
//$monitor("%d ns \t clock = %b \t reset = %b \t key = %b \t locked = %b \t error %b \t entry1 = %h \t state = %d \t state unlocked = %d, state locked = %d", $time, clock, reset, key, locked, error, entry, state, substate_unlocked, substate_locked);
//	..
//	
//	
//	
//	
//	for(i = 0; i < 40; i = i + 1) begin
//		#10
//		clock = !clock;
//	end
//	#10
//	
//	//
//	// lock attempt 1 fail
//	//
//	
//	//enter 1 digit
//	key = 4'b1000;
//	clock = !clock;
//	#10
//	key = 4'b0000;
//	clock = !clock;
//	#10
//	
//	//enter 2 digit
//	key = 4'b0001;
//	clock = !clock;
//	#10
//	key = 4'b0000;
//	clock = !clock;
//	#10
//	
//	// enter 3 digit
//	key = 4'b0100;
//	clock = !clock;
//	#10
//	key = 4'b0000;
//	clock = !clock;
//	#10
//	
////	// enter 4 digit
////	key = 4'b1000;
////	clock = !clock;
////	#10
////	key = 4'b0000;
////	clock = !clock;
////	#10
//	
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	
//	//enter 1 digit
//	key = 4'b1000;
//	clock = !clock;
//	#10
//	key = 4'b0000;
//	clock = !clock;
//	#10
//	
//	//enter 2 digit
//	key = 4'b0001;
//	clock = !clock;
//	#10
//	key = 4'b0000;
//	clock = !clock;
//	#10
//	
//	// enter 3 digit
//	key = 4'b1000;
//	clock = !clock;
//	#10
//	key = 4'b0000;
//	clock = !clock;
//	#10
//	
////	// enter 4 digit
////	key = 4'b0100;
////	clock = !clock;
////	#10
////	key = 4'b0000;
////	clock = !clock;
////	#10
//	
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	
//	//
//	// attempt 2 success
//	//
//	
//	//enter 1 digit
//	key = 4'b1000;
//	clock = !clock;
//	#10
//	key = 4'b0000;
//	clock = !clock;
//	#10
//	
//	//enter 2 digit
//	key = 4'b0001;
//	clock = !clock;
//	#10
//	key = 4'b0000;
//	clock = !clock;
//	#10
//	
//	// enter 3 digit
//	key = 4'b0100;
//	clock = !clock;
//	#10
//	key = 4'b0000;
//	clock = !clock;
//	#10
//	
////	// enter 4 digit
////	key = 4'b1000;
////	clock = !clock;
////	#10
////	key = 4'b0000;
////	clock = !clock;
////	#10
//	
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	
//	//enter 1 digit
//	key = 4'b1000;
//	clock = !clock;
//	#10
//	key = 4'b0000;
//	clock = !clock;
//	#10
//	
//	//enter 2 digit
//	key = 4'b0001;
//	clock = !clock;
//	#10
//	key = 4'b0000;
//	clock = !clock;
//	#10
//	
//	// enter 3 digit
//	key = 4'b0100;
//	clock = !clock;
//	#10
//	key = 4'b0000;
//	clock = !clock;
//	#10
//	
////	// enter 4 digit
////	key = 4'b1000;
////	clock = !clock;
////	#10
////	key = 4'b0000;
////	clock = !clock;
////	#10
//	
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	
//	//
//	// unlock
//	// 
//	
//	//
//	// attempt 1
//	//
//
//	//enter 1 digit
//	key = 4'b1000;
//	clock = !clock;
//	#10
//	key = 4'b0000;
//	clock = !clock;
//	#10
//	
//	//enter 2 digit
//	key = 4'b0100;
//	clock = !clock;
//	#10
//	key = 4'b0000;
//	clock = !clock;
//	#10
//	
//	// enter 3 digit
//	key = 4'b0010;
//	clock = !clock;
//	#10
//	key = 4'b0000;
//	clock = !clock;
//	#10
//	
////	// enter 4 digit
////	key = 4'b0001;
////	clock = !clock;
////	#10
////	key = 4'b0000;
////	clock = !clock;
////	#10
//	
//	//wait 2 clock cycles
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	
//	
//	#10
//	//
//	// attempt 2
//	//
//
//	//enter 1 digit
//	key = 4'b1000;
//	clock = !clock;
//	#10
//	key = 4'b0000;
//	clock = !clock;
//	#10
//	
//	//enter 2 digit
//	key = 4'b0001;
//	clock = !clock;
//	#10
//	key = 4'b0000;
//	clock = !clock;
//	#10
//	
//	// enter 3 digit
//	key = 4'b0100;
//	clock = !clock;
//	#10
//	key = 4'b0000;
//	clock = !clock;
//	#10
//	
////	// enter 4 digit
////	key = 4'b1000;
////	clock = !clock;
////	#10
////	key = 4'b0000;
////	clock = !clock;
////	#10
//
//	//wait 2 clock cycles
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;
//	#10
//	clock = !clock;

end





//
// SYNCHRONOUS CLOCK LOGIC
//
initial begin
	// initialise in reset, clear reset after preset number of clock cycles
	reset = 1'b1;
	repeat(RST_CYCLES) @(posedge clock);
	reset = 1'b0;
end

initial begin
	// initialise clock to zero
	clock = 1'b0; 
end

real HALF_CLOCK_PERIOD = (1e9/ $itor(CLOCK_FREQ))/2.0; // find the clock half-period
integer halfCycles = 0;

always begin
	// toggle clock and increment counter after every half timeperiod
	#(HALF_CLOCK_PERIOD); 
	clock = ~clock;
	halfCycles = halfCycles + 1;

	if (halfCycles == (2*SIMULATION_CYCLES)) begin
		// reset the counter and end the simulation when all cycles complete
		halfCycles = 0;
		$stop;
	
	end
end

endmodule 


