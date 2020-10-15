// 32X32 Multiplier arithmetic unit template
module mult32x32_arith (
    input logic clk,             // Clock
    input logic reset,           // Reset
    input logic [31:0] a,        // Input a
    input logic [31:0] b,        // Input b
    input logic [1:0] a_sel,     // Select one byte from A
    input logic b_sel,           // Select one 2-byte word from B
    input logic [2:0] shift_sel, // Select output from shifters
    input logic upd_prod,        // Update the product register
    input logic clr_prod,        // Clear the product register
    output logic [63:0] product  // Miltiplication product
);

logic [63:0] current, next;

logic [7:0] temp_a;
logic [15:0] temp_b;
logic [63:0] multiply_result, add_result;

always_comb begin
	case(a_sel) 
		2'b00: temp_a = a[7:0];
		2'b01: temp_a = a[15:8];
		2'b10: temp_a = a[23:16];
		2'b11: temp_a = a[31:24];
	endcase
	
	case(b_sel)
	1'b0: temp_b = b[15:0];
	1'b1: temp_b = b[31:16];
	endcase
	
	multiply_result = temp_b*temp_a;
	
	case(shift_sel) 
	3'b001: multiply_result = multiply_result << 8;
	3'b010: multiply_result = multiply_result << 16;
	3'b011: multiply_result = multiply_result << 24;
	3'b100: multiply_result = multiply_result << 32;
	3'b101: multiply_result = multiply_result << 40;
	default: multiply_result = multiply_result;
	endcase

end

always_ff @(posedge clk, posedge reset)begin
	product<=product;
	if(reset==1'b1 || clr_prod==1)begin
		product<=64'b0; 
	end
	else if (upd_prod==1)begin
		product<=product+multiply_result;
	end
end

endmodule
