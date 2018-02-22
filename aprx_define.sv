/*		 _   / '_/ 
 *		/ ()/)/ /                   
 *                           
 *   design 	:  approximate definitions 
 *   date		:  22.02.2018                      
 *   version	:  1.0                      
 *                           
 */

`define size 32

// 0 => IEEE 754 single precision
// 1 => binary16 alt
// 2 => binary8

`ifdef mode == 0
	`define exp