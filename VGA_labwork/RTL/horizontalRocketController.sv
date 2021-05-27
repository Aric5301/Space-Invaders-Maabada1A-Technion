// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updaed Eyal Lev Feb 2021


module	horizontalRocketController	(	
	input	logic	clk,
	input	logic	resetN,
	input logic reachedBorder,
	input logic [2:0] randLoc,
	input logic shootPulse,
	input logic playerHitByRocket,
	input logic isGameMode,
	
	output logic signed [10:0] initialSpeed,  // initial speed for the rocket. Used each time isActive rises. [(pixels/64) per frame]
	output logic signed [10:0] initialX,     // initial X coordinate of the rocket
	output logic signed [10:0] initialY,     // initial Y coordinate of the rocket
	output logic isActiveHorizontal
);

const int FIRE_SPEED = 128;
const logic [0:3] [10:0] TLX_Locations = {11'd0, 11'd0, 11'd620, 11'd620};
const logic [0:3] [10:0] TLY_Locations = {11'd450, 11'd418, 11'd418, 11'd450};

logic reachedBorder_d;

//////////--------------------------------------------------------------------------------------------------------------

always_ff@(posedge clk or negedge resetN) begin
	
	if (!resetN) begin 
		reachedBorder_d <= 1'b0;
		isActiveHorizontal <= 1'b0;
	end
	
	else begin
		
		if (playerHitByRocket == 1'b1) begin
			isActiveHorizontal <= 1'b0;
		end
		
		else if (reachedBorder == 1'b1 && (reachedBorder_d == 1'b1)) begin
			isActiveHorizontal <= 1'b0;
		end
		
		else if (shootPulse == 1'b1 && isGameMode == 1'b1) begin
			isActiveHorizontal <= 1'b1;
		
			initialX <= TLX_Locations[randLoc];
			initialY <=  TLY_Locations[randLoc];
		
			if (randLoc == 3'b0 || randLoc == 3'b1) begin
				initialSpeed <= FIRE_SPEED;
			end
			
			else begin
				initialSpeed <= -FIRE_SPEED;
			end
		end
		
		else begin
			reachedBorder_d <= reachedBorder;
		end
	end
end 

endmodule
