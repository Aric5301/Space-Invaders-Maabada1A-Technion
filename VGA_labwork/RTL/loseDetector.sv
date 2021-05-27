// (c) Technion IIT, Department of Electrical Engineering 2021 

// This module acts as a cooldowner to a 1 bit pulse input.
// It allowes the pulse to pass only if at lease COOLDOWN_CYCLES have passed since the last pulse.
module loseDetector 	
( 
	input	logic	clk,
	input	logic	resetN, 
	input logic aliensReachedBorder,
	input logic [2:0] playerHitByRocket,
	input logic playerHitByAlienPulse,
	input logic GodMode,


	output logic lost,
	output logic [1:0] playerHealth
); 

logic playerHitByRocket_d;
logic playerHitByRocketPulse;
assign playerHitByRocketPulse = !playerHitByRocket_d && (playerHitByRocket != 3'b0);
  
int healthCounter = 3;

assign lost = (aliensReachedBorder || playerHitByAlienPulse || (healthCounter == 0));
assign playerHealth = healthCounter;
	
always_ff @(posedge clk or negedge resetN) begin
		
	if (!resetN) begin
		healthCounter <= 3;
		playerHitByRocket_d <= 1'b0;
	end
	
	else if (playerHitByRocketPulse == 1'b1 && GodMode == 1'b0) begin
		healthCounter <= healthCounter - 1;
		playerHitByRocket_d <= (playerHitByRocket != 3'b0);
	end
	
	else begin
		playerHitByRocket_d <= (playerHitByRocket != 3'b0);
	end
end
endmodule
