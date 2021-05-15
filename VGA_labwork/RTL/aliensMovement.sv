// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updaed Eyal Lev Feb 2021


module	aliensMovement	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input logic turbo,

					output logic signed [10:0]	topLeftX, // output the top left corner 
					output logic signed [10:0]	topLeftY  // can be negative , if the object is partliy outside 
);


// a module used to generate the  ball trajectory.  

const int INITIAL_X = 40;
const int INITIAL_Y = 40;
const int SPEED = 64;
const int RIGHT_BOUNDARY = (639-448-40);
const int LEFT_BOUNDARY = 40;
const int Y_GAP = 8;


const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions
const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;

int topLeftX_FixedPoint; // local parameters 
int topLeftY_FixedPoint;
int speed;

logic takeSnapshot;
int ySnapshot = 0;

// state machine decleration 
enum logic [2:0] {Sright, SdownToLeft, Sleft ,SdownToRight, SdownToRightSnapshot, SdownToLeftSnapshot} pres_st, next_st;
 	
//--------------------------------------------------------------------------------------------

always @(posedge clk or negedge resetN) begin
	   
   if (!resetN) begin  // Asynchronic reset
		pres_st <= Sright;
		speed <= SPEED;
	end
   
	else begin		// Synchronic logic FSM
		pres_st <= next_st;
		
		if (turbo == 1'b1) begin
			speed <= SPEED * 10;
		end
		
		else begin
			speed <= SPEED;
		end
	end	
end // always sync
	
//--------------------------------------------------------------------------------------------
 	
always_comb begin // Update next state
	next_st = pres_st; 
	takeSnapshot = 1'b0;
		
	case (pres_st)
			
		Sright: begin
		
			if (topLeftX_FixedPoint > RIGHT_BOUNDARY * FIXED_POINT_MULTIPLIER) begin
				next_st = SdownToLeftSnapshot;
			end
		end // right
					
		SdownToLeft: begin
		
			if (topLeftY_FixedPoint > ySnapshot + (Y_GAP * FIXED_POINT_MULTIPLIER)) begin
				next_st = Sleft; 
			end
		end // downToLeft
					
		Sleft: begin
		
			if (topLeftX_FixedPoint < LEFT_BOUNDARY * FIXED_POINT_MULTIPLIER) begin
				next_st = SdownToRightSnapshot;
			end
		end // left
				
		SdownToRight: begin
		
			if (topLeftY_FixedPoint > ySnapshot + (Y_GAP * FIXED_POINT_MULTIPLIER)) begin
				next_st = Sright; 
			end
		end // downToRight
			
		SdownToRightSnapshot: begin
	
			takeSnapshot = 1'b1;
			next_st = SdownToRight;
		end // downToRightSnapshot
			
		SdownToLeftSnapshot: begin

			takeSnapshot = 1'b1;
			next_st = SdownToLeft;
		end // downToLeftSnapshot			
	endcase
end // always comb

//////////--------------------------------------------------------------------------------------------------------------=

//  Y axis calculations
always_ff@(posedge clk or negedge resetN) begin
	
	if (!resetN) begin 
		topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
	end
	
	else begin
	
		if (takeSnapshot == 1'b1) begin
			ySnapshot = topLeftY_FixedPoint;
		end
		
		if (startOfFrame == 1'b1) begin
			case (pres_st)
						
				SdownToLeft: begin
					topLeftY_FixedPoint <= topLeftY_FixedPoint + speed;
				end // downToLeft
						
				SdownToRight: begin
					topLeftY_FixedPoint <= topLeftY_FixedPoint + speed;
				end // downToRight
			endcase
		end
	end
end 

//////////--------------------------------------------------------------------------------------------------------------=

//  X axis calculations
always_ff@(posedge clk or negedge resetN) begin
	
	if (!resetN) begin
		topLeftX_FixedPoint	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
	end
	
	else if (startOfFrame == 1'b1) begin
		case (pres_st)
						
			Sright: begin
				topLeftX_FixedPoint <= topLeftX_FixedPoint + speed;
			end // right
					
			Sleft: begin
				topLeftX_FixedPoint <= topLeftX_FixedPoint - speed;
			end // left
		endcase
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    


endmodule
