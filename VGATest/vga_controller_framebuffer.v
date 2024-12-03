//module vga_controller_framebuffer(RST_n, VGA_CLK, UPDATE_EN, );
//
//input RST_n;
//input VGA_CLK;
//input UPDATE_EN;
//
//output reg HS;
//output reg VS;
//output reg BLANK_n;
//
//output reg [3:0] VGA_R;
//output reg [3:0] VGA_G;
//output reg [3:0] VGA_B;
//
//parameter VIDEO_WIDTH = 640;
//parameter VIDEO_HEIGHT = 480;
//
//// How many pixels in a square block should be considered to be within the same block (we chose the block to be 32x32)
//// By grouping pixels into blocks, we can reduce the number of pixels stored in the frame buffer by 1024x,
//// 
//// maybe below not exactly correct
//// But since we only take half the possible width to store the Tetris grid, we reduce the number of pixels stored by 2048x instead
//// More precisely, it lowers the number of pixels saved from 640*480 = 307,200 pixels to only 10*15 = 150 blocks of pixels
//parameter PIXEL_BLOCK_SIZE = 32;
//parameter BUFFER_GRID_WIDTH = VIDEO_WIDTH / PIXEL_BLOCK_SIZE;
//parameter BUFFER_GRID_HEIGHT = VIDEO_HEIGHT / PIXEL_BLOCK_SIZE;
//
//// BUFFER_WIDTH x BUFFER_HEIGHT x COLOR_DEPTH bit wide frame buffer
//// For a 32x32 block size, the frame buffer represent take 20 blocks x 15 blocks, with 12-bits of color data in each block,
//// so the frame buffer takes 20*15*12 = 3600 bits, or 450 bytes. 
////
//// This is MUCH lower than the original ~460.8 KB of memory that representing every pixel in the frame buffer would occupy,
//// which is larger than the memory on the DE10-Lite anyways.
//reg [11:0] frameBuffer[0:BUFFER_GRID_WIDTH - 1][0:BUFFER_GRID_HEIGHT - 1];
//
//reg [$clog2(BUFFER_GRID_WIDTH):0] screenAddrX;
//reg [$clog2(BUFFER_GRID_HEIGHT):0] screenAddrY;
//
//reg [11:0] pixelData;
//
//wire syncHS, syncVS, syncBlankingPeriod_n;
//
//video_sync_generator sync(VGA_CLK, ~RST_n, syncBlankingPeriod_n, syncHS, syncVS);
//
//always @(posedge VGA_CLK or negedge RST_n) begin
//	if (!RST_n) begin
//		screenAddrX <= 0;
//		screenAddrY <= 0;
//	end else if (syncBlankingPeriod_n) begin
//		if (screenAddrX < BUFFER_GRID_WIDTH) begin
//			screenAddrX = screenAddrX + 1;
//		end else begin
//		
//		end
//	end
//end
//
//endmodule
