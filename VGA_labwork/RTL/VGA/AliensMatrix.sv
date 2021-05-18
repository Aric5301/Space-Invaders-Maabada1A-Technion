// HartsMatrixBitMap File 
// A two level bitmap. dosplaying harts on the screen FWbruary  2021  
// (c) Technion IIT, Department of Electrical Engineering 2021 



module	AliensMatrix	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 
					input logic [1:0] alienHit,
					input logic [3:0] colIdx,
					input logic [2:0] rowIdx,

					output logic drawingRequest, //output that the pixel should be dispalyed 
					output logic [7:0] RGBout,  //rgb value from the bitmap 
					output logic [1:0] alien_data_out
 ) ;
 

// Size represented as Number of X and Y bits 
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 
 /*  end generated by the tool */
 
 
 assign alien_data_out = aliens_data[rowIdx][colIdx];
 
 

// data: [isAlive, type]
//				level	 rows  cols	  life
const logic [0:0] [0:5] [0:13] [1:0]  aliens_data_default  = {{
{2'b10, 2'b11, 2'b10, 2'b10, 2'b10, 2'b11, 2'b10, 2'b10, 2'b10, 2'b11, 2'b11, 2'b11, 2'b11, 2'b11 },
{2'b10, 2'b11, 2'b10, 2'b10, 2'b10, 2'b11, 2'b10, 2'b10, 2'b10, 2'b10, 2'b10, 2'b10, 2'b10, 2'b11 },
{2'b10, 2'b10, 2'b10, 2'b10, 2'b10, 2'b10, 2'b10, 2'b10, 2'b10, 2'b10, 2'b10, 2'b10, 2'b10, 2'b11 },
{2'b10, 2'b10, 2'b10, 2'b10, 2'b10, 2'b10, 2'b10, 2'b10, 2'b10, 2'b11, 2'b10, 2'b10, 2'b10, 2'b11 },
{2'b10, 2'b10, 2'b10, 2'b10, 2'b10, 2'b10, 2'b10, 2'b10, 2'b10, 2'b11, 2'b10, 2'b10, 2'b10, 2'b11 },
{2'b01, 2'b01, 2'b01, 2'b01, 2'b01, 2'b10, 2'b10, 2'b10, 2'b10, 2'b11, 2'b10, 2'b10, 2'b10, 2'b11 }
}};
 
