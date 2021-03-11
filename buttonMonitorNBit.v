//
//n-bit Button monitor
//---------------------
//By: Henry Fielding
//Date: 11/03/2021
//
//Description
//------------
//Instatiates n buttonMonitor submodules to detect the rising edge of n buttons.

module buttonMonitorNBit #(
	// declare parameters
	parameter WIDTH = 4 // number of input buttons
)(
	// declare ports
	input clock,
	input reset,
	
	input [WIDTH-1:0] buttonPress,
	
	output reg [WIDTH-1:0] buttonEdge
);




endmodule 