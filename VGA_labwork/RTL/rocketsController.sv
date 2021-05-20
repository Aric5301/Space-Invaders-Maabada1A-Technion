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
					input logic [1:0] alienHit,                   // collision if rocket hits an alien
					input logic [2:0] a_reachedBorder,
					input logic [1:0] p_reachedBorder,
					input logic signed [10:0] PlayerTLX,   // input the the current TLX of Player
					input logic signed [10:0] PlayerTLY,   // input the the current TLY of Player
					input logic [2:0] randSpeed,
					input logic [3:0] randCol,
					input logic shootPulse,
					input logic [1:0] alien_data,
					input logic signed [10:0] aliensTLX, //position on the screen 
					input logic	signed [10:0] aliensTLY,  
					input logic [2:0] a_rocketsCollision,
					input logic [1:0] p_rocketsCollision,
					input logic [2:0] playerHitByRocket,
					input logic isGameMode,
					
					output logic signed [10:0] initialSpeed,  // initial speed for the rocket. Used each time isActive rises. [(pixels/64) per frame]
					output logic signed [10:0] initialX,     // initial X coordinate of the rocket
					output logic signed [10:0] initialY,     // initial Y coordinate of the rocket
					output logic [1:0] isActivePlayers, 	  // output bus of isActive flags for all singleRocketControllers of players
					output logic [2:0] isActiveAliens, 		  // output bus of isActive flags for all singleRocketControllers of aliens
					output logic [3:0] colIdx,
					output logic [2:0] rowIdx
					
);

const int PLAYER_FIRE_SPEED = -255;
const logic [0:3] [10:0] SPEEDS = {11'd64, 11'd128, 11'd192, 11'd256};

logic [1:0] playerRockets;
logic [2:0] aliensRockets;

logic alienShooting;
logic [3:0] colCounter;
logic [2:0] rowCounter;

logic reachedBorder_d;

//////////--------------------------------------------------------------------------------------------------------------

assign isActivePlayers = playerRockets;
assign isActiveAliens = aliensRockets;
assign colIdx = colCounter;
assign rowIdx = rowCounter;


always_ff@(posedge clk or negedge resetN) begin
	
	if (!resetN) begin 
		playerRockets <= 2'b0;
		aliensRockets <= 3'b0;
		alienShooting <= 1'b0;
		colCounter <= 4'b0; 
		rowCounter <= 3'b0;
		reachedBorder_d <= 1'b0;
	end
	
	else begin
	
		if (player1Fire == 1'b1 && isGameMode == 1'b1) begin
			initialSpeed <= PLAYER_FIRE_SPEED;
			initialX <= PlayerTLX + 32; // change when modifyng the spaceship size
			initialY <=  PlayerTLY;
			
			if (playerRockets[0] == 1'b0) begin
				playerRockets[0] <= 1'b1;
			end
			
			else if (playerRockets[1] == 1'b0) begin
				playerRockets[1] <= 1'b1;
			end
		end 
		
		else if (a_rocketsCollision != 3'b0) begin // if a_rocketsCollision changes then obviously p_rocketsCollision also does
			playerRockets <= playerRockets ^ p_rocketsCollision;
			aliensRockets <= aliensRockets ^ a_rocketsCollision;
		end
		
		else if (playerHitByRocket != 3'b0) begin
			aliensRockets <= aliensRockets ^ playerHitByRocket;
		end
		
		else if (p_reachedBorder != 2'b0 && (reachedBorder_d == 1'b1)) begin
			playerRockets <= playerRockets ^ p_reachedBorder;
		end
		
		else if (alienHit != 2'b0) begin
			playerRockets <= playerRockets ^ alienHit;
		end
		
		else if ((a_reachedBorder != 3'b0) && (reachedBorder_d == 1'b1)) begin
			aliensRockets <= aliensRockets ^ a_reachedBorder;
		end
		
		else if (shootPulse == 1'b1 && alienShooting == 1'b0) begin
			alienShooting <= 1'b1;
			colCounter <= randCol;
			rowCounter <= 3'd5;
		end
		
		else if (alienShooting == 1'b1) begin
		
			if (alien_data != 2'b0) begin
				initialSpeed <= SPEEDS[randSpeed];
				initialX <= aliensTLX + (32 * colCounter) + 16;
				initialY <=  aliensTLY + (32 * rowCounter) + 32;
				
				if (aliensRockets[0] == 1'b0) begin
					aliensRockets[0] <= 1'b1;
				end
				
				else if (aliensRockets[1] == 1'b0) begin
					aliensRockets[1] <= 1'b1;
				end
				
				else if (aliensRockets[2] == 1'b0) begin
					aliensRockets[2] <= 1'b1;
				end
				alienShooting <= 1'b0;
			end
			
			else begin
			
				if (colCounter == 4'd13) begin
				
					if (rowCounter == 3'd0) begin
						colCounter <= 4'd0;
						rowCounter <= 3'd5;
					end
					
					else begin
						rowCounter <= rowCounter - 3'd1;
					end 
				end 
				
				else begin
					if (rowCounter == 3'd0) begin
						colCounter <= colCounter + 4'd1;
						rowCounter <= 3'd5;
					end
					
					else begin
						rowCounter <= rowCounter - 3'd1;
					end 
				end 
			end
		end
		
		else begin
			reachedBorder_d <= (a_reachedBorder != 3'b0) || (p_reachedBorder != 1'b0);
		end
	end
end 

endmodule