const logic [0:2] [0:31] [0:31] [7:0] aliens_colors_default  = {
{{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCD, 8'hAC, 8'hCD, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hC5, 8'hC1, 8'hC1, 8'hC5, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB0, 8'h78, 8'h3C, 8'h1C, 8'h55, 8'hCD, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hA9, 8'h62, 8'h87, 8'hC7, 8'hE7, 8'hE3, 8'hC2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD1, 8'h9C, 8'h7C, 8'h3C, 8'h3C, 8'h1D, 8'h39, 8'hAD, 8'hFF, 8'hFF, 8'hFF, 8'hA9, 8'h26, 8'h47, 8'h87, 8'hC3, 8'hE7, 8'hE7, 8'hE7, 8'hC6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD4, 8'hBC, 8'h7C, 8'h3C, 8'h1C, 8'h3D, 8'h1E, 8'h3A, 8'hAD, 8'hFF, 8'hCE, 8'h26, 8'h27, 8'h67, 8'h83, 8'hC7, 8'hE7, 8'hE7, 8'hE3, 8'hE2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD8, 8'hBC, 8'h7C, 8'h5C, 8'h3C, 8'h1D, 8'h3E, 8'h1E, 8'h3A, 8'hCD, 8'h4E, 8'h0B, 8'h27, 8'h47, 8'h87, 8'hA3, 8'hE7, 8'hE7, 8'hE7, 8'hE6, 8'hEE, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF1, 8'hDC, 8'hBC, 8'h7C, 8'h5C, 8'h3C, 8'h3D, 8'h1D, 8'h1E, 8'h1F, 8'h52, 8'h2F, 8'h0B, 8'h27, 8'h47, 8'h87, 8'hA7, 8'hE7, 8'hE7, 8'hE7, 8'hE7, 8'hEA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF1, 8'hFC, 8'hBC, 8'h9C, 8'h5C, 8'h3C, 8'h1D, 8'h3D, 8'h1E, 8'h1F, 8'h1B, 8'h13, 8'h0B, 8'h27, 8'h47, 8'h86, 8'hA6, 8'hE7, 8'hE7, 8'hE7, 8'hE3, 8'hE6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF0, 8'hFC, 8'hBC, 8'h9C, 8'h5C, 8'h3C, 8'h3D, 8'h1D, 8'h1E, 8'h1F, 8'h1B, 8'h13, 8'h0F, 8'h27, 8'h47, 8'hA0, 8'hA0, 8'hC6, 8'hE7, 8'hE7, 8'hE7, 8'hE6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF0, 8'hFC, 8'hBC, 8'h9C, 8'h5C, 8'h3C, 8'h1D, 8'h3D, 8'h3A, 8'h3E, 8'h3B, 8'h13, 8'h0F, 8'h07, 8'h47, 8'hA0, 8'hC0, 8'hC6, 8'hE7, 8'hE7, 8'hE3, 8'hE6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF0, 8'hFC, 8'hDC, 8'h9C, 8'h5C, 8'h3C, 8'h1C, 8'h68, 8'h6D, 8'h56, 8'h85, 8'h4E, 8'h0F, 8'h07, 8'h27, 8'h81, 8'hA1, 8'hC7, 8'hE7, 8'hE7, 8'hE7, 8'hE6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF0, 8'hFC, 8'hDC, 8'h9C, 8'h7C, 8'h3C, 8'h6C, 8'hC0, 8'h84, 8'h51, 8'hC0, 8'h85, 8'h0F, 8'h0B, 8'h27, 8'h66, 8'h86, 8'hA1, 8'hC2, 8'hE7, 8'hE7, 8'hEA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD1, 8'hF8, 8'hDC, 8'h9C, 8'h7C, 8'h3C, 8'h50, 8'hC0, 8'hA4, 8'h56, 8'hC0, 8'h69, 8'h2E, 8'h26, 8'h46, 8'h81, 8'h82, 8'hA0, 8'hC1, 8'hE7, 8'hE3, 8'hEA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF1, 8'hF8, 8'hDC, 8'hBC, 8'h7C, 8'h74, 8'h54, 8'h84, 8'h89, 8'h3E, 8'h6D, 8'h4E, 8'hA0, 8'h65, 8'h61, 8'hA0, 8'hA0, 8'hC0, 8'hC1, 8'hC7, 8'hE7, 8'hF2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF4, 8'hDC, 8'hBC, 8'h94, 8'hA0, 8'hA0, 8'h51, 8'h39, 8'h1E, 8'h1F, 8'h69, 8'hC0, 8'h81, 8'h80, 8'hC0, 8'hC0, 8'hC0, 8'hC1, 8'hC7, 8'hE2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF4, 8'hFC, 8'hBC, 8'h98, 8'hA0, 8'hA0, 8'h88, 8'h1D, 8'h3A, 8'h4D, 8'h69, 8'hC0, 8'h85, 8'h80, 8'hC0, 8'hC0, 8'hC0, 8'hC1, 8'hC6, 8'hE6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD1, 8'hFC, 8'hAC, 8'h88, 8'hC0, 8'hC0, 8'h84, 8'h3D, 8'h55, 8'hC0, 8'h69, 8'h89, 8'h66, 8'h80, 8'hC0, 8'hC0, 8'hC0, 8'hC1, 8'hC3, 8'hEA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF1, 8'hD8, 8'hA0, 8'hC0, 8'hC0, 8'hC0, 8'h84, 8'h51, 8'h69, 8'hC0, 8'h69, 8'h17, 8'h2F, 8'h65, 8'hA0, 8'hC0, 8'hC0, 8'hA1, 8'hC2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD0, 8'hC4, 8'hC0, 8'hC0, 8'hC0, 8'h84, 8'h84, 8'hC0, 8'hC0, 8'h89, 8'h17, 8'h0F, 8'h26, 8'h80, 8'hC0, 8'hC0, 8'hC6, 8'hE6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD1, 8'hC8, 8'hC0, 8'hC0, 8'hC0, 8'h88, 8'h88, 8'hC0, 8'hC0, 8'h89, 8'h33, 8'h2E, 8'h45, 8'h61, 8'hA0, 8'hC0, 8'hC2, 8'hEE, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hAC, 8'hC4, 8'hC0, 8'hC0, 8'h8C, 8'h70, 8'hC0, 8'hC0, 8'h89, 8'h69, 8'h65, 8'hA0, 8'h81, 8'h66, 8'hA1, 8'hC6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hAD, 8'h90, 8'hC0, 8'hC0, 8'h6C, 8'h1D, 8'h6D, 8'hA4, 8'h6D, 8'hA4, 8'hC0, 8'hC0, 8'h80, 8'h47, 8'h83, 8'hCA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h94, 8'h74, 8'h88, 8'h54, 8'h1D, 8'h1E, 8'h3E, 8'h3A, 8'h85, 8'hC0, 8'hC0, 8'h81, 8'h47, 8'h82, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD1, 8'h7C, 8'h5C, 8'h1C, 8'h1D, 8'h3D, 8'h69, 8'h6D, 8'h4E, 8'hA0, 8'hC0, 8'h61, 8'h43, 8'hAA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h94, 8'h5C, 8'h3C, 8'h1D, 8'h39, 8'hC0, 8'h89, 8'h37, 8'h84, 8'hC0, 8'h46, 8'h66, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD1, 8'h58, 8'h3C, 8'h1D, 8'h3D, 8'hA4, 8'h6D, 8'h1B, 8'h52, 8'h85, 8'h27, 8'hAA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h90, 8'h3C, 8'h1D, 8'h1D, 8'h3A, 8'h3A, 8'h1B, 8'h13, 8'h0F, 8'h66, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h54, 8'h1C, 8'h3D, 8'h1E, 8'h1E, 8'h3B, 8'h17, 8'h2A, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB1, 8'h3C, 8'h1D, 8'h1E, 8'h1E, 8'h1B, 8'h17, 8'h8D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h70, 8'h1D, 8'h3E, 8'h3E, 8'h1F, 8'h6E, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h55, 8'h1E, 8'h1E, 8'h56, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD1, 8'h39, 8'h3A, 8'hB1, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hAD, 8'hAD, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
},
{{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCD, 8'hAC, 8'hCD, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hC5, 8'hC1, 8'hC1, 8'hC5, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB0, 8'hFF, 8'hFF, 8'hFF, 8'h55, 8'hCD, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hA9, 8'h62, 8'h87, 8'hC7, 8'hE7, 8'hE3, 8'hC2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD1, 8'h9C, 8'hFF, 8'hFF, 8'hFF, 8'h1D, 8'h39, 8'hAD, 8'hFF, 8'hFF, 8'hFF, 8'hA9, 8'h26, 8'h47, 8'h87, 8'hC3, 8'hE7, 8'hE7, 8'hE7, 8'hC6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD4, 8'hBC, 8'hFF, 8'hFF, 8'hFF, 8'h3D, 8'h1E, 8'h3A, 8'hAD, 8'hFF, 8'hCE, 8'h26, 8'h27, 8'h67, 8'h83, 8'hC7, 8'hE7, 8'hE7, 8'hE3, 8'hE2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD8, 8'hBC, 8'hFF, 8'hFF, 8'hFF, 8'h1D, 8'h3E, 8'h1E, 8'h3A, 8'hCD, 8'h4E, 8'h0B, 8'h27, 8'h47, 8'h87, 8'hA3, 8'hE7, 8'hE7, 8'hE7, 8'hE6, 8'hEE, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF1, 8'hDC, 8'hBC, 8'hFF, 8'hFF, 8'hFF, 8'h3D, 8'h1D, 8'h1E, 8'h1F, 8'h52, 8'h2F, 8'h0B, 8'h27, 8'h47, 8'h87, 8'hA7, 8'hE7, 8'hE7, 8'hE7, 8'hE7, 8'hEA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF1, 8'hFC, 8'hBC, 8'hFF, 8'hFF, 8'hFF, 8'h1D, 8'h3D, 8'h1E, 8'h1F, 8'h1B, 8'h13, 8'h0B, 8'h27, 8'h47, 8'h86, 8'hA6, 8'hE7, 8'hE7, 8'hE7, 8'hE3, 8'hE6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF0, 8'hFC, 8'hBC, 8'hFF, 8'hFF, 8'hFF, 8'h3D, 8'h1D, 8'h1E, 8'h1F, 8'h1B, 8'h13, 8'h0F, 8'h27, 8'h47, 8'hA0, 8'hA0, 8'hC6, 8'hE7, 8'hE7, 8'hE7, 8'hE6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF0, 8'hFC, 8'hBC, 8'hFF, 8'hFF, 8'hFF, 8'h1D, 8'h3D, 8'h3A, 8'h3E, 8'h3B, 8'h13, 8'h0F, 8'h07, 8'h47, 8'hA0, 8'hC0, 8'hC6, 8'hE7, 8'hE7, 8'hE3, 8'hE6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF0, 8'hFC, 8'hDC, 8'hFF, 8'hFF, 8'hFF, 8'h1C, 8'h68, 8'h6D, 8'h56, 8'h85, 8'h4E, 8'h0F, 8'h07, 8'h27, 8'h81, 8'hA1, 8'hC7, 8'hE7, 8'hE7, 8'hE7, 8'hE6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF0, 8'hFC, 8'hDC, 8'hFF, 8'hFF, 8'hFF, 8'h6C, 8'hC0, 8'h84, 8'h51, 8'hC0, 8'h85, 8'h0F, 8'h0B, 8'h27, 8'h66, 8'h86, 8'hA1, 8'hC2, 8'hE7, 8'hE7, 8'hEA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD1, 8'hF8, 8'hDC, 8'h9C, 8'h7C, 8'h3C, 8'h50, 8'hC0, 8'hA4, 8'h56, 8'hC0, 8'h69, 8'h2E, 8'h26, 8'h46, 8'h81, 8'h82, 8'hA0, 8'hC1, 8'hE7, 8'hE3, 8'hEA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF1, 8'hF8, 8'hDC, 8'hBC, 8'h7C, 8'h74, 8'h54, 8'h84, 8'h89, 8'h3E, 8'h6D, 8'h4E, 8'hA0, 8'h65, 8'h61, 8'hA0, 8'hA0, 8'hC0, 8'hC1, 8'hC7, 8'hE7, 8'hF2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF4, 8'hDC, 8'hBC, 8'h94, 8'hA0, 8'hA0, 8'h51, 8'h39, 8'h1E, 8'h1F, 8'h69, 8'hC0, 8'h81, 8'h80, 8'hC0, 8'hC0, 8'hC0, 8'hC1, 8'hC7, 8'hE2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF4, 8'hFC, 8'hBC, 8'h98, 8'hA0, 8'hA0, 8'h88, 8'h1D, 8'h3A, 8'h4D, 8'h69, 8'hC0, 8'h85, 8'h80, 8'hC0, 8'hC0, 8'hC0, 8'hC1, 8'hC6, 8'hE6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD1, 8'hFC, 8'hAC, 8'h88, 8'hC0, 8'hC0, 8'h84, 8'h3D, 8'h55, 8'hC0, 8'h69, 8'h89, 8'h66, 8'h80, 8'hC0, 8'hC0, 8'hC0, 8'hC1, 8'hC3, 8'hEA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF1, 8'hD8, 8'hA0, 8'hC0, 8'hC0, 8'hC0, 8'h84, 8'h51, 8'h69, 8'hC0, 8'h69, 8'h17, 8'h2F, 8'h65, 8'hA0, 8'hC0, 8'hC0, 8'hA1, 8'hC2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD0, 8'hC4, 8'hC0, 8'hC0, 8'hC0, 8'h84, 8'h84, 8'hC0, 8'hC0, 8'h89, 8'h17, 8'h0F, 8'h26, 8'h80, 8'hC0, 8'hC0, 8'hC6, 8'hE6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD1, 8'hC8, 8'hC0, 8'hC0, 8'hC0, 8'h88, 8'h88, 8'hC0, 8'hC0, 8'h89, 8'h33, 8'h2E, 8'h45, 8'h61, 8'hA0, 8'hC0, 8'hC2, 8'hEE, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hAC, 8'hC4, 8'hC0, 8'hC0, 8'h8C, 8'h70, 8'hC0, 8'hC0, 8'h89, 8'h69, 8'h65, 8'hA0, 8'h81, 8'h66, 8'hA1, 8'hC6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hAD, 8'h90, 8'hC0, 8'hC0, 8'h6C, 8'h1D, 8'h6D, 8'hA4, 8'h6D, 8'hA4, 8'hC0, 8'hC0, 8'h80, 8'h47, 8'h83, 8'hCA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h94, 8'h74, 8'h88, 8'h54, 8'h1D, 8'h1E, 8'h3E, 8'h3A, 8'h85, 8'hC0, 8'hC0, 8'h81, 8'h47, 8'h82, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD1, 8'h7C, 8'h5C, 8'h1C, 8'h1D, 8'h3D, 8'h69, 8'h6D, 8'h4E, 8'hA0, 8'hC0, 8'h61, 8'h43, 8'hAA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h94, 8'h5C, 8'h3C, 8'h1D, 8'h39, 8'hC0, 8'h89, 8'h37, 8'h84, 8'hC0, 8'h46, 8'h66, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD1, 8'h58, 8'h3C, 8'h1D, 8'h3D, 8'hA4, 8'h6D, 8'h1B, 8'h52, 8'h85, 8'h27, 8'hAA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h90, 8'h3C, 8'h1D, 8'h1D, 8'h3A, 8'h3A, 8'h1B, 8'h13, 8'h0F, 8'h66, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h54, 8'h1C, 8'h3D, 8'h1E, 8'h1E, 8'h3B, 8'h17, 8'h2A, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB1, 8'h3C, 8'h1D, 8'h1E, 8'h1E, 8'h1B, 8'h17, 8'h8D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h70, 8'h1D, 8'h3E, 8'h3E, 8'h1F, 8'h6E, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h55, 8'h1E, 8'h1E, 8'h56, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD1, 8'h39, 8'h3A, 8'hB1, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hAD, 8'hAD, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
},
{{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCD, 8'hAC, 8'hCD, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hC5, 8'hC1, 8'hC1, 8'hC5, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB0, 8'hFF, 8'hFF, 8'hFF, 8'h55, 8'hCD, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hA9, 8'h62, 8'h87, 8'hC7, 8'hE7, 8'hE3, 8'hC2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD1, 8'h9C, 8'hFF, 8'hFF, 8'hFF, 8'h1D, 8'h39, 8'hAD, 8'hFF, 8'hFF, 8'hFF, 8'hA9, 8'h26, 8'h47, 8'h87, 8'hC3, 8'hE7, 8'hE7, 8'hE7, 8'hC6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD4, 8'hBC, 8'hFF, 8'hFF, 8'hFF, 8'h3D, 8'h1E, 8'h3A, 8'hAD, 8'hFF, 8'hCE, 8'h26, 8'h27, 8'h67, 8'h83, 8'hC7, 8'hE7, 8'hE7, 8'hE3, 8'hE2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD8, 8'hBC, 8'hFF, 8'hFF, 8'hFF, 8'h1D, 8'h3E, 8'h1E, 8'h3A, 8'hCD, 8'h4E, 8'h0B, 8'h27, 8'h47, 8'h87, 8'hA3, 8'hE7, 8'hE7, 8'hE7, 8'hE6, 8'hEE, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF1, 8'hDC, 8'hBC, 8'hFF, 8'hFF, 8'hFF, 8'h3D, 8'h1D, 8'h1E, 8'h1F, 8'h52, 8'h2F, 8'h0B, 8'h27, 8'h47, 8'h87, 8'hA7, 8'hE7, 8'hE7, 8'hE7, 8'hE7, 8'hEA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF1, 8'hFC, 8'hBC, 8'hFF, 8'hFF, 8'hFF, 8'h1D, 8'h3D, 8'h1E, 8'h1F, 8'h1B, 8'h13, 8'h0B, 8'h27, 8'h47, 8'h86, 8'hA6, 8'hE7, 8'hE7, 8'hE7, 8'hE3, 8'hE6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF0, 8'hFC, 8'hBC, 8'h9C, 8'h5C, 8'h3C, 8'h3D, 8'h1D, 8'h1E, 8'h1F, 8'h1B, 8'h13, 8'h0F, 8'h27, 8'h47, 8'hA0, 8'hA0, 8'hC6, 8'hE7, 8'hE7, 8'hE7, 8'hE6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF0, 8'hFC, 8'hBC, 8'h9C, 8'h5C, 8'h3C, 8'h1D, 8'h3D, 8'h3A, 8'h3E, 8'h3B, 8'h13, 8'h0F, 8'h07, 8'h47, 8'hA0, 8'hC0, 8'hC6, 8'hE7, 8'hE7, 8'hE3, 8'hE6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF0, 8'hFC, 8'hDC, 8'h9C, 8'h5C, 8'h3C, 8'h1C, 8'h68, 8'h6D, 8'h56, 8'h85, 8'h4E, 8'h0F, 8'h07, 8'h27, 8'h81, 8'hA1, 8'hC7, 8'hE7, 8'hE7, 8'hE7, 8'hE6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF0, 8'hFC, 8'hDC, 8'h9C, 8'h7C, 8'h3C, 8'h6C, 8'hC0, 8'h84, 8'h51, 8'hC0, 8'h85, 8'h0F, 8'h0B, 8'h27, 8'h66, 8'h86, 8'hA1, 8'hC2, 8'hE7, 8'hE7, 8'hEA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD1, 8'hF8, 8'hDC, 8'h9C, 8'h7C, 8'h3C, 8'h50, 8'hC0, 8'hA4, 8'h56, 8'hC0, 8'h69, 8'h2E, 8'h26, 8'h46, 8'h81, 8'h82, 8'hA0, 8'hC1, 8'hE7, 8'hE3, 8'hEA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF1, 8'hF8, 8'hDC, 8'hBC, 8'h7C, 8'h74, 8'h54, 8'h84, 8'h89, 8'h3E, 8'h6D, 8'h4E, 8'hA0, 8'h65, 8'h61, 8'hA0, 8'hA0, 8'hC0, 8'hC1, 8'hC7, 8'hE7, 8'hF2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF4, 8'hDC, 8'hBC, 8'h94, 8'hA0, 8'hA0, 8'h51, 8'h39, 8'h1E, 8'h1F, 8'h69, 8'hC0, 8'h81, 8'h80, 8'hC0, 8'hC0, 8'hC0, 8'hC1, 8'hC7, 8'hE2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF4, 8'hFC, 8'hBC, 8'h98, 8'hA0, 8'hA0, 8'h88, 8'h1D, 8'h3A, 8'h4D, 8'h69, 8'hC0, 8'h85, 8'h80, 8'hC0, 8'hC0, 8'hC0, 8'hC1, 8'hC6, 8'hE6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD1, 8'hFC, 8'hAC, 8'h88, 8'hC0, 8'hC0, 8'h84, 8'h3D, 8'h55, 8'hC0, 8'h69, 8'h89, 8'h66, 8'h80, 8'hC0, 8'hC0, 8'hC0, 8'hC1, 8'hC3, 8'hEA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF1, 8'hD8, 8'hA0, 8'hC0, 8'hC0, 8'hC0, 8'h84, 8'h51, 8'h69, 8'hC0, 8'h69, 8'h17, 8'h2F, 8'h65, 8'hA0, 8'hC0, 8'hC0, 8'hA1, 8'hC2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD0, 8'hC4, 8'hC0, 8'hC0, 8'hC0, 8'h84, 8'h84, 8'hC0, 8'hC0, 8'h89, 8'h17, 8'h0F, 8'h26, 8'h80, 8'hC0, 8'hC0, 8'hC6, 8'hE6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD1, 8'hC8, 8'hC0, 8'hC0, 8'hC0, 8'h88, 8'h88, 8'hC0, 8'hC0, 8'h89, 8'h33, 8'h2E, 8'h45, 8'h61, 8'hA0, 8'hC0, 8'hC2, 8'hEE, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hAC, 8'hC4, 8'hC0, 8'hC0, 8'h8C, 8'h70, 8'hC0, 8'hC0, 8'h89, 8'h69, 8'h65, 8'hA0, 8'h81, 8'h66, 8'hA1, 8'hC6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hAD, 8'h90, 8'hC0, 8'hC0, 8'h6C, 8'h1D, 8'h6D, 8'hA4, 8'h6D, 8'hA4, 8'hC0, 8'hC0, 8'h80, 8'h47, 8'h83, 8'hCA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h94, 8'h74, 8'h88, 8'h54, 8'h1D, 8'h1E, 8'h3E, 8'h3A, 8'h85, 8'hC0, 8'hC0, 8'h81, 8'h47, 8'h82, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD1, 8'h7C, 8'h5C, 8'h1C, 8'h1D, 8'h3D, 8'h69, 8'h6D, 8'h4E, 8'hA0, 8'hC0, 8'h61, 8'h43, 8'hAA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h94, 8'h5C, 8'h3C, 8'h1D, 8'h39, 8'hC0, 8'h89, 8'h37, 8'h84, 8'hC0, 8'h46, 8'h66, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD1, 8'h58, 8'h3C, 8'h1D, 8'h3D, 8'hA4, 8'h6D, 8'h1B, 8'h52, 8'h85, 8'h27, 8'hAA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h90, 8'h3C, 8'h1D, 8'h1D, 8'h3A, 8'h3A, 8'h1B, 8'h13, 8'h0F, 8'h66, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h54, 8'h1C, 8'h3D, 8'h1E, 8'h1E, 8'h3B, 8'h17, 8'h2A, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB1, 8'h3C, 8'h1D, 8'h1E, 8'h1E, 8'h1B, 8'h17, 8'h8D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h70, 8'h1D, 8'h3E, 8'h3E, 8'h1F, 8'h6E, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h55, 8'h1E, 8'h1E, 8'h56, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD1, 8'h39, 8'h3A, 8'hB1, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hAD, 8'hAD, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
}};
 

logic [0:5] [0:13] [1:0]  aliens_data = aliens_data_default[0];
logic [0:2] [0:31] [0:31] [7:0] aliens_colors = aliens_colors_default;
// pipeline (ff) to get the pixel color from the array 	 

//==----------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN) begin
	
	if(!resetN) begin
		RGBout <=	8'h00;
		aliens_data <= aliens_data_default[0];
		aliens_colors <= aliens_colors_default;
	end
	
	else begin
		RGBout <= TRANSPARENT_ENCODING ; // default 

		if (InsideRectangle == 1'b1) begin // only if inside the external bracket 
		
			if (aliens_data[offsetY[10:5]][offsetX[10:5]] == 2'b01) begin // take bits 5,6,7,8,9,10 from address to select  position in the maze    
				RGBout <= aliens_colors[aliens_data[offsetY[10:5]][offsetX[10:5]] - 1][offsetY[4:0]][offsetX[4:0]];
			end
			
			else if (aliens_data[offsetY[10:5]][offsetX[10:5]] == 2'b10) begin // take bits 5,6,7,8,9,10 from address to select  position in the maze    
				RGBout <= aliens_colors[aliens_data[offsetY[10:5]][offsetX[10:5]] - 1][offsetY[4:0]][offsetX[4:0]];
			end
			
			else if (aliens_data[offsetY[10:5]][offsetX[10:5]] == 2'b11) begin // take bits 5,6,7,8,9,10 from address to select  position in the maze    
				RGBout <= aliens_colors[aliens_data[offsetY[10:5]][offsetX[10:5]] - 1][offsetY[4:0]][offsetX[4:0]];
			end
			
			if (alienHit != 2'b0 && (aliens_data[offsetY[10:5]][offsetX[10:5]] != 2'b0)) begin
				aliens_data[offsetY[10:5]][offsetX[10:5]] <= aliens_data[offsetY[10:5]][offsetX[10:5]] - 2'b1;
			end
		end
	end
end

//==----------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   
endmodule

