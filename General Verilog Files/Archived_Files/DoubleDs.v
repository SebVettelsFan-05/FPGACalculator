module double_dabble
(
    input clk,
    input [7:0] i_Binary,
    input start,

    output [7:0] BCD_rep,
    output o_DV
);

parameter s_start = 3'b000;
parameter shift = 3'b001;
parameter check = 3'b010;
parameter add_3 = 3'b011;
parameter finished = 3'b100;

reg [2:0] case_machine = 3'b000;
reg r_o_DV = 0;

reg [19:0] buffer_size = 20'h00000;
reg [3:0] shift_count = 4'd0;

reg flag_upper = 0;
reg flag_lower = 0;

always @(posedge clk)
    begin
        case (case_machine)
            s_start:
                begin
                    r_o_DV <= 0;
                    buffer_size <= 20'h00000;
                    shift_count <= 4'd0;
                    flag_upper <= 0;
                    flag_lower <= 0;
                    if(start)
                        begin
                            buffer_size[7:0] <= i_Binary[7:0];
                            case_machine <= shift;
                        end
                end
            check:
                begin
                    flag_upper <= (buffer_size[15:12] >= 5);
                    flag_lower <= (buffer_size[11:8] >= 5);
                    case_machine <= add_3;
                end
            add_3:
                begin
                    if(flag_upper)
                        buffer_size[15:12] <= buffer_size[15:12] + 3;
                    if(flag_lower)
                        buffer_size[11:8] <= buffer_size[11:8] + 3;
                    case_machine <= shift;
                end
            shift:
                begin
                    buffer_size <= buffer_size << 1;
                    shift_count <= shift_count + 1;
                    if(shift_count == 7)
                        case_machine <= finished;
                    else
                        case_machine <= check;
                end
            finished: 
                begin
                    r_o_DV <= 1;
                    case_machine <= s_start;
                end
        endcase 

    end

assign BCD_rep = buffer_size[15:8];
assign o_DV = r_o_DV;
endmodule 

module binary_to_7segment (
    input clk,
    input [3:0] binary_num,
    output [6:0] seven_seg_out
);
reg [6:0] sev_seg_inter = 7'h00;

always @(posedge clk)
    begin
        case(binary_num)
            4'b0000 : sev_seg_inter <= 7'h7E;
            4'b0001 : sev_seg_inter <= 7'h30;
            4'b0010 : sev_seg_inter <= 7'h6D;
            4'b0011 : sev_seg_inter <= 7'h79;
            4'b0100 : sev_seg_inter <= 7'h33;
            4'b0101 : sev_seg_inter <= 7'h5B;
            4'b0110 : sev_seg_inter <= 7'h5F;
            4'b0111 : sev_seg_inter <= 7'h70;
            4'b1000 : sev_seg_inter <= 7'h7F;
            4'b1001 : sev_seg_inter <= 7'h7B;
            4'b1010 : sev_seg_inter <= 7'h77;
            4'b1011 : sev_seg_inter <= 7'h1F;
            4'b1100 : sev_seg_inter <= 7'h4E;
            4'b1101 : sev_seg_inter <= 7'h3D;
            4'b1110 : sev_seg_inter <= 7'h4F;
            4'b1111 : sev_seg_inter <= 7'h00;
        endcase

    end
assign seven_seg_out = ~sev_seg_inter;

endmodule

module Main
(
    input i_Clk,

    output reg o_Segment1_A,
    output reg o_Segment1_B,
    output reg o_Segment1_C,
    output reg o_Segment1_D,
    output reg o_Segment1_E,
    output reg o_Segment1_F,
    output reg o_Segment1_G,

    output reg o_Segment2_A,
    output reg o_Segment2_B,
    output reg o_Segment2_C,
    output reg o_Segment2_D,
    output reg o_Segment2_E,
    output reg o_Segment2_F,
    output reg o_Segment2_G
);

wire [7:0] result;
wire dv;

wire [7:0]final_res;
reg [7:0] inter;


wire [6:0] seven_segment_1;
wire [6:0] seven_segment_2;

double_dabble testing (i_Clk, 8'b11111111, 1, result, dv);

always @(posedge i_Clk)
    begin
        if(dv)
            inter <= result;
    end
assign final_res = inter;

binary_to_7segment second_screen (i_Clk, final_res[3:0] ,seven_segment_2);
binary_to_7segment first_screen (i_Clk, final_res[7:4] ,seven_segment_1);

always @(*)
    begin
        o_Segment1_A = seven_segment_1[6];
        o_Segment1_B = seven_segment_1[5];
        o_Segment1_C = seven_segment_1[4];
        o_Segment1_D = seven_segment_1[3];
        o_Segment1_E = seven_segment_1[2];
        o_Segment1_F = seven_segment_1[1];
        o_Segment1_G = seven_segment_1[0];

        o_Segment2_A = seven_segment_2[6];
        o_Segment2_B = seven_segment_2[5];
        o_Segment2_C = seven_segment_2[4];
        o_Segment2_D = seven_segment_2[3];
        o_Segment2_E = seven_segment_2[2];
        o_Segment2_F = seven_segment_2[1];
        o_Segment2_G = seven_segment_2[0];
    end

endmodule