// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updaed Eyal Lev Feb 2021


module	modeSelector	(	
 
					input	logic	clk,
					input	logic	resetN,
					input logic startGamePulse,
					input logic lostGamePulse,
					input logic winGamePulse,

					output logic isGameMode, // output the top left corner 
					output logic [1:0] splashMode  // can be negative , if the object is partliy outside 
);


// state machine decleration 
enum logic [2:0] {SpreStart, Sgame, Slose ,Swin} pres_st, next_st;
 	
//--------------------------------------------------------------------------------------------

always @(posedge clk or negedge resetN) begin
	   
   if (!resetN) begin  // Asynchronic reset
		pres_st <= SpreStart;
	end
   
	else begin		// Synchronic logic FSM
		pres_st <= next_st;
	end	
end // always sync
	
//--------------------------------------------------------------------------------------------
 	
always_comb begin // Update next state
	next_st = pres_st; 
	isGameMode = 1'b0;
	splashMode = 2'b0;
		
	case (pres_st)
			
		SpreStart: begin
			splashMode = 2'b00;
			
			if (startGamePulse == 1'b1) begin
				next_st = Sgame;
			end
		end // preStart
					
		Sgame: begin
			isGameMode = 1'b1;
		
			if (lostGamePulse == 1'b1) begin
				next_st = Slose;
			end
			
			else if (winGamePulse == 1'b1) begin
				next_st = Swin;
			end
		end // game
					
		Slose: begin
			splashMode = 2'b01;
		end // lost
				
		Swin: begin
			splashMode = 2'b10;
		end // win
	endcase
end // always comb

//////////--------------------------------------------------------------------------------------------------------------=
endmodule
