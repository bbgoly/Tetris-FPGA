module vga_controller_framebuffer_ex (
    input iRST_n,                // Active low reset
    input iVGA_CLK,              // VGA clock (25 MHz for 640x480)
    input iUPDATE_EN,            // Enable frame buffer update
    input [6:0] iUPDATE_X,       // X coordinate of block to update (0-9)
    input [5:0] iUPDATE_Y,       // Y coordinate of block to update (0-7)
    input [11:0] iUPDATE_DATA,   // Frame buffer data to update
    output reg oHS,              // Horizontal sync
    output reg oVS,              // Vertical sync
//    output reg oBLANK_n,         // Blank signal
    output [3:0] oVGA_R,         // VGA red channel
    output [3:0] oVGA_G,         // VGA green channel
    output [3:0] oVGA_B          // VGA blue channel
);

    // VGA Parameters
    parameter VIDEO_W = 640;
    parameter VIDEO_H = 480;
    parameter BLOCK_SIZE = 32;       // Size of each "macro pixel" block
    parameter GRID_W = VIDEO_W / BLOCK_SIZE; // Number of blocks horizontally (10)
    parameter GRID_H = VIDEO_H / BLOCK_SIZE; // Number of blocks vertically (8)

    // Frame Buffer (10x8 grid, 12 bits per block)
    reg [11:0] frame_buffer [0:GRID_W-1][0:GRID_H-1];

    // Internal Signals
    wire cHS, cVS, cBLANK_n;
    reg [10:0] x, y;          // Current pixel coordinates
    reg [3:0] block_x;        // Current block X coordinate
    reg [3:0] block_y;        // Current block Y coordinate
    reg [11:0] pixel_data;    // Current pixel data (block color)

    // VGA Timing Generator
    video_sync_generator vga_sync (
        .vga_clk(iVGA_CLK),
        .reset(~iRST_n),
        .blank_n(cBLANK_n),
        .HS(cHS),
        .VS(cVS)
    );

    // Pixel Coordinates
    always @(posedge iVGA_CLK or negedge iRST_n) begin
        if (!iRST_n) begin
            x <= 0;
            y <= 0;
        end else if (cBLANK_n) begin
            if (x == VIDEO_W - 1) begin
                x <= 0;
                if (y == VIDEO_H - 1)
                    y <= 0;
                else
                    y <= y + 1;
            end else begin
                x <= x + 1;
            end
        end
    end

    // Calculate Block Coordinates
    always @(posedge iVGA_CLK) begin
        block_x <= x / BLOCK_SIZE; // Horizontal block index
        block_y <= y / BLOCK_SIZE; // Vertical block index
    end

	 integer i, j;
    // Check if the current block is the updated block
    always @(posedge iVGA_CLK or negedge iRST_n) begin
			if (!iRST_n) begin
				for (i = 0; i < GRID_W; i = i + 1) begin
					for (j = 0; j < GRID_H; j = j + 1) begin
						frame_buffer[i][j] <= (i + j) % 2 ? 12'hFFF : 12'h000;
//						frame_buffer[i][j] <= 12'hFFF;
					end
				end
			end
        else if (iUPDATE_EN && block_x == iUPDATE_X && block_y == iUPDATE_Y) begin
            // Update the frame buffer with the new color data for this block
            frame_buffer[block_x][block_y] <= iUPDATE_DATA;
        end
    end

//	 	 integer i, j;
//    // Check if the current block is the updated block
//    always @(posedge iVGA_CLK or negedge iRST_n) begin
//			if (!iRST_n) begin
//				for (i = 0; i < GRID_W; i = i + 1) begin
//					for (j = 0; j < GRID_H; j = j + 1) begin
////						frame_buffer[i][j] <= (i + j) % 2 ? 12'hFFF : 12'h000;
//						frame_buffer[i][j] <= 12'hFFF;
//					end
//				end
//			end
//        else if (iUPDATE_EN) begin
//            // Update the frame buffer with the new color data for this block
//            frame_buffer[iUPDATE_X][iUPDATE_Y] <= iUPDATE_DATA;
//        end
//    end
	 
    // Read Block Color from Frame Buffer (color data for the current block)
    always @(posedge iVGA_CLK) begin
        pixel_data <= frame_buffer[block_x][block_y];
    end

    // Output Pixel Data (render the same color for every pixel in the block)
//    assign oVGA_B = pixel_data[11:8]; // Blue
//    assign oVGA_G = pixel_data[7:4];  // Green
//    assign oVGA_R = pixel_data[3:0];  // Red

    assign oVGA_B = 4'hF; // Blue
    assign oVGA_G = 4'h0;  // Green
    assign oVGA_R = 4'h0;  // Red

    // Output Timing Signals
    always @(posedge iVGA_CLK) begin
        oHS <= cHS;
        oVS <= cVS;
//        oBLANK_n <= cBLANK_n;
    end
endmodule
