// (c) Technion IIT, Department of Electrical Engineering 2021 

module topLeftConstant 	
( 
	output logic signed [10:0]	topLeftX, // output the top left corner 
	output logic signed [10:0]	topLeftY  // can be negative , if the object is partliy outside 
);
  
parameter TOP_LEFT_X = 200;
parameter TOP_LEFT_Y = 200;

assign topLeftX = TOP_LEFT_X;
assign topLeftY = TOP_LEFT_Y;

endmodule
