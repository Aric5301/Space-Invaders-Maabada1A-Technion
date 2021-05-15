// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updaed Eyal Lev Feb 2021


module	rocketsController	(	
 
					input	logic	clk,
					input	logic	resetN,
					input logic player1Fire,                 // short pulse every time the player fires
					input	logic	startOfFrame,                // short pulse every start of frame 30Hz 
					input logic alienHit,                   // collision if rocket hits an object
					input logic reachedBorder,
					input logic signed 	[10:0] PlayerTLX,   // input the the current TLX of Player
					input logic signed	[10:0] PlayerTLY,   // input the the current TLY of Player
					output logic signed [8:0] initialSpeed,  // initial speed for the rocket. Used each time isActive rises. [(pixels/64) per frame]
					output logic signed [10:0] initialX,     // initial X coordinate of the rocket
					output logic signed [10:0] initialY,     // initial Y coordinate of the rocket
					output logic [0:0] isActivePlayers, 	  // output bus of isActive flags for all singleRocketControllers of players
					output logic [0:0] isActiveAliens 		  // output bus of isActive flags for all singleRocketControllers of aliens
					
);

const int PLAYER_FIRE_SPEED = -128;

logic [0:0] playerRockets;
logic [0:0] aliensRockets;

//////////--------------------------------------------------------------------------------------------------------------

assign isActivePlayers = playerRockets;
assign isActiveAliens = aliensRockets;

always_ff@(posedge clk or negedge resetN) begin
	
	if (!resetN) begin 
		playerRockets <= 1'b0;
		aliensRockets <= 1'b0;
	end
	
	else begin
	
		if (player1Fire == 1'b1) begin
			initialSpeed <= PLAYER_FIRE_SPEED;
			initialX <= PlayerTLX;
			initialY <=  PlayerTLY;
			playerRockets <= 1'b1;
		end
		
		else if (alienHit == 1'b1 || reachedBorder == 1'b1) begin
			playerRockets <= 1'b0;
		end
	end
end 

endmodule
