module temp_comb_ckt_generator (
	input [9:0] col,
	input [8:0] row,
	input [2:0] SW,
	
	output  [3:0] red,
	output  [3:0] green,
	output  [3:0] blue
);

assign red = SW[0] ? 4'hf : 4'h0; 
assign green = SW[1] ? 4'hf : 4'h0;
assign blue = SW[2] ? 4'hf : 4'h0;

//localparam GRID_SIZE = 20;
//
//always @(*) begin
//	if (((col / GRID_SIZE) % 2 == 0 && (row / GRID_SIZE) % 2 == 0) || 
//		((col / GRID_SIZE) % 2 == 1 && (row / GRID_SIZE) % 2 == 1)) begin
//		red <= 4'hF;
//		green <= 4'hF;
//		blue <= 4'hF;
//	end else begin
//		red <= 4'h0;
//		green <= 4'h0;
//		blue <= 4'h0;
//	end
//end

endmodule
