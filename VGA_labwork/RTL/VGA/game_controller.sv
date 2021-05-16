
// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2021 
//updated --Eyal Lev 2021


module	game_controller	(	
			input	logic	clk,
			input	logic	resetN,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
			input	logic	drawing_request_player,
			input	logic	drawing_request_borders,
			input	logic	drawing_request_p_rocket,
			input	logic	drawing_request_a_rocket,
			input	logic	drawing_request_aliens,
			input logic signed [10:0] pixelX,// current VGA pixel 
			input logic signed [10:0] pixelY,
			
			output logic alienHitPulse, // active in case of collision between two objects
			output logic playerHitByAlienPulse,
			output logic playerHitByRocketPulse,
			output logic rocketsCollisionPulse,
			output logic aliensReachedBorder
);


assign aliensReachedBorder = drawing_request_aliens && (pixelY > 479);


logic alienHit;
logic alienHit_d;

assign alienHit = (drawing_request_aliens && drawing_request_p_rocket);//  collision 
assign alienHitPulse = (alienHit == 1'b1) && (alienHit_d == 1'b0);


logic playerHitByAlien;
logic playerHitByAlien_d;

assign playerHitByAlien = (drawing_request_aliens && drawing_request_player);//  collision 
assign playerHitByAlienPulse = (playerHitByAlien == 1'b1) && (playerHitByAlien_d == 1'b0);


logic playerHitByRocket;
logic playerHitByRocket_d;

assign playerHitByRocket = (drawing_request_a_rocket && drawing_request_player);//  collision 
assign playerHitByRocketPulse = (playerHitByRocket == 1'b1) && (playerHitByRocket_d == 1'b0);


logic rocketsCollision;
logic rocketsCollision_d;

assign rocketsCollision = (drawing_request_a_rocket && drawing_request_p_rocket);//  collision 
assign rocketsCollisionPulse = (rocketsCollision == 1'b1) && (rocketsCollision_d == 1'b0);


always_ff@(posedge clk or negedge resetN) begin

	if(!resetN) begin 
		alienHit_d <= 1'b0;
		playerHitByAlien_d <= 1'b0;
		playerHitByRocket_d <= 1'b0;
		rocketsCollision_d <= 1'b0;
	end 
	
	else begin
		alienHit_d <= alienHit;
		playerHitByAlien_d <= playerHitByAlien;
		playerHitByRocket_d <= playerHitByRocket;
		rocketsCollision_d <= rocketsCollision;
	end
end

endmodule
