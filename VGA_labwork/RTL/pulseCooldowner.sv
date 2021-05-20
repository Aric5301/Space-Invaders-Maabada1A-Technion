// (c) Technion IIT, Department of Electrical Engineering 2021 

// This module acts as a cooldowner to a 1 bit pulse input.
// It allowes the pulse to pass only if at lease COOLDOWN_CYCLES have passed since the last pulse.
module pulseCooldowner 	
( 
	input	logic clk,
	input	logic resetN, 
	input logic inPulse,
	
	output logic outPulse
);
  
parameter COOLDOWN_CYCLES = 5000000;

int counter;
	
always_ff @(posedge clk or negedge resetN) begin
		
	if (!resetN) begin
		outPulse <= 1'b0;
		counter <= COOLDOWN_CYCLES;
	end
	
	else if (inPulse == 1'b1 && (counter >= COOLDOWN_CYCLES)) begin
		counter <= 0;
		outPulse <= 1'b1;
	end
	
	else begin
		outPulse <= 1'b0;
		
		if (counter < COOLDOWN_CYCLES) begin
			counter <= counter + 1;
		end
	end
end
endmodule
