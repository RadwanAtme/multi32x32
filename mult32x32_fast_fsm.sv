// 32X32 Multiplier FSM
module mult32x32_fast_fsm (
    input logic clk,              // Clock
    input logic reset,            // Reset
    input logic start,            // Start signal
    input logic a_msb_is_0,       // Indicates MSB of operand A is 0
    input logic b_msw_is_0,       // Indicates MSW of operand B is 0
    output logic busy,            // Multiplier busy indication
    output logic [1:0] a_sel,     // Select one byte from A
    output logic b_sel,           // Select one 2-byte word from B
    output logic [2:0] shift_sel, // Select output from shifters
    output logic upd_prod,        // Update the product register
    output logic clr_prod         // Clear the product register
);

typedef enum {Idle, a0Xb0, a1Xb0, a2Xb0, a3Xb0,
 a0Xb1, a1Xb1, a2Xb1, a3Xb1} sm_type;
 
sm_type current, next;

always_ff @(posedge clk, posedge reset) begin
	if(reset==1'b1) begin
		current <= Idle;
	end
	else begin
		current <= next;
	end
end


always_comb begin
	next=Idle;
	busy=1'b0;
	upd_prod=1'b0;
	clr_prod=1'b0;
	a_sel=2'b00;
	b_sel=1'b0;
	shift_sel=3'b000;
	case(current)
		Idle: if(start==1)begin
			next=a0Xb0;
			busy=1'b0;   		
			upd_prod=1'b0;		
			clr_prod=1'b1;
		end
		a0Xb0:begin
			next=a1Xb0;
			busy=1'b1;
			a_sel=2'b00; 		
			b_sel=1'b0;
			shift_sel=3'b000;	
			upd_prod=1'b1;
			clr_prod=1'b0;		
		end
		a1Xb0:begin
			next=a2Xb0;
			busy=1'b1;
			a_sel=2'b01;
			b_sel=1'b0;			
			shift_sel=3'b001;
			upd_prod=1'b1;
			clr_prod=1'b0;		
			end
		a2Xb0:begin
			busy=1'b1;
			a_sel=2'b10;
			b_sel=1'b0; 	
			shift_sel=3'b010;
			upd_prod=1'b1;
			clr_prod=1'b0; 
			if((a_msb_is_0==0)) begin
				next=a3Xb0;	
			end
			
			
			else if ((a_msb_is_0==1) && (b_msw_is_0==0)) begin
				next=a0Xb1;
			end
			
		
			else if((a_msb_is_0==1) && (b_msw_is_0==1)) begin
				next=Idle; 	
			end
			

		end
		a3Xb0:begin
			busy=1'b1;
			a_sel=2'b11;
			b_sel=1'b0;			
			shift_sel=3'b011;
			upd_prod=1'b1;
			clr_prod=1'b0; 		
			
			if((a_msb_is_0==0) && (b_msw_is_0==0)) begin
				next=a0Xb1;
			end
			
		
			else if ((a_msb_is_0==0) && (b_msw_is_0==1)) begin
				next=Idle;
			end
			

		end
		a0Xb1:begin
			next=a1Xb1;
			busy=1'b1;
			a_sel=2'b00;		
			b_sel=1'b1;
			shift_sel=3'b010;
			upd_prod=1'b1;
			clr_prod=1'b0;	
		end
		a1Xb1:begin
			next=a2Xb1;
			busy=1'b1;
			a_sel=2'b01;
			b_sel=1'b1;
			shift_sel=3'b011;
			upd_prod=1'b1;
			clr_prod=1'b0;		
		end
		a2Xb1:begin
			busy=1'b1;
			a_sel=2'b10;
			b_sel=1'b1;
			shift_sel=3'b100;
			upd_prod=1'b1;
			clr_prod=1'b0;		
			if((a_msb_is_0==0) && (b_msw_is_0==0)) begin
				next=a3Xb1;
			end
			
	
			else if ((a_msb_is_0==1) && (b_msw_is_0==0)) begin
				next=Idle;
			end
			
		end
		a3Xb1:begin
			next=Idle;		
			busy=1'b1;
			a_sel=2'b11;
			b_sel=1'b1;
			shift_sel=3'b101;
			upd_prod=1'b1;
			clr_prod=1'b0;		
		end
	
	endcase
end

endmodule
