// (c) Technion IIT, Department of Electrical Engineering 2021 

// This module acts as a cooldowner to a 1 bit pulse input.
// It allowes the pulse to pass only if at lease COOLDOWN_CYCLES have passed since the last pulse.
module winDetector 	
( 
	input	logic	clk,
	input	logic	resetN, 
	input logic startOfFrame,
	input logic aliensDR,
	
	output logic won
); 

logic aliensDead;
  	
always_ff @(posedge clk or negedge resetN) begin
		
	if (!resetN) begin
		aliensDead <= 1'b0;
		won <= 1'b0;
	end
	
	else if (startOfFrame == 1'b1 && aliensDead == 1'b0) begin
		aliensDead <= 1'b1;
	end
	
	else if (startOfFrame == 1'b1 && aliensDead == 1'b1) begin
		won <= 1'b1;
	end
	
	else if (aliensDR == 1'b1) begin
		aliensDead <= 1'b0;
	end
end
endmodule 