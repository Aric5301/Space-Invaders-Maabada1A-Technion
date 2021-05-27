// (c) Technion IIT, Department of Electrical Engineering 2021 

// This module acts as a cooldowner to a 1 bit pulse input.
// It allowes the pulse to pass only if at lease COOLDOWN_CYCLES have passed since the last pulse.
module powerupsManager 	
( 
	input	logic clk,
	input	logic resetN, 
	input logic TurboCollision,
	input logic GodModeCollision,

	output logic TurboActive,
	output logic GodModeActive

);
  
parameter TURBO_CYCLES = 12500000;
parameter GODMODE_CYCLES = 100000000;

int counterTurbo = 0;
int counterGodMode = 0;

	always_ff @(posedge clk or negedge resetN) begin
			
		if (!resetN) begin
			TurboActive <= 1'b0;
			GodModeActive <= 1'b0;
			counterTurbo <= 0;
			counterGodMode <= 0;
		end
		
		else if (TurboCollision == 1'b1) begin
			counterTurbo <= 1;
			TurboActive <= 1'b1;
		end
		
		else if (GodModeCollision == 1'b1) begin
			counterGodMode <= 1;
			GodModeActive <= 1'b1;
		end
		
		else if (counterTurbo > TURBO_CYCLES) begin 
			TurboActive <= 1'b0;
			counterTurbo <= 0;
		end
		
		else if (counterGodMode > GODMODE_CYCLES) begin 
			GodModeActive <= 1'b0;
			counterGodMode <= 0;
		end
		
		else begin
			counterTurbo <= (counterTurbo == 0 ) ? 0 : counterTurbo + 1; 
			counterGodMode <= (counterGodMode == 0 ) ? 0 : counterGodMode + 1;
		end
	end
endmodule
