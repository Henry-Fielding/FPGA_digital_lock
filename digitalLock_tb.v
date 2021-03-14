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
parameter RST_CYCLES = 5;
parameter SIMULATION_CYCLES = 1000;

// testbench generated signals
reg clock;
reg reset;
reg [3:0] key;

// DUT output signals
wire locked;
wire error;

digitalLock #(
	.PASSCODE_LENGTH	(PASSCODE_LENGTH	),
	.CLOCK_FREQ 		(CLOCK_FREQ			)

) digitalLock_tb (
	.clock	(clock	),
	.reset	(reset	),
	.key		(key		),

	
	.locked	(locked	),
	.error 	(error	)
);

// test bench variables 
integer i;
integer j;
integer random;

reg [PASSCODE_MSB:0] Entry1;
reg [PASSCODE_MSB:0] Entry2;

localparam ZERO = {PASSCODE_LENGTH{1'b0}};
localparam ONE = {{PASSCODE_LENGTH-1{1'b0}}, 1'b1};

//
// define test regime
//
initial begin
//
// unlocked state testing regime
//
$display("unlocked state testing");
reset_dut();						// return the device to a know state
randomise_passcode();	// generate a random passcode

// test the device with the correct passcode
enter_passcode();
enter_passcode();
Entry2 = Entry1;
autoverify_unlocked();
if (locked) begin			// if unlocked relock so testing can continue
	enter_passcode();
end

// test the device with 10 randomly generated inputs and display device performance
for (i = 0; i <= 20; i = i + 1) begin
	enter_passcode();			// enter the correct password then a randomly generated input and verify behaviour
	enter_random();
	autoverify_unlocked();
	
	if (locked) begin			// if locked, unlock device so testing can continue
		enter_passcode();
	end
end


//
// locked state testing regime
//
$display("locked state testing");
reset_dut();						// return device to known state
randomise_passcode();	// generate a random passcode

enter_passcode();			// enter correct passcode twice to lock device
enter_passcode();

// test the device with the correct passcode
enter_passcode();
Entry2 = Entry1;
autoverify_locked();
if (!locked) begin 			// if unlocked relock so testing can continue
		enter_passcode();
		enter_passcode();
end

// Test the device with 10 randomly generated passcodes
for (i = 0; i <= 20; i = i + 1) begin
	enter_random();			// enter a randomly generated input and verify the device behaviour
	autoverify_locked();
	
	if (!locked) begin		// if unlocked, relock device so testing can continue
		enter_passcode();
		enter_passcode();
	end
end

	
//
// timeout testing regime
//
//$display("timeout testing");
//reset();
//
//enter_passcode();
//repeat
//// enter password
//
//// wait for timeout period
//
//// enter password
//
//// check if locked, if not then passed
//
//// lock device
//
//// enter password first half
//
//// wait for timeout
//
//// enter password	
//
$stop;

end

//
// test regime tasks
//
task randomise_passcode() ;
begin
	// generate a random password of the set length
	for (i = 0; i < 4 * PASSCODE_LENGTH; i = i + 4) begin
		random = $urandom_range(3, 0);					// generate a random keypress value
		Entry1[PASSCODE_MSB-i -: 4] = ONE << random;	// save keypress as onehot binary value in register
	end
end
endtask

task enter_passcode() ;
begin 
	// enter the stored password on input keys
	for (j = 0; j < 4 * PASSCODE_LENGTH; j = j + 4) begin
		@(posedge clock);
		key = Entry1[PASSCODE_MSB-j -: 4];
		@(posedge clock);
		key = ZERO;
	end
	// wait a few clock cycles for statemachine
	repeat(10) @(posedge clock);
end
endtask

task enter_random();
begin
	// generate a random test input and enter on input keys
	for (j = 0; j < 4 * PASSCODE_LENGTH; j = j + 4) begin
		random = $urandom_range(3, 0);					// generate a random keypress value
		Entry2[PASSCODE_MSB-j -: 4] = ONE << random;	// save keypress as onehot binary value in register
		
		@(posedge clock);
		key = ONE << random;
		@(posedge clock);
		key = ZERO;
	end
	
	// wait a few clock cycles for statemachine
	repeat(10) @(posedge clock);
end
endtask

task autoverify_unlocked();
begin
	// compare unlocked state output to expected behaviour
	if ((Entry1 == Entry2) && locked && !error) begin
		$display("pass: \t Password = %h \t Test entry = %h \t locked = %b \t error =", Entry1, Entry2, locked, error);
	end else if	((Entry1 != Entry2) && !locked && error) begin
		$display("pass: \t Password = %h \t Test entry = %h \t locked = %b \t error =", Entry1, Entry2, locked, error);
	end else begin
		$display("fail: \t Password = %h \t Test entry = %h \t locked = %b \t error =", Entry1, Entry2, locked, error);
	end
end
endtask

task autoverify_locked();
begin
	// compare locked state output to expected behaviour
	if ((Entry1 == Entry2) && !locked && !error) begin
		$display("pass: \t entry 1 = %h \t entry 2 = %h \t locked = %b \t error =", Entry1, Entry2, locked, error);
	end else if	((Entry1 != Entry2) && locked && error) begin
		$display("pass: \t entry 1 = %h \t entry 2 = %h \t locked = %b \t error =", Entry1, Entry2, locked, error);
	end else begin
		$display("fail: \t Password = %h \t Test entry = %h \t locked = %b \t error =", Entry1, Entry2, locked, error);
	end
end
endtask

//
// SYNCHRONOUS CLOCK LOGIC
//
task reset_dut() ;
begin
	// initialise in reset, clear reset after preset number of clock cycles
	reset = 1'b1;
	repeat(RST_CYCLES) @(posedge clock);
	reset = 1'b0;
	repeat(RST_CYCLES) @(posedge clock);
end
endtask

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
end

endmodule 


