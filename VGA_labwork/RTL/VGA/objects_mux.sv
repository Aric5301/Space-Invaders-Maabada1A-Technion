
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018

//-- Eyal Lev 31 Jan 2021

module	objects_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
		   // smiley 
					input		logic	smileyDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] smileyRGB, 
					     
		  // add the box here 
					input		logic	boxDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] box_RGB, 
			  
		  ////////////////////////
		  // background 
					input    logic HartDrawingRequest, // box of numbers
					input		logic	[7:0] hartRGB,   
					input		logic	[7:0] backGroundRGB, 
			  
				   output	logic	[7:0] RGBOut
);

always_ff@(posedge clk or negedge resetN) begin
	if(!resetN) begin
			RGBOut	<= 8'b0;
	end
	
	else begin
	
		if (smileyDrawingRequest == 1'b1 )   
			RGBOut <= smileyRGB;  //first priority 
		 
		else if (boxDrawingRequest == 1'b1)
				RGBOut <= box_RGB;
		 
		else if (HartDrawingRequest == 1'b1)
				RGBOut <= hartRGB;
				
		else 
			RGBOut <= backGroundRGB; // last priority 
	end
end

endmodule


