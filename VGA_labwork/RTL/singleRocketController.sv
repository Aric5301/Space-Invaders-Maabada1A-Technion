// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updaed Eyal Lev Feb 2021


module	singleRocketController	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,               // short pulse every start of frame 30Hz 
					input	logic	isActive,                   // is the rocket currently active on screen 
					input	logic signed [8:0] initialSpeed,  // initial speed for the rocket. Used each time isActive rises. [(pixels/64) per frame]
					input logic signed [10:0] initialX,     // initial X coordinate of the rocket
					input logic signed [10:0] initialY,     // initial Y coordinate of the rocket
					input logic collision,                  // collision if rocket hits an object

					output	 logic signed 	[10:0]	topLeftX, // output the top left corner 
					output	 logic signed	[10:0]	topLeftY  // can be negative , if the object is partliy outside 
					
);

const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions
const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;

int topLeftX_FixedPoint; // local parameters 
int topLeftY_FixedPoint;
int speed;
int initialX_Inside;     // initial X coordinate of the rocket
int initialY_Inside;     // initial Y coordinate of the rocket

logic isActive_d;


//////////--------------------------------------------------------------------------------------------------------------

// Detection of missile launch and updating initial values
assign isActiveRisingEdgePulse = (isActive == 1'b1) && (isActive_d == 1'b0);
assign initialX_Inside = initialX;
assign initialY_Inside = initialY;

always_ff@(posedge clk or negedge resetN) begin
	
	if (!resetN) begin 
		isActive_d <= 1'b0;
	end
	
	if (isActiveRisingEdgePulse == 1'b1) begin
		topLeftX_FixedPoint <= initialX_Inside * FIXED_POINT_MULTIPLIER;
		topLeftY_FixedPoint <= initialY_Inside * FIXED_POINT_MULTIPLIER;
		speed <= initialSpeed;
	end
	
	isActive_d <= isActive;
end 


//  Y axis calculations
always_ff@(posedge clk or negedge resetN) begin
	
	if (!resetN) begin 
		topLeftY_FixedPoint	<= 0 * FIXED_POINT_MULTIPLIER;
	end
	
	if (startOfFrame == 1'b1 && isActive == 1'b1) begin
		topLeftY_FixedPoint <= topLeftY_FixedPoint + speed;
	end
end 

//////////--------------------------------------------------------------------------------------------------------------=

//  X axis calculations
always_ff@(posedge clk or negedge resetN) begin
	
	if (!resetN) begin 
		topLeftX_FixedPoint	<= 0 * FIXED_POINT_MULTIPLIER;
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    


endmodule
