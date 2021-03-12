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
	
	input [WIDTH-1:0] key,
	
	output [WIDTH-1:0] keyEdge
);

// declare loop variable
genvar i;

// instantiate submodules
generate
	for(i = 0; i <= WIDTH - 1; i = i + 1) begin : button_loop
		// instantiate WIDTH buttonMonitors
		buttonMonitor button (
			.clock			(clock	),
			.reset			(reset	),
	
			.key	(key[i]),
	
			.keyEdge		(keyEdge[i]	)
		);
	
	end
endgenerate

endmodule 