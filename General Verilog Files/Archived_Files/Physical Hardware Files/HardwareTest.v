module ButtonTest

(
    input   i_Clk,
    input   i_Switch_1,
    output  o_LED_1

);

wire output_stable;
reg wire_clicked_1 = 1'b0;

button_press Test_Instance(i_Clk, i_Switch_1, output_stable);


endmodule 


/*module SevenSegDisplay
(
    input  i_Clk,
    output reg o_Segment1_A, 
    output reg o_Segment1_B,
    output reg o_Segment1_C, 
    output reg o_Segment1_D, 
    output reg o_Segment1_E, 
    output reg o_Segment1_F, 
    output reg o_Segment1_G 
);

wire [7:0] seven_seg_num;

binary_to_7segment Instance (i_Clk, 4'b0000, seven_seg_num);
always @(*)
    begin
        o_Segment1_A = seven_seg_num[6];
        o_Segment1_B = seven_seg_num[5];
        o_Segment1_C = seven_seg_num[4];
        o_Segment1_D = seven_seg_num[3];
        o_Segment1_E = seven_seg_num[2];
        o_Segment1_F = seven_seg_num[1];
        o_Segment1_G = seven_seg_num[0];
    end

endmodule*/