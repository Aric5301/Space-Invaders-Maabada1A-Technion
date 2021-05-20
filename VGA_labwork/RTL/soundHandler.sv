// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updaed Eyal Lev Feb 2021


module	soundHandler (	
 
					input	logic	clk,
					input	logic	resetN,
					input logic [2:0] playerHit,
					input logic playerShoot,

					output logic soundEnable, // output the top left corner 
					output logic [3:0] Tone  // can be negative , if the object is partliy outside 
);


// state machine decleration 
enum logic [1:0] {Sidle, SplayerHit, SplayerShoot} pres_st, next_st;

const int COUNTER_THRESHOLD = 5000000;

int counter;

const logic [3:0] PLAYER_SHOOT_TONE = 4'd9;
const logic [3:0] PLAYER_HIT_TONE = 4'd3;

 	
//--------------------------------------------------------------------------------------------

always @(posedge clk or negedge resetN) begin
	   
   if (!resetN) begin  // Asynchronic reset
		pres_st <= Sidle;
		counter <= 0;
	end
   
	else begin		// Synchronic logic FSM
		pres_st <= next_st;
		
		if ((pres_st != next_st) || (playerHit != 3'b0) || (playerShoot == 1'b1)) begin
			counter <= 0;
		end
		
		else begin
			counter <= counter + 1;
		end
	end	
end // always sync
	
//--------------------------------------------------------------------------------------------
 	
always_comb begin // Update next state
	next_st = pres_st; 
	soundEnable = 1'b0;
	Tone = 4'd0;
	
	case (pres_st)
			
		Sidle: begin
		
			if (playerHit != 3'b0) begin
				next_st = SplayerHit;
			end 
			
			else if (playerShoot == 1'b1) begin
				next_st = SplayerShoot;
			end 
		end // idle
					
		SplayerHit: begin
			soundEnable = 1'b1;
			Tone = PLAYER_HIT_TONE;
			
			if (playerShoot == 1'b1) begin
				next_st = SplayerShoot;
			end 	
			
			else if (counter >= COUNTER_THRESHOLD) begin
				next_st = Sidle;
			end
		end // playerHit
					
		SplayerShoot: begin
			soundEnable = 1'b1;
			Tone = PLAYER_SHOOT_TONE;
			
			if (playerHit != 3'b0) begin
				next_st = SplayerHit;
			end 	
			
			else if (counter >= COUNTER_THRESHOLD) begin
				next_st = Sidle;
			end
		end // playerShoot
	endcase
end // always comb

//////////--------------------------------------------------------------------------------------------------------------=
endmodule
