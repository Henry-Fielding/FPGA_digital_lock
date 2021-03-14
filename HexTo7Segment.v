//
//Hex to seven segment Encoder
//-----------------------------
//By: Henry Fielding
//Date: 23/02/2021
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
	// Case statement to convert input Hexvalve to seven segment display valve
	always @ * begin
		case (hex)
			4'h0	:	segments = 8'b00111111;
			4'h1	:	segments = 8'b00000110;
			4'h2	:	segments = 8'b01011011;	
			4'h3	:	segments = 8'b01001111;
			4'h4	:	segments = 8'b01100110;
			4'h5	:	segments = 8'b01101101;
			4'h6	:	segments = 8'b01111101;
			4'h7	:	segments = 8'b00000111;
			4'h8	:	segments = 8'b01111111;
			4'h9	:	segments = 8'b01101111;
			4'hA	:	segments = 8'b01110111;
			4'hB	:	segments = 8'b01111100;
			4'hC	:	segments = 8'b00111001;
			4'hD	:	segments = 8'b01011110;
			4'hE	:	segments = 8'b01111001;
			4'hF	:	segments = 8'b01110001;
			default:	segments = 8'b01000000; // default case display - on 7seg display
		endcase
	end

endmodule
