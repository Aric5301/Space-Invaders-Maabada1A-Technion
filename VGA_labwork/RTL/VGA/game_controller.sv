
// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2021 
//updated --Eyal Lev 2021


module	game_controller	(	
			input	logic	clk,
			input	logic	resetN,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
			input	logic	drawing_request_player,
			input	logic	[1:0] p_rockets_DR,
			input	logic	[2:0] a_rockets_DR,
			input	logic	drawing_request_aliens,
			input logic signed [10:0] pixelX,// current VGA pixel 
			input logic signed [10:0] pixelY,
			
			output logic [1:0] alienHit, // active in case of collision between two objects
			output logic playerHitByAlienPulse,
			output logic [2:0] playerHitByRocket,
			output logic [1:0] p_rocketsCollision,
			output logic [2:0] a_rocketsCollision,
			output logic aliensReachedBorder
);

// -----
logic playerHitByAlien;
logic playerHitByAlien_d;

assign playerHitByAlien = (drawing_request_aliens && drawing_request_player);//  collision 
assign playerHitByAlienPulse = (playerHitByAlien == 1'b1) && (playerHitByAlien_d == 1'b0);
// -----

assign aliensReachedBorder = drawing_request_aliens && (pixelY > 479);

assign alienHit = ({2{drawing_request_aliens}} & p_rockets_DR);//  collision 
assign playerHitByRocket = ({3{drawing_request_player}} & a_rockets_DR);//  collision 

always_comb begin
	p_rocketsCollision = 2'b0;
	a_rocketsCollision = 3'b0;
	
	if ((a_rockets_DR != 3'b0) && (p_rockets_DR != 2'b0)) begin
		p_rocketsCollision = p_rockets_DR;
		a_rocketsCollision = a_rockets_DR;
	end
end

always_ff@(posedge clk or negedge resetN) begin

	if(!resetN) begin 
		playerHitByAlien_d <= 1'b0;
	end 
	
	else begin
		playerHitByAlien_d <= playerHitByAlien;
	end
end

endmodule
