module main(
	input MAX10_CLK1_50,
	input [1:0] KEY,
	input [9:0] SW,
	
	output reg [3:0] VGA_R,
	output reg [3:0] VGA_G,
	output reg [3:0] VGA_B,
	output reg VGA_HS,
	output reg VGA_VS
);

wire [31:0] col, row;
wire [3:0] red, green, blue;

wire h_sync, v_sync;
wire disp_ena;
wire vga_clk;

vga_controller vgacrtl (
   .pixel_clk	(vga_clk),
   .reset_n    (KEY[0]),
   .h_sync     (h_sync),
   .v_sync     (v_sync),
   .disp_ena   (disp_ena),
   .column     (col),
   .row        (row)
);

temp_comb_ckt_generator framebuffer (
	.col 		(col[9:0]),
	.row 		(row[8:0]),
	.red 		(red),
	.green 	(green),
	.blue 	(blue),
	.SW 		(SW)
);

vga_pll vgapll (
    .inclk0	(MAX10_CLK1_50),
    .c0		(vga_clk)
);

always @(posedge vga_clk) begin
   if (disp_ena) begin
      VGA_R <= red;
      VGA_B <= blue;
      VGA_G <= green;
   end else begin
      VGA_R <= 4'd0;
      VGA_B <= 4'd0;
      VGA_G <= 4'd0;
   end
   VGA_HS <= h_sync;
   VGA_VS <= v_sync;
end

endmodule
