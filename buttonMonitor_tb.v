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

// local variables

// instantiate DUT
buttonMonitor buttonMonitor_dut (
	.clock			(clock		),
	.reset			(reset		),
	
	.buttonPress	(button		),
	
	.buttonEdge		(buttonEdge	)
);

// Define test regime
initial begin

end 

endmodule 


