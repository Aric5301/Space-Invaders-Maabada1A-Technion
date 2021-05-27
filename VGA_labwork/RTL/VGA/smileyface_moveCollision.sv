// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updaed Eyal Lev Feb 2021


module	smileyface_moveCollision	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input	logic	RightMove,  //change the direction in Y to up  
					input	logic	LeftMove, 	//toggle the X direction 
					input logic isGameMode,
					input logic UpMove,
					input logic DownMove,

					output	 logic signed 	[10:0]	topLeftX, // output the top left corner 
					output	 logic signed	[10:0]	topLeftY  // can be negative , if the object is partliy outside 
					
);


// a module used to generate the  ball trajectory.  

const int INITIAL_X = 280;
const int UP_Y = 406;
const int DOWN_Y = 438;
const int X_SPEED = 192;
const int RIGHT_BOUNDARY = (634-64);
const int LEFT_BOUNDARY = 5;


const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions
const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;

int topLeftX_FixedPoint; // local parameters 
int topLeftY_FixedPoint;



//////////--------------------------------------------------------------------------------------------------------------=

//  Y axis calculations
always_ff@(posedge clk or negedge resetN) begin
	
	if (!resetN) begin 
		topLeftY_FixedPoint	<= DOWN_Y * FIXED_POINT_MULTIPLIER;
	end 
	
	else if (startOfFrame == 1'b1 && isGameMode == 1'b1) begin
			
		if (UpMove == 1'b1 && DownMove == 1'b0) begin
			topLeftY_FixedPoint <= UP_Y * FIXED_POINT_MULTIPLIER;
		end
		
		else if (UpMove == 1'b0 && DownMove == 1'b1) begin
			topLeftY_FixedPoint <= DOWN_Y * FIXED_POINT_MULTIPLIER;
		end
	end
end 

//////////--------------------------------------------------------------------------------------------------------------=

//  X axis calculations
always_ff@(posedge clk or negedge resetN) begin
	
	if (!resetN) begin
		topLeftX_FixedPoint	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
	end
	
	else begin
	
		if (startOfFrame == 1'b1 && isGameMode == 1'b1) begin
			
			if (RightMove == 1'b1 && LeftMove == 1'b0) begin
			
				if ((topLeftX_FixedPoint + X_SPEED) / FIXED_POINT_MULTIPLIER > RIGHT_BOUNDARY) begin
					topLeftX_FixedPoint <= RIGHT_BOUNDARY * FIXED_POINT_MULTIPLIER;
				end
				
				else begin
					topLeftX_FixedPoint <= topLeftX_FixedPoint + X_SPEED;
				end
			end
			
			else if (RightMove == 1'b0 && LeftMove == 1'b1) begin
			
				if ((topLeftX_FixedPoint - X_SPEED) / FIXED_POINT_MULTIPLIER < LEFT_BOUNDARY) begin
					topLeftX_FixedPoint <= LEFT_BOUNDARY * FIXED_POINT_MULTIPLIER;
				end
				
				else begin
					topLeftX_FixedPoint <= topLeftX_FixedPoint - X_SPEED;
				end	
			end
		end
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    


endmodule
