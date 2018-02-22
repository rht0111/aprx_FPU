/*		 _   / '_/ 
 *		/ ()/)/ /                   
 *                           
 *   design 	:  approximate FP addition (binary16 alt & binary8 
 *				   A Transprecision Floating-Point Platform for Ultra-Low Power Computing 
 *				   https://arxiv.org/abs/1711.10374)                 
 *   date		:  21.02.2018                      
 *   version	:  1.0                      
 *                           
 */

module aprx_add 
	(input logic [31:0] a, [31:0] b,
	input int mode, //mode can be enabled to get specific results
	output logic [15:0] c16,
	output logic [7:0] c8
		);

logic sign_a, sign_b, sign_c;

logic [7:0] exp_a16, exp_b16, exp_c16;
logic [8:0] texp16;
logic [4:0] exp_a8, exp_b8, exp_c8;
logic [5:0] texp8;

logic [6:0] mant16_a, mant16_b, mant16_c;
logic [7:0] tmant16;
logic [1:0] mant8_a, mant8_b, mant8_c;
logic [2:0] tmant16;

assign sign_a = a [size-1];
assign sign_b = b [size-1];
// unnecessary step, as both inputs are positive (left for future improvements)
assign sign_c = sign_a & sign_b; 

always_comb begin 

	if (mode == 0) begin //32-bit
		assign exp_a = a [30:23];
		assign exp_a = b [30:23];
		assign 

endmodule