// (c) Technion IIT, Department of Electrical Engineering 2021 
// Written By David Bar-On  June 2018 

module bitrec 	
 ( 
   input	   logic  clk,
	input	   logic  resetN, 
	input	   logic  kbd_dat,
	input	   logic  kbd_clk,
   output  logic [7:0]	dout,	
   output  logic 	dout_new, 
	output  logic parity_ok,
	output  logic qualifier_out
  ) ;


 enum  logic [2:0] {IDLE_ST, // initial state
						  LOW_CLK_ST, // after clock low 
						  HI_CLK_ST, // after clock hi 
						  CHK_DATA_ST, // after all bits recieved 
						  NEW_DATA_ST // valid parity laod new data 
						  }  pres_st /* synthesis keep = 1 */, next_st  /* synthesis keep = 1 */;

  logic [3:0] cntr, Next_Cntr /* synthesis keep = 1 */ ; 
  logic [9:0] shift_reg, Next_Shift_Reg  /* synthesis keep = 1 */ ; 
  logic [7:0] Next_Dout  /* synthesis keep = 1 */ ; 
 // logic qualifier, next_qualifier;
  
  localparam NUM_OF_BITS = 10 ; 

	always_ff @(posedge clk or negedge resetN)
	begin: fsm_sync_proc
		if (resetN == 1'b0) begin 
			pres_st <= IDLE_ST ; 
			cntr <= 4'h0  ;
			shift_reg <= 10'h000 ; 
			dout <= 8'h00 ;
		//qualifier = 1'b0;	
			end 	
		else begin 
			pres_st <= next_st;
			cntr <= Next_Cntr ; 
			shift_reg <= Next_Shift_Reg ;
			dout <= Next_Dout  ; 
		//	qualifier <= next_qualifier;
		end ; 
	end // end fsm_sync_proc
  
always_comb 
begin
	// default values 
		next_st = pres_st ;
		Next_Cntr = cntr  ; 
		Next_Shift_Reg = shift_reg  ;
		//next_qualifier = qualifier;
		Next_Dout <= dout ; 
		dout_new <= 1'b0 ;
		qualifier_out = 1'b1;
	 	

	case(pres_st)
			IDLE_ST: begin
//---------------
				Next_Cntr <= 4'h0  ;
				qualifier_out = 1'b0 ;
				if( (kbd_clk == 1'b0) && (kbd_dat == 1'b0) ) 
					next_st = LOW_CLK_ST;
			end  
				
			LOW_CLK_ST: begin
//---------------
				if (kbd_clk == 1'b1)
					begin 
 						 Next_Shift_Reg = { kbd_dat,shift_reg [9:1] }  ;
						 if (cntr < NUM_OF_BITS) 
						 begin 
								next_st = HI_CLK_ST;
								Next_Cntr = cntr + 4'h1  ; 

						 end 
						 else begin
								next_st = CHK_DATA_ST;
						 end 
					end 
			end  
				
			HI_CLK_ST: begin
//---------------
			if (kbd_clk == 1'b0)
								next_st = LOW_CLK_ST;
			end  
			
			CHK_DATA_ST: begin 
//---------------
				if (parity_ok == 1'b1 ) 
					begin 
						Next_Dout <= shift_reg [7:0] ; 
						next_st = NEW_DATA_ST ;
					end 
				else 
					next_st = IDLE_ST ;
			end  

			 NEW_DATA_ST: begin 
//---------------
					next_st = IDLE_ST ;
					dout_new <= 1'b1 ; 
			end  
	
		endcase  
				
end 

// parity Calc 
//assign parity_ok = shift_reg[8] ^ shift_reg[7] ^ shift_reg[6] ^ shift_reg[5] ^ shift_reg[3] 
//       ^ shift_reg[2] ^ shift_reg[1] ^ shift_reg[1] ^ shift_reg[0]; //--------wrong parity

assign parity_ok = shift_reg[8] ^ shift_reg[7] ^ shift_reg[6] ^ shift_reg[5] ^ shift_reg[4] 
       ^ shift_reg[3] ^ shift_reg[2] ^ shift_reg[1] ^ shift_reg[0];
//assign qualifier_out = qualifier;

endmodule

