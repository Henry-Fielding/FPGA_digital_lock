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
reg [WIDTH-1:0] key;

// DUT output signals
wire [WIDTH-1:0]keyEdge;

// instantiate DUT
buttonMonitorNBit #(
	.WIDTH	(WIDTH	) 

) buttonMonitorNBit_dut (
	.clock			(clock		),
	.reset			(reset		),
	
	.key				(key			),
	
	.keyEdge			(keyEdge		)
);

// define testbench variables
integer i;

// Define test regime
initial begin
	$monitor("%d ns \t clock = %b \t reset = %b \t key = %b \t keyEdge = %b", $time, clock, reset, key, keyEdge);
	
	reset = 1'b1;
	clock = 1'b0;
	key = 4'b0;
	#10
	clock = !clock;
	#10
	clock = !clock;
	
	reset = 1'b0;
	
	for (i = 0; i <= 3; i = i + 1) begin
		key = 4'b1 << i;
		#10
		clock = !clock;
		#10
		clock = !clock;
		#10
		clock = !clock;
		#10
		clock = !clock;
	end 

end

endmodule 