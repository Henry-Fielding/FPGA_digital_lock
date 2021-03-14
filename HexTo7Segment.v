//
//Hex to seven segment Encoder
//-----------------------------
//By: Henry Fielding
//Date: 14/03/2021
//
//Description
//------------
// A module to Encode a 1 bit hex value for display on a seven segment displays
//

module HexTo7Segment (
    // Declare input and output ports
   input  	 	[3:0]	hex,
	output reg 	[7:0]	segments
);

// define case names
localparam DISPLAY_0 = 4'h0;
localparam DISPLAY_1 = 4'h1;
localparam DISPLAY_2 = 4'h2;
localparam DISPLAY_3 = 4'h3;
localparam DISPLAY_4 = 4'h4;

localparam DISPLAY_E = 4'h5;
localparam DISPLAY_r = 4'h6;
localparam DISPLAY_o = 4'h7;
localparam DISPLAY_L = 4'h8;
localparam DISPLAY_c = 4'h9;
localparam DISPLAY_U = 4'hA;
localparam DISPLAY_n = 4'hB;

	
// Case statement to convert input Hexvalve to seven segment display valve
always @ * begin
	case (hex)
		DISPLAY_0	:	segments = 8'b00111111;
		DISPLAY_1	:	segments = 8'b00000110;
		DISPLAY_2	:	segments = 8'b01011011;
		DISPLAY_3	:	segments = 8'b01001111;
		DISPLAY_4	:	segments = 8'b01100110;
		
		DISPLAY_E	:	segments = 8'b01111001;
		DISPLAY_r	:	segments = 8'b01010000;
		DISPLAY_o	:	segments = 8'b01011100;
		DISPLAY_L	:	segments = 8'b00111000;
		DISPLAY_c	:	segments = 8'b01011000;
		DISPLAY_U	:	segments = 8'b00111110;
		DISPLAY_n	:	segments = 8'b01010100;

		default:	segments = 8'b01000000; // display -
	endcase
end

endmodule
