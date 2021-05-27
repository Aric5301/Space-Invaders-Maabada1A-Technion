
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018

//-- Eyal Lev 31 Jan 2021

module	objects_mux	(	
//		--------	Clock Input	 	
					input logic	clk,
					input logic	resetN,
		   // smile 
					input logic	smileyDrawingRequest, // two set of inputs per unit
					input logic	[7:0] smileyRGB, 
					    
		  // rocke 
					input logic	[1:0] p_rockets_DR, // two set of inputs per unit
					input logic	[7:0] p_rocket0_RGB,
					input logic	[7:0] p_rocket1_RGB,
			 
					input logic	[2:0] a_rockets_DR, // two set of inputs per unit
					input logic	[7:0] a_rocket0_RGB,
					input logic	[7:0] a_rocket1_RGB,
					input logic	[7:0] a_rocket2_RGB,
			  
		  ////////////////////////
		  // background 
					input logic AliensDrawingRequest, // box of numbers
					input logic	[7:0] aliensRGB,   
					input logic	[7:0] backgroundRGB, 
					
					input logic splashDR,
					input logic [7:0] splashRGB,
					input logic isGameMode,
					
					input logic heartsDR,
					input logic [7:0] heartsRGB,
			  
				   output	logic	[7:0] RGBOut
);

always_ff@(posedge clk or negedge resetN) begin
	if(!resetN) begin
			RGBOut	<= 8'b0;
	end
	
	else begin
	
		if (splashDR == 1'b1) begin
			RGBOut <= splashRGB;
		end
		
		else if (isGameMode == 1'b1) begin
		
			if (heartsDR == 1'b1) begin
				RGBOut <= heartsRGB;
			end
		
			else if (smileyDrawingRequest == 1'b1) begin   
				RGBOut <= smileyRGB;
			end
			 
			else if (p_rockets_DR != 2'b0) begin
			
				if (p_rockets_DR[0] == 1'b1) begin
					RGBOut <= p_rocket0_RGB;
				end
				
				else if (p_rockets_DR[1] == 1'b1) begin
					RGBOut <= p_rocket1_RGB;
				end
			end
					
			else if (a_rockets_DR != 3'b0) begin
			
				if (a_rockets_DR[0] == 1'b1) begin
					RGBOut <= a_rocket0_RGB;
				end
				
				else if (a_rockets_DR[1] == 1'b1) begin
					RGBOut <= a_rocket1_RGB;
				end
				
				else if (a_rockets_DR[2] == 1'b1) begin
					RGBOut <= a_rocket2_RGB;
				end
			end
			 
			else if (AliensDrawingRequest == 1'b1) begin
				RGBOut <= aliensRGB;
			end
			
			else begin
				RGBOut <= backgroundRGB;
			end	
		end

		else begin
			RGBOut <= backgroundRGB;
		end
	end
end

endmodule


