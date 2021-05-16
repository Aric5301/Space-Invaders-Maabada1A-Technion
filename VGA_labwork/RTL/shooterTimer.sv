// (c) Technion IIT, Department of Electrical Engineering 2018 

// Implements a 4 bits down counter 9 to 0 with enable, enable count and loadN data.
// It outputs count and asynchronous terminal count, tc, signal 

module shooterTimer (
	input logic clk, 
	input logic resetN, 
	input logic [25:0] datain,
	
	output logic shootPulse
 );
 
logic [25:0] count;

always_ff @(posedge clk or negedge resetN) begin
	      
      if (!resetN) begin
			count <= 26'd0;
			shootPulse <= 1'b0;
		end
		
		else begin
		
			if (count == 26'b0) begin
				count <= datain;
				shootPulse <= 1'b1;
			end
			
			else begin 
				count <= count - 26'd1;
				shootPulse <= 1'b0;
			end
		end
	end
endmodule
