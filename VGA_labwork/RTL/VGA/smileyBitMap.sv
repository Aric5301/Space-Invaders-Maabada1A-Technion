// System-Verilog 'written by Alex Grinshpun May 2018
// New bitmap dudy February 2021
// (c) Technion IIT, Department of Electrical Engineering 2021 



module	smileyBitMap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 
					input logic GodMode,

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
 ) ;

// this is the divider used to access the right pixel 
localparam  int OBJECT_NUMBER_OF_Y_BITS = 5;  // 2^5 = 32 
localparam  int OBJECT_NUMBER_OF_X_BITS = 5;  // 2^6 = 64 


localparam  int OBJECT_HEIGHT_Y = 1 <<  OBJECT_NUMBER_OF_Y_BITS ;
localparam  int OBJECT_WIDTH_X = 1 <<  OBJECT_NUMBER_OF_X_BITS;

// this is the divider used to access the right pixel 
localparam  int OBJECT_HEIGHT_Y_DIVIDER = OBJECT_NUMBER_OF_Y_BITS - 2; //how many pixel bits are in every collision pixel
localparam  int OBJECT_WIDTH_X_DIVIDER =  OBJECT_NUMBER_OF_X_BITS - 2;

// generating a smiley bitmap

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 

logic [0:1][0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [7:0] object_colors = {{
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h93,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h01,8'h01,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h01,8'h01,8'h01,8'h01,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h01,8'h01,8'h01,8'h01,8'h01,8'h49,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h13,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h13,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h09,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h09,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h4a,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h92,8'h01,8'h01,8'h01,8'h49,8'h49,8'h49,8'h09,8'h09,8'h01,8'h01,8'h01,8'h01,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h01,8'h01,8'h49,8'h49,8'h49,8'h49,8'h49,8'h09,8'h09,8'h09,8'h09,8'h09,8'h01,8'h01,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h49,8'h49,8'h49,8'h49,8'h49,8'h09,8'h09,8'h01,8'h01,8'h09,8'h09,8'h09,8'h09,8'h09,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h13,8'h49,8'h49,8'h49,8'h49,8'h49,8'h49,8'h49,8'h09,8'h09,8'h09,8'h09,8'h09,8'h09,8'h09,8'h13,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h52,8'hFF,8'h4a,8'h13,8'h49,8'h49,8'h49,8'h49,8'h0a,8'h53,8'h13,8'h13,8'h0a,8'h09,8'h09,8'h09,8'h09,8'h09,8'h13,8'h52,8'hFF,8'h0a,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h13,8'h9b,8'h01,8'h13,8'h49,8'h49,8'h49,8'h52,8'h53,8'h4a,8'h4a,8'h49,8'h0a,8'h13,8'h0a,8'h09,8'h09,8'h09,8'h13,8'h01,8'h9b,8'h13,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h53,8'h09,8'h01,8'h13,8'h4a,8'h49,8'h49,8'h53,8'h4a,8'h4a,8'h4a,8'h49,8'h49,8'h09,8'h13,8'h09,8'h09,8'h09,8'h13,8'h01,8'h01,8'h13,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h49,8'h01,8'h01,8'h13,8'h09,8'h49,8'h53,8'h4a,8'h4a,8'h4a,8'h4a,8'h49,8'h49,8'h49,8'h0a,8'h12,8'h09,8'h0a,8'h13,8'h01,8'h01,8'h09,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'h53,8'hFF,8'h49,8'h01,8'h01,8'h01,8'h13,8'h0a,8'h4a,8'h13,8'h4a,8'h4a,8'h4a,8'h4a,8'h49,8'h49,8'h49,8'h49,8'h13,8'h09,8'h0a,8'h13,8'h01,8'h01,8'h01,8'h52,8'hFF,8'h13,8'hFF,8'hFF},
	{8'hFF,8'h9b,8'h53,8'hFF,8'h01,8'h01,8'h01,8'h01,8'h13,8'h4a,8'h4a,8'h13,8'h4a,8'h4a,8'h4a,8'h4a,8'h49,8'h49,8'h49,8'h49,8'h13,8'h09,8'h13,8'h13,8'h01,8'h01,8'h01,8'h01,8'hFF,8'h13,8'hFF,8'hFF},
	{8'hFF,8'h9b,8'h53,8'h01,8'h01,8'h01,8'h01,8'h01,8'h53,8'h53,8'h4a,8'h13,8'h4a,8'h4a,8'h4a,8'h4a,8'h49,8'h49,8'h49,8'h49,8'h13,8'h09,8'h13,8'h0a,8'h01,8'h01,8'h01,8'h01,8'h01,8'h13,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'h4a,8'h01,8'h01,8'h01,8'h01,8'h01,8'h53,8'h53,8'h49,8'h13,8'h4a,8'h4a,8'h4a,8'h4a,8'h49,8'h49,8'h49,8'h49,8'h13,8'h09,8'h13,8'h09,8'h01,8'h01,8'h01,8'h01,8'h01,8'h09,8'hFF,8'hFF},
	{8'hFF,8'h92,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h0a,8'h53,8'h49,8'h53,8'h4a,8'h4a,8'h4a,8'h4a,8'h49,8'h49,8'h49,8'h0a,8'h13,8'h09,8'h13,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'hFF,8'hFF},
	{8'hFF,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h13,8'h49,8'h4a,8'h13,8'h4a,8'h4a,8'h4a,8'h49,8'h49,8'h0a,8'h13,8'h09,8'h09,8'h13,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'hFF},
	{8'h49,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h13,8'h49,8'h49,8'h4a,8'h13,8'h52,8'h4a,8'h09,8'h0a,8'h13,8'h09,8'h09,8'h09,8'h13,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h09},
	{8'hFF,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h13,8'h49,8'h49,8'h49,8'h49,8'h52,8'h53,8'h13,8'h0a,8'h09,8'h09,8'h09,8'h09,8'h13,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'hFF},
	{8'hFF,8'h49,8'h09,8'h09,8'h09,8'h09,8'h09,8'h09,8'h09,8'h13,8'h4a,8'h49,8'h49,8'h49,8'h4a,8'h49,8'h09,8'h09,8'h09,8'h09,8'h09,8'h09,8'h13,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h92,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'h09,8'hFF,8'hFF,8'hFF,8'h09,8'h9b,8'hFF,8'hFF,8'h9b,8'h09,8'h09,8'h09,8'h09,8'h01,8'h01,8'h01,8'h01,8'h9b,8'hFF,8'hFF,8'h01,8'h01,8'hFF,8'hFF,8'h92,8'h01,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'h89,8'hFF,8'hFF,8'hFF,8'h88,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h09,8'h09,8'h01,8'h01,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h88,8'hFF,8'hFF,8'hFF,8'h88,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hd0,8'hFF,8'hFF,8'hFF,8'hc8,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hd0,8'hFF,8'hFF,8'hFF,8'hc8,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hd1,8'hFF,8'hFF,8'hFF,8'hd1,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hd1,8'hFF,8'hFF,8'hFF,8'hd1,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hda,8'hFF,8'hFF,8'hFF,8'hda,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hda,8'hFF,8'hFF,8'hFF}}
	,{{
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h93,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h01,8'h01,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h01,8'h01,8'h01,8'h01,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h01,8'h01,8'h01,8'h01,8'h01,8'h49,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h13,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h13,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h09,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h09,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h4a,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h92,8'h01,8'h01,8'h01,8'h49,8'h49,8'h49,8'h09,8'h09,8'h01,8'h01,8'h01,8'h01,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h01,8'h01,8'h49,8'h49,8'h49,8'h49,8'h49,8'h09,8'h09,8'h09,8'h09,8'h09,8'h01,8'h01,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h49,8'h49,8'h49,8'h49,8'h49,8'h09,8'h09,8'h01,8'h01,8'h09,8'h09,8'h09,8'h09,8'h09,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h13,8'h49,8'h49,8'h49,8'h49,8'h49,8'h49,8'h49,8'h09,8'h09,8'h09,8'h09,8'h09,8'h09,8'h09,8'h13,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h52,8'hFF,8'h4a,8'h13,8'h49,8'h49,8'h49,8'h49,8'h0a,8'h13,8'h13,8'h13,8'h13,8'h09,8'h09,8'h09,8'h09,8'h09,8'h13,8'h52,8'hFF,8'h0a,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h13,8'h9b,8'h01,8'h13,8'h49,8'h49,8'h49,8'h52,8'h13,8'h18,8'h18,8'h18,8'h18,8'h13,8'h0a,8'h09,8'h09,8'h09,8'h13,8'h01,8'h9b,8'h13,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h53,8'h09,8'h01,8'h13,8'h4a,8'h49,8'h49,8'h13,8'h18,8'h18,8'h18,8'h18,8'h18,8'h18,8'h13,8'h09,8'h09,8'h09,8'h13,8'h01,8'h01,8'h13,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h49,8'h01,8'h01,8'h13,8'h09,8'h49,8'h13,8'h18,8'h18,8'h18,8'h18,8'h18,8'h18,8'h18,8'h18,8'h12,8'h09,8'h0a,8'h13,8'h01,8'h01,8'h09,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'h53,8'hFF,8'h49,8'h01,8'h01,8'h01,8'h13,8'h0a,8'h4a,8'h13,8'h18,8'h18,8'h18,8'h18,8'h18,8'h18,8'h18,8'h18,8'h13,8'h09,8'h0a,8'h13,8'h01,8'h01,8'h01,8'h52,8'hFF,8'h13,8'hFF,8'hFF},
	{8'hFF,8'h9b,8'h53,8'hFF,8'h01,8'h01,8'h01,8'h01,8'h13,8'h4a,8'h4a,8'h13,8'h18,8'h18,8'h18,8'h18,8'h18,8'h18,8'h18,8'h18,8'h13,8'h09,8'h13,8'h13,8'h01,8'h01,8'h01,8'h01,8'hFF,8'h13,8'hFF,8'hFF},
	{8'hFF,8'h9b,8'h53,8'h01,8'h01,8'h01,8'h01,8'h01,8'h53,8'h53,8'h4a,8'h13,8'h18,8'h18,8'h18,8'h18,8'h18,8'h18,8'h18,8'h18,8'h13,8'h09,8'h13,8'h0a,8'h01,8'h01,8'h01,8'h01,8'h01,8'h13,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'h4a,8'h01,8'h01,8'h01,8'h01,8'h01,8'h53,8'h53,8'h49,8'h13,8'h18,8'h18,8'h18,8'h18,8'h18,8'h18,8'h18,8'h18,8'h13,8'h09,8'h13,8'h09,8'h01,8'h01,8'h01,8'h01,8'h01,8'h09,8'hFF,8'hFF},
	{8'hFF,8'h92,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h0a,8'h53,8'h49,8'h13,8'h18,8'h18,8'h18,8'h18,8'h18,8'h18,8'h18,8'h18,8'h13,8'h09,8'h13,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'hFF,8'hFF},
	{8'hFF,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h13,8'h49,8'h4a,8'h13,8'h18,8'h18,8'h18,8'h18,8'h18,8'h18,8'h13,8'h09,8'h09,8'h13,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'hFF},
	{8'h49,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h13,8'h49,8'h49,8'h4a,8'h13,8'h18,8'h18,8'h18,8'h18,8'h13,8'h09,8'h09,8'h09,8'h13,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h09},
	{8'hFF,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h13,8'h49,8'h49,8'h49,8'h49,8'h13,8'h13,8'h13,8'h13,8'h09,8'h09,8'h09,8'h09,8'h13,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'hFF},
	{8'hFF,8'h49,8'h09,8'h09,8'h09,8'h09,8'h09,8'h09,8'h09,8'h13,8'h4a,8'h49,8'h49,8'h49,8'h4a,8'h49,8'h09,8'h09,8'h09,8'h09,8'h09,8'h09,8'h13,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h01,8'h92,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'h09,8'hFF,8'hFF,8'hFF,8'h09,8'h9b,8'hFF,8'hFF,8'h9b,8'h09,8'h09,8'h09,8'h09,8'h01,8'h01,8'h01,8'h01,8'h9b,8'hFF,8'hFF,8'h01,8'h01,8'hFF,8'hFF,8'h92,8'h01,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'h89,8'hFF,8'hFF,8'hFF,8'h88,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h09,8'h09,8'h01,8'h01,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'h88,8'hFF,8'hFF,8'hFF,8'h88,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hd0,8'hFF,8'hFF,8'hFF,8'hc8,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hd0,8'hFF,8'hFF,8'hFF,8'hc8,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hd1,8'hFF,8'hFF,8'hFF,8'hd1,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hd1,8'hFF,8'hFF,8'hFF,8'hd1,8'hFF,8'hFF,8'hFF},
	{8'hFF,8'hFF,8'hFF,8'hda,8'hFF,8'hFF,8'hFF,8'hda,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hFF,8'hda,8'hFF,8'hFF,8'hFF}}}};


//////////--------------------------------------------------------------------------------------------------------------=

 

// pipeline (ff) to get the pixel color from the array 	 

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'hFF;
	end

	else begin
		RGBout <= TRANSPARENT_ENCODING ; // default  

		if (InsideRectangle == 1'b1 ) 
		begin // inside an external bracket 
			RGBout <= object_colors[GodMode][offsetY][offsetX];
		end  	
	end
		
end

//////////--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule