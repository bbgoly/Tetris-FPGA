module vga_framebuffer #(
	parameter BLOCK_SIZE = 32
	parameter VIDEO_WIDTH = 640
	parameter VIDEO_HEIGHT = 480
) (
	input [9:0] col,
	input [8:0] row,
	input RESET_n,
	
	output reg [3:0] red,
	output reg [3:0] green,
	output reg [3:0] blue
);


localparam GRID_WIDTH = VIDEO_WIDTH / BLOCK_SIZE;
localparam GRID_HEIGHT = VIDEO_HEIGHT / BLOCK_SIZE;

wire [4:0] block_x = col / BLOCK_SIZE;

endmodule
