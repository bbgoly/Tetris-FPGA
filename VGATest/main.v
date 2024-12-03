module main(input MAX10_CLK1_50, input [1:0] KEY, output VGA_VS, output VGA_HS, output [3:0] VGA_R, output [3:0] VGA_G, output [3:0] VGA_B);

wire VGA_CTRL_CLK;

vga_pll u1(
	.areset(),
	.inclk0(MAX10_CLK1_50),
	.c0(VGA_CTRL_CLK),
	.locked());

// VGA Framebuffer Update Enable and Coordinates
reg iUPDATE_EN;
reg [6:0] iUPDATE_X;
reg [5:0] iUPDATE_Y;
reg [11:0] iUPDATE_DATA;  // Color data to update the block (12 bits)

// Framebuffer color changing logic (cycle through different colors)
reg [31:0] color_counter; // Color change counter (for cycling colors)
						 
vga_controller_framebuffer_ex vga_display (
        .iRST_n(KEY[1]),        // Use KEY[1] for reset
        .iVGA_CLK(VGA_CTRL_CLK),  // VGA clock
        .iUPDATE_EN(iUPDATE_EN),  // Update enable
        .iUPDATE_X(iUPDATE_X),    // Block X coordinate to update
        .iUPDATE_Y(iUPDATE_Y),    // Block Y coordinate to update
        .iUPDATE_DATA(iUPDATE_DATA), // Data to update
        .oHS(VGA_HS),             // VGA Horizontal Sync
        .oVS(VGA_VS),             // VGA Vertical Sync
        .oBLANK_n(),              // Blank signal (not connected here)
        .oVGA_R(VGA_R),           // VGA Red channel
        .oVGA_G(VGA_G),           // VGA Green channel
        .oVGA_B(VGA_B)            // VGA Blue channel
    );

reg [6:0] x_block, y_block; // Block coordinates (for updating blocks across the screen)

/// Update Enable Latching Logic
reg [1:0] update_counter; // Counter for holding `iUPDATE_EN` active

always @(posedge VGA_VS or negedge KEY[0]) begin
    if (!KEY[0]) begin
        iUPDATE_EN <= 0;
        update_counter <= 0;
        x_block <= 0;
        y_block <= 0;
    end else begin
        if (y_block < GRID_H) begin
            if (x_block < GRID_W) begin
                if (update_counter == 0) begin
                    iUPDATE_X <= x_block;
                    iUPDATE_Y <= y_block;
                    iUPDATE_DATA <= 12'hFFF; // White color
                    iUPDATE_EN <= 1; // Enable the update
                    update_counter <= 2; // Hold `iUPDATE_EN` for 2 cycles
                end else begin
                    update_counter <= update_counter - 1;
                    if (update_counter == 1) begin
                        iUPDATE_EN <= 0; // Disable after the duration
                        x_block <= x_block + 1; // Move to next block
                    end
                end
            end else begin
                x_block <= 0;
                y_block <= y_block + 1;
            end
        end else begin
            x_block <= 0;
            y_block <= 0;
        end
    end
end

//always @(posedge VGA_VS or negedge KEY[0]) begin
//    if (!KEY[0]) begin
//        x_block <= 0;
//        y_block <= 0;
//    end else begin
//        if (y_block < GRID_H) begin
//            if (x_block < GRID_W) begin
//                iUPDATE_X <= x_block;
//                iUPDATE_Y <= y_block;
//                iUPDATE_DATA <= 12'hFFF; // White color
//                iUPDATE_EN <= 1;
//                x_block <= x_block + 1;
//            end else begin
//                x_block <= 0;
//                y_block <= y_block + 1;
//            end
//        end else begin
//            x_block <= 0;
//            y_block <= 0;
//        end
//    end
//end


	parameter VIDEO_W = 640;
    parameter VIDEO_H = 480;
    parameter BLOCK_SIZE = 32;       // Size of each "macro pixel" block
    parameter GRID_W = VIDEO_W / BLOCK_SIZE; // Number of blocks horizontally (10)
    parameter GRID_H = VIDEO_H / BLOCK_SIZE; // Number of blocks vertically (8)

endmodule
