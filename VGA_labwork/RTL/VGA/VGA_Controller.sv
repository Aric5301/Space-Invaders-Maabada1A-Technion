// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018


//-- Eyal Lev January 2021 change VGA clock to  25MHz Input clocK
//--                        


module	VGA_Controller	(	//	Host Side
					//input		logic [7:0]		Red,
					//input		logic	[7:0]		Green,
					//input		logic	[7:0]		Blue,
					input		logic	[7:0]		RGBIn,
					output	logic	[10:0]	PixelX,
					output	logic	[10:0]	PixelY,
					output	logic			startOfFrame,
						//	VGA Side
						output logic [28:0] oVGA,
					
					
					
						//	Control Signal
					input		logic	clk,
					input		logic	resetN	);

//	Internal Registers
logic			[10:0]	H_Cont;
logic			[10:0]	V_Cont;
logic      oVGA_HS;
logic      oVGA_HS_d;
logic      oVGA_VS;




//assign redOut	  = {RGBIn[7:5], {5{RGBIn[5]}}}; //--  extend LSB to create 10 bits per color  
//assign greenOut  = {RGBIn[4:2], {5{RGBIn[2]}}};
//assign blueOut	  = {RGBIn[1:0], {6{RGBIn[0]}}};
////////////////////////////////////////////////////////////
//	Horizontal	Parameter
const int	H_FRONT	=	16;
const int	H_SYNC	=	96;
const int	H_BACK	=	48;
const int	H_ACT	=	640;
const int	H_BLANK	=	H_FRONT+H_SYNC+H_BACK;
const int	H_TOTAL	=	H_FRONT+H_SYNC+H_BACK+H_ACT;
////////////////////////////////////////////////////////////
//	Vertical Parameter
const int	V_FRONT	=	11;
const int	V_SYNC	=	2;
const int	V_BACK	=	31;
const int	V_ACT	=	480;
const int	V_BLANK	=	V_FRONT+V_SYNC+V_BACK;
const int	V_TOTAL	=	V_FRONT+V_SYNC+V_BACK+V_ACT;

logic VGA_VS_pulse;
logic VGA_VS_d;
int VGA_VS_pulse_cnt;
logic			timer_done;

 // 28 bits VGA OUTPUT [CLOCK,      BLANK                           , SYNC ,    VS   , HS
assign	oVGA		=	{{~clk},{~((H_Cont<H_BLANK)||(V_Cont<V_BLANK))},{1'b1},{oVGA_VS},{oVGA_HS},
//                          8 bits RED color     ,  8 bits Green color         ,    8 bits Blue color
                      {RGBIn[1:0], {6{RGBIn[0]}}},{RGBIn[4:2], {5{RGBIn[2]}}},{RGBIn[7:5], {5{RGBIn[5]}}}};

				/* output	logic	[7:0]	oVGA_R,
					output	logic	[7:0]	oVGA_G,
					output	logic	[7:0]	oVGA_B,
					output	logic			oVGA_HS,
					output	logic			oVGA_VS,
					output	logic			oVGA_SYNC,
					output	logic			oVGA_BLANK,
					output	logic			oVGA_CLOCK, */
assign	PixelX	=	(H_Cont>=H_BLANK)	?	H_Cont-H_BLANK	:	11'h0	;
assign	PixelY	=	(V_Cont>=V_BLANK)	?	V_Cont-V_BLANK	:	11'h0	;





//	Horizontal Generator: Refer to the pixel clock
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		H_Cont		<=	11'b0;
		 oVGA_HS		<=	1'b1;
		oVGA_HS_d		<=	11'b1;

	end
	else
	begin
		if(H_Cont<H_TOTAL) 			
					H_Cont	<=	H_Cont+1'b1;
		
		else
		H_Cont	<=	11'b0;
		
		//	Horizontal Sync
		if(H_Cont==H_FRONT-1'b1)			//	Front porch end
			oVGA_HS	<=	1'b0;
		if(H_Cont==H_FRONT+H_SYNC-1'b1)	//	Sync pulse end
			oVGA_HS	<=	1'b1;
		
		
		oVGA_HS_d <= oVGA_HS;
				
	end
end

//	Vertical Generator: Refer to the pixel clock

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		  V_Cont		<=	11'b0;
		  oVGA_VS	<=	1'b1;
		   VGA_VS_d	<= 1'b0;
	end
	else begin

		
		if (!oVGA_HS_d && oVGA_HS)    // positive edge of OVGA_HS
	   begin
			if(V_Cont<V_TOTAL)
				V_Cont	<=	V_Cont+1'b1;
			else
				V_Cont	<=	11'b0;

			//	Vertical Sync
			if(V_Cont==V_FRONT-1'b1)			//	Front porch end
				oVGA_VS	<=	1'b0;
			if(V_Cont==V_FRONT+V_SYNC-1'b1)	//	Sync pulse end
				oVGA_VS	<=	1'b1;
	   end
		
		
	//---- delayed signal -------
		VGA_VS_d	<= oVGA_VS;
		
	end
end




assign startOfFrame	= !oVGA_VS && VGA_VS_d;// generating a short pulse ;

endmodule