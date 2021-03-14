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
// locked state testing
//

$display("locked state testing");

// generate a new random password of the set length
for (i = 0; i < 4 * PASSCODE_LENGTH; i = i + 4) begin
	// generate key press value and save in entry register
	random = $urandom_range(PASSCODE_LENGTH-1, 0);	
	Entry1[PASSCODE_MSB-i -: 4] = ONE << random;
end


// enter correct password twice to lock
for (j = 0; j < 4 * PASSCODE_LENGTH; j = j + 4) begin
		@(posedge clock);
		key = Entry1[PASSCODE_MSB-j -: 4];
		@(posedge clock);
		key = ZERO;
end
repeat(5) @(posedge clock);

for (j = 0; j < 4 * PASSCODE_LENGTH; j = j + 4) begin
		@(posedge clock);
		key = Entry1[PASSCODE_MSB-j -: 4];
		@(posedge clock);
		key = ZERO;
end
repeat(5) @(posedge clock);

// Test the device with 10 randomly generated inputs and display device performance
for (i = 0; i <= 20; i = i + 1) begin
	
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
	if ((Entry1 == Entry2) && !locked && !error) begin
		$display("pass: \t entry 1 = %h \t entry 2 = %h \t locked = %b \t error =", Entry1, Entry2, locked, error);
	end else if	((Entry1 != Entry2) && locked && error) begin
		$display("pass: \t entry 1 = %h \t entry 2 = %h \t locked = %b \t error =", Entry1, Entry2, locked, error);
	end else begin
		$display("fail: \t Password = %h \t Test entry = %h \t locked = %b \t error =", Entry1, Entry2, locked, error);
	end
	
	// if unlocked, relock device so testing can continue
	if (!locked) begin
	// enter the stored password
		for (j = 0; j < 4 * PASSCODE_LENGTH; j = j + 4) begin
			@(posedge clock);
			key = Entry1[PASSCODE_MSB-j -: 4];
			@(posedge clock);
			key = ZERO;
		end
		repeat(5) @(posedge clock);
		
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


