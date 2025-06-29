module ALU
(
    input   [11:0] a,
    input   [11:0] b,
    input   [2:0] s,
    output  [11:0] y
);

wire [11:0] and_gate;
wire [11:0] or_gate;
wire [11:0] adder_gate;

and_gate = a & b;
or_gate = a ^ b;

integrated_adder instance1 (a,b,s[2],adder_gate);
MUX4 Mux_Selector (adder_gate, and_gate, or_gate, 11'h000, s[1:0], y);

endmodule

module twos_complement
(
    input   [11:0] a,
    output  [11:0] q
);

wire [11:0] not;

not = ~a;
q = 11'h001 + not;

endmodule


module integrated_adder
(
    input [11:0] a,
    input [11:0] b,
    input       s,
    output [11:0] y
);

wire [11:0] negative_val;
wire [11:0] a_mux;

twos_complement for_neg (b, negative_val);
MUX2 mux_select (b, negative_val, s, a_mux);
y = a + a_mux;

endmodule
/*module adder
(
    input   [11:0] a,
    input   [11:0] b,
    output  [11:0] cout
);

wire [11:0] inter;

adder_one_bit Inst1 (a[0], b[0], 1'b0, inter[0]);
adder_one_bit Inst2 (a[1], b[1], inter[0], inter[1]);
adder_one_bit Inst3 (a[2], b[2], inter[1], inter[2]);
adder_one_bit Inst4 (a[3], b[3], inter[2], inter[3]);
adder_one_bit Inst5 (a[4], b[4], inter[3], inter[4]);
adder_one_bit Inst6 (a[5], b[5], inter[4], inter[5]);
adder_one_bit Inst7 (a[6], b[6], inter[5], inter[6]);
adder_one_bit Inst8 (a[7], b[7], inter[6], inter[7]);
adder_one_bit Inst9 (a[8], b[8], inter[7], inter[8]);
adder_one_bit Inst10 (a[9], b[9], inter[8], inter[9]);
adder_one_bit Inst11 (a[10], b[10], inter[9], inter[10]);
adder_one_bit Inst12 (a[11], b[11], inter[10], inter[11]);

endmodule


module adder_one_bit
(
    input a,
    input b,
    input cin,
    input cout
);

cout = (a && b) || (cin && b) || (a && cin);
y = (~a && ~b && cin) || (~a && b &&  ~cin) || (a && b && cin) || (a && ~b && ~cin);

endmodule */

