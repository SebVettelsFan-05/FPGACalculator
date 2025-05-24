/* I guess a three number calculator would be cool, so 10 bits would be the max
All stuff will be up to 10 bits, with two's complement, maybe 11 bits for overflow?
This library will cover the standard modules: AND, OR, MUXs, ADDERs, XORs?
Maybe we'll add in some sequential stuff as well? Registers?*/

/*
Standard: 11 bit buses for all devices
If using less than that, just don't use all of the bus
The 11th bit is reserved for overflow

Each of the gates will have up to 4 inputs, hopefully we won't need more than that lol

Coding Conventions for this library:
- Inputs are named in alphabetical order: a, b, c, d ...
- Outputs are named with "q", then a number: q, q0, q1, q2 ...
- Wires are named with "p", then a number: p, p0, p1, p2...
*/


/*
AND gates
Up to AND4
*/

//AND2
module AND2 (
	input 	[10:0] a, 
	input	[10:0] b,	
	output [10:0] q
	);
			 
	assign q = a & b;
endmodule

//AND3
module AND3 (
	input 	[10:0] a,
	input	[10:0] b,
	input	[10:0] c,
	output  [10:0] q);

	wire p [10:0];
	AND2 inter (a, b, p);
	AND2 final_result (c, p, q);
	
endmodule
	
//AND4
module AND4 (
	input 	[10:0] a,
	input 	[10:0] b,
	input 	[10:0] c,
	input   [10:0] d,
	output  [10:0] q);

	wire p [10:0];
	AND3 inter (a, b, c, p);
	AND2 final_result (p, d, q);
endmodule

/*
OR gates
Up to OR4
*/

//OR3
module OR3 (
	input  [10:0] a, 
	input  [10:0] b,
	input  [10:0] c,	
	output [10:0] q);
	wire p [10:0];		 
	assign q = a ^ b;
endmodule

//OR4
module OR4 (
	input 	[10:0] a,
	input 	[10:0] b,
	input 	[10:0] c,
	input   [10:0] d,
	output  [10:0] q);


	wire p [10:0];
	OR3 inter (a, b, c, p);
	assign q = p ^ d;
endmodule

/*
Tristate buffers (11 bit buses)
*/

module TristateBuffer (
	input 	[10:0] a,
	input          s,
	output  [10:0] q);
	assign q = s ? a : 4'bz;
endmodule

/*MUX gates 
Up to MUX4
*/

//MUX2
module MUX2 (
	input	[10:0] d0,
	input 	[10:0] d1,
	input		   s,
	output	[10:0] q);

	TristateBuffer zero_en (d0, ~s, q);
	TristateBuffer one_en (d1, s, q);

endmodule 

//MUX4
module MUX4 (
	input	[10:0] d0,
	input	[10:0] d1,
	input	[10:0] d2,
	input	[10:0] d3,
	input	[1:0]  s,
	output	[10:0] q);

	wire p0, p1;

	MUX2 low_first (d0, d2, s[1], p0);
	MUX2 high_first (d1, d3, s[0], p1);
	MUX2 final (p0, p1, s[0], q);
	
endmodule
