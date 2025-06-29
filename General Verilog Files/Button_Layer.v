module button_layer_sev_seg
(
    input clk,
    input button_pressed,
    input [3:0] numerical_representation,

    output [3:0] o_num_rep,
    output o_DV_Final
);

wire button_filtered;
button_press Instance (clk, button_pressed, button_filtered);

reg o_DV = 1'b0;
reg last_state = 1'b0;
reg [3:0] output_state = 4'b0000;
always @(posedge clk)
    begin
        o_DV = 1'b0;
        last_state <= button_filtered;
        if(last_state !== button_filtered)
            begin
                output_state <= numerical_representation;
                o_DV = 1'b1;
            end
    end
assign o_num_rep = output_state;
assign o_DV_Final = o_DV;
endmodule

/*module test
(
    input i_Clk,

    input i_Switch_1,
    input i_Switch_2,
    input i_Switch_3,
    input i_Switch_4,

    output reg o_Segment1_A,
    output reg o_Segment1_B,
    output reg o_Segment1_C,
    output reg o_Segment1_D,
    output reg o_Segment1_E,
    output reg o_Segment1_F,
    output reg o_Segment1_G
);

wire [3:0] output_1;
wire o_DV1;

wire [3:0] output_2;
wire o_DV2;

reg [3:0] display_to_seven = 4'b0000; 
wire [3:0] display_to_seven_value;

wire [7:0] seven_seg_first;

button_layer_sev_seg first (i_Clk, i_Switch_1, 4'b0001, output_1, o_DV1);
button_layer_sev_seg second (i_Clk, i_Switch_2, 4'b0010, output_2, o_DV2);
always @(posedge i_Clk)
    begin
        if (o_DV1)
            begin
                display_to_seven <= 4'b0001;
            end
        else if (o_DV2) 
            begin
                display_to_seven <= 4'b0010;
            end
    end 
assign display_to_seven_value = display_to_seven;

binary_to_7segment seven_seg_stuff (i_Clk, display_to_seven_value, seven_seg_first);

always @(*)
    begin
        o_Segment1_A = seven_seg_first[6];
        o_Segment1_B = seven_seg_first[5];
        o_Segment1_C = seven_seg_first[4];
        o_Segment1_D = seven_seg_first[3];
        o_Segment1_E = seven_seg_first[2];
        o_Segment1_F = seven_seg_first[1];
        o_Segment1_G = seven_seg_first[0];
    end 




endmodule*/