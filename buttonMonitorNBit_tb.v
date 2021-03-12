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
buttonMonitorNBit #(
	.WIDTH	(WIDTH	) 

) buttonMonitorNBit_dut (
	.clock			(clock		),
	.reset			(reset		),
	
	.buttonPress	(buttons		),
	
	.buttonEdge		(buttonEdge	)
);

// define testbench variables
integer i;

// Define test regime
initial begin
	$monitor("%d ns \t clock = %b \t reset = %b \t buttons = %b \t buttonEdge = %b", $time, clock, reset, buttons, buttonEdge);
	
	reset = 1'b1;
	clock = 1'b0;
	buttons = 4'b0;
	#10
	clock = !clock;
	#10
	clock = !clock;
	
	reset = 1'b0;
	
	for (i = 0; i <= 3; i = i + 1) begin
		buttons = 4'b1 << i;
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