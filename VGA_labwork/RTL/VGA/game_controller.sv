
// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2021 
//updated --Eyal Lev 2021


module	game_controller	(	
			input	logic	clk,
			input	logic	resetN,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
			input	logic	drawing_request_player,
			input	logic	drawing_request_borders,
			input	logic	drawing_request_rocket1,
			input	logic	drawing_request_aliens,
			
			output logic alienHitPulse, // active in case of collision between two objects
			output logic playerHitPulse
);

logic alienHit;
logic alienHit_d;

assign alienHit = (drawing_request_aliens && drawing_request_rocket1);//  collision 
assign alienHitPulse = (alienHit == 1'b1) && (alienHit_d == 1'b0);


logic playerHit;
logic playerHit_d;

assign playerHit = (drawing_request_aliens && drawing_request_player);//  collision 
assign playerHitPulse = (playerHit == 1'b1) && (playerHit_d == 1'b0);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin 
		alienHit_d <= 1'b0;
		playerHit_d <= 1'b0;
	end 
	else begin
		alienHit_d <= alienHit;
		playerHit_d <= playerHit;
	end
end

endmodule
