// 32X32 Multiplier test template
module mult32x32_test;

    logic clk;            // Clock
    logic reset;          // Reset
    logic start;          // Start signal
    logic [31:0] a;       // Input a
    logic [31:0] b;       // Input b
    logic busy;           // Multiplier busy indication
    logic [63:0] product; // Miltiplication product

mult32x32 test( .clk(clk), .reset(reset), .start(start), .a(a),
			.b(b), .busy(busy), .product(product));

always begin
	#10 clk=~clk;
end

initial begin
	clk = 1'b0;
	start=1'b0;;
	reset=1'b1;
	repeat(4) begin
		@(posedge clk);
	end
	reset=1'b0;
	a=32'd207363151;
	b=32'd206950149;
	@(posedge clk);
	start=1;
	@(posedge clk);
	start=0;
	repeat(9)begin
		@(posedge clk);
	end
end
endmodule


