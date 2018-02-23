/*		 _   / '_/ 
 *		/ ()/)/ /                   
 *                           
 *   design 	:  approximate FP multiplication; inputs are positive or negative 32-bit binaries (binary16 alt & binary8 
 *				   A Transprecision Floating-Point Platform for Ultra-Low Power Computing 
 *				   https://arxiv.org/abs/1711.10374)                 
 *   date		:  21.02.2018                      
 *   version	:  1.0                      
 *                           
 */

module aprx_mul
	(input logic [31:0] a , [31:0] b,
	input mode,
	output [15:0] c16,
	output [7:0] c8
		);

logic sign_a , sign_b , sign_c;

logic [7:0] exp_a , exp_b , exp_c;
logic [7:0] mant_a , mant_b , mant_c;
logic [15:0] mant_c1;

logic [4:0] exp_a8 , exp_b8 , exp_c8;
logic [2:0] mant_a8 , mant_b8 , mant_c8;
logic [5:0] mant_c2;

bit m1, m2;

assign sign_a = a [31];
assign sign_b = b [31];

assign exp_a = a [30:23] -127;
assign exp_b = b [30:23] -127;

assign exp_a8 = a [30:26] -15;
assign exp_b8 = b [30:26] -15;

assign mant_a [7] = 1'b1;
assign mant_a [6:0] = a [22:16];
assign mant_b [7] = 1'b1;
assign mant_b [6:0] = b [22:16];

assign mant_a8 [2] = 1'b1;
assign mant_a8 [1:0] = a [22:21];
assign mant_b8 [2] = 1'b1;
assign mant_b8 [1:0] = b [22:21];

assign mant_c1 = mant_a * mant_b;
assign m1 = mant_c1[15];

assign mant_c2 = mant_a8 * mant_b8;
assign m2 = mant_c2[5];

always_comb begin

	if (mode == 0) begin
		if (m1 == 1) begin
			assign exp_c = exp_a + exp_b + 1'b1;
			assign mant_c = mant_c1 [14:7];
			assign sign_c = sign_a ^ sign_b;
		end
		else begin
			assign exp_c = exp_a + exp_b;
			assign mant_c = mant_c1 [14:7];
			assign sign_c = sign_a ^ sign_b;
		end 
	end 
	else if (mode == 1) begin
		if (m2 == 1) begin
			assign exp_c8 = exp_a8 + exp_b8 + 1'b1;
			assign mant_c8 = mant_c2 [4:1];
			assign sign_c = sign_a ^ sign_b;
		end
		else begin
			assign exp_c8 = exp_a8 + exp_b8;
			assign mant_c8 = mant_c2 [4:1];
			assign sign_c = sign_a ^ sign_b;
		end
	end 
end 

assign c16[15] = sign_c;
assign c16[14:7] = exp_c;
assign c16[6:0] = mant_c[6:0];

assign c8[7] = sign_c;
assign c8[6:2] = exp_c8;
assign c8[1:0] = mant_c8[1:0];

mult mul11 (
	.a(a));


endmodule

//simulation results

// a = 32'hFEE66666;
// b = 32'h7F0F5C28;

// c32 = 32'hFE810623;
// c16 = 16'hFF00;
// c8  =  8'h82;

// mantissa is not correct
// casting from 32-bit to either 16-bit or 8-bit does not work correctly

// dynamic range or precision are reduced before any add operations