//
//key monitor test bench
//--------------------------
//By: Henry Fielding
//Date: 11/03/2021
//
//Description
//------------
//Simple test bench to test the function of the single key monitor.

`timescale 1 ns/100 ps

module buttonMonitor_tb;
// testbench generated signals
reg clock;
reg reset;
reg key;

// DUT output signals
wire keyEdge;

// instantiate DUT
buttonMonitor buttonMonitor_dut (
	.clock			(clock		),
	.reset			(reset		),
	
	.key				(key			),
	
	.keyEdge			(keyEdge		)
);

// Define test regime
initial begin
	$monitor("%d ns \t clock = %b \t reset = %b \t key = %b \t keyEdge = %b", $time, clock, reset, key, keyEdge);
	
	reset = 1'b1;
	clock = 1'b0;
	key = 1'b0;
	#10
	clock = !clock;
	#10
	clock = !clock;
	
	reset = 1'b0;
	key = 1'b1;
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
	
	key = 1'b0;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	#10
	clock = !clock;
	
	key = 1'b1;
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


