//
//N-bit Button monitor test bench
//--------------------------
//By: Henry Fielding
//Date: 11/03/2021
//
//Description
//------------
//Simple test bench to test the function of the the nBit Button monitor.


`timescale 1 ns/100 ps

module buttonMonitorNBit_tb;
// declare testing parameters
localparam WIDTH = 4;

// testbench generated signals
reg clock;
reg reset;
reg [WIDTH-1:0] buttons;

// DUT output signals
wire [WIDTH-1:0]buttonEdge;

// instantiate DUT
buttonMonitor #(
	.WIDTH	(WIDTH	) 

) buttonMonitorNBit_dut (
	.clock			(clock		),
	.reset			(reset		),
	
	.buttonPress	(buttons		),
	
	.buttonEdge		(buttonEdge	)
);

// Define test regime
initial begin

end

endmodule 