/*		 _   / '_/ 
 *		/ ()/)/ /                   
 *                           
 *   design 	:  approximate FP addition ; inputs are positive 32-bits binaries (binary16 alt & binary8 
 *				   A Transprecision Floating-Point Platform for Ultra-Low Power Computing 
 *				   https://arxiv.org/abs/1711.10374)                 
 *   date		:  21.02.2018                      
 *   version	:  1.0                      
 *                           
 */

module aprx_add 
	(input logic [31:0] a, [31:0] b,
	input int mode, // both modes can work independently and simultaneously
	output logic [15:0] c16,
	output logic [7:0] c8
		);

logic sign_a, sign_b, sign_c;

logic [7:0] exp_a, exp_b, exp_c, temp16;
logic [4:0] exp_a8, exp_b8, exp_c8, temp8;

logic [6:0] mant16_a, mant16_b, mant16_c;
logic [1:0] mant8_a, mant8_b, mant8_c;

assign sign_a = a [31];
assign sign_b = b [31];
// unnecessary step, as both inputs are positive (left for future improvements)
assign sign_c = sign_a & sign_b; 

bit [1:0] i = 2'b00;

always_comb begin 

	if (mode == 0) begin //16-bit
		assign exp_a = a [30:23] -127;
		assign exp_b = b [30:23] -127;
		assign mant16_a = a [22:16];
		assign mant16_b = b [22:16];
		if (exp_a >= exp_b) begin
			assign temp16 = exp_a - exp_b;
			assign i = temp16;
			assign mant16_b = mant16_b >> i;
			assign mant16_c = mant16_a + mant16_b;
			assign exp_c = exp_a +127;
		end 
		else if (exp_a < exp_b) begin
				assign temp16 = exp_b - exp_a;
				assign i = temp16;
				assign mant16_a = mant16_a >> i;
				assign mant16_c = mant16_a + mant16_b;
				assign exp_c = exp_b +127;
		end

	end
	else if (mode == 1) begin //8-bit
			assign exp_a8 = a [30:26] -15;
			assign exp_b8 = b [30:26] -15;
			assign mant8_a = a [22:21];
			assign mant8_b = b [22:21];
			if (exp_a8 >= exp_b8) begin
				assign temp8 = exp_a8 - exp_b8;
				assign i = temp8;
				assign mant8_b = mant8_b >> i;
				assign mant8_c = mant8_a + mant8_b;
				assign exp_c8 = exp_a8 +15;
			end 
			else if (exp_a8 < exp_b8) begin
					assign temp8 = exp_b8 - exp_a8;
					assign i = temp8;
					assign mant8_a = mant8_a >> i;
					assign mant8_c = mant8_a + mant8_b;
					assign exp_c8 = exp_b8 +15;
			end

	end 
end
assign c16 [15] = sign_c;
assign c16 [14:7] = exp_c;
assign c16 [6:0] = mant16_c;

assign c8 [7] = sign_c;
assign c8 [6:2] = exp_c8;
assign c8 [1:0] = mant8_c;

endmodule

//simulation results

// a = 32'h420f0000;
// b = 32'h41a40000;

// c32 = 32'h42610000;
// c16 = 16'h4221;
// c8  =  8'h41;

// dynamic range or precision are reduced before any add operations