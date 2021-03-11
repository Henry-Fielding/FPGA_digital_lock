//
//Button monitor test bench
//--------------------------
//By: Henry Fielding
//Date: 11/03/2021
//
//Description
//------------
//Simple test bench to test the function of the single Button monitor.

`timescale 1 ns/100 ps

module buttonMonitor_tb;
// testbench generated signals
reg clock;
reg reset;
reg button;

// DUT output signals
wire buttonEdge;

// instantiate DUT
buttonMonitor buttonMonitor_dut (
	.clock			(clock		),
	.reset			(reset		),
	
	.buttonPress	(button		),
	
	.buttonEdge		(buttonEdge	)
);

// Define test regime
initial begin
	$monitor("%d ns \t clock = %b \t reset = %b \t button = %b \t buttonEdge = %b", $time, clock, reset, button, buttonEdge);
	
	reset = 1'b1;
	clock = 1'b0;
	button = 1'b0;
	#10
	clock = !clock;
	#10
	clock = !clock;
	
	reset = 1'b0;
	button = 1'b1;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	
	button = 1'b0;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	
	button = 1'b1;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	
end 

endmodule 


