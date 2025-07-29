/*
modules for ALU and associated hardware including some standard logic.
*/

module MUX2
(
    input [7:0] a,
    input [7:0] b,
    input s,
    output [7:0] y
);
assign y = s ? a : b;
endmodule

module MUX4
(
    input [7:0] d0,
    input [7:0] d1,
    input [7:0] d2,
    input [7:0] d3,
    input [1:0] s,
    output [7:0] y
);

wire [7:0] y0;
wire [7:0] y1;

MUX2 first_ins(d0, d1, s[0], y0); 
MUX2 second_ins(d2, d3, s[0], y1);
MUX2 select_y(y0,y1,s[1],y);

endmodule

module ALU
(
    input [7:0] num1,
    input [7:0] num2,
    input [2:0] selector,
    output [7:0] y
);

wire [7:0] and_gate;
wire [7:0] or_gate;
wire [7:0] adding; 

wire [7:0] num2_n;

negation NegativeSelect (num2, selector[2], num2_n);

assign and_gate = num1 & num2_n;
assign or_gate = num1 | num2_n;
assign adding = num1 + num2_n;

MUX4 instance1 (and_gate, or_gate, adding, 8'h00, selector[1:0], y);

endmodule

module negation
(
    input [7:0] a,
    input enable,
    output [7:0] y 
);

wire [7:0] negative;
assign negative = (~a) + 1;
assign y = enable ? negative : a;


endmodule 