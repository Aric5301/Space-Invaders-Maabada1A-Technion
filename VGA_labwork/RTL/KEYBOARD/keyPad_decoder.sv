// (c) Technion IIT, Department of Electrical Engineering 2021
// Written By David Bar-On  Dec 2018 
// used to detect if one of the keys 0-9 was pressed,  if so sends the last keycode with Valid 
//updated Eyal Lev Feb 2021

module keyPad_decoder 	
 ( 
   input	   logic  clk,
	input	   logic  resetN, 
   input  logic [8:0]	keyCode,	
   input  logic 	make,	
   input  logic 	brakee,  // warning break is a reserved word 
	
   output  logic [3:0]	key,	// last key  [0..A]  
   output  logic 	keyIsValid	// valid while key [0..A] is pressed
  	 
  ) ;
  
  localparam NUM_OF_KEYS  = 10 ;

 logic[0:(NUM_OF_KEYS-1)][8:0] KEYS_ENCODEING =  // table holding the encoding of each key 
//    0      1       2       3       4       5        6       7       8       9   
  
  {9'h070, 9'h069, 9'h072, 9'h07A, 9'h06B, 9'h073, 9'h074, 9'h06C, 9'h075, 9'h07D} ; 
  
									           
	
always_ff @(posedge clk or negedge resetN) begin
 	if (resetN == 1'b0) begin 
			key <= 4'b0000 ; 	
			keyIsValid	<= 0 ; 
		end 
		else begin 
		// this is an example of how to use a for loop and generate 16 parallel circuits, one per digit 
		
				for(int i = 0 ;i < NUM_OF_KEYS ; i++) begin // for loop creating one machine per key 
					if (keyCode  == KEYS_ENCODEING[i] ) begin 
							if (make == 1'b1) begin ;  // turn on when key is pressed 
									keyIsValid <= 1'b1 ;
									key <= i	; 
							end ; 
							if (brakee == 1'b1) begin // turn off after key is released 
								keyIsValid <= 1'b0 ;  
							end 
					end 
				end
		end 
end 

endmodule

 
