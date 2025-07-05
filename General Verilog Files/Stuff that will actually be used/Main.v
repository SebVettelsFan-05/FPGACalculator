module Main
(
    input i_Clk,

    input i_Switch_1,
    input i_Switch_2,
    input i_Switch_3,
    input i_Switch_4,

    input io_PMOD_1,
    input io_PMOD_2,
    input io_PMOD_3,
    input io_PMOD_4,
    input io_PMOD_7,
    input io_PMOD_8,
    input io_PMOD_9,
    input io_PMOD_10,

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
    output reg o_Segment2_G,

    output reg o_LED_1,
    output reg o_LED_2,
    output reg o_LED_3,
    output reg o_LED_4
);

wire flag_ver [12:0];
parameter num_of_buttons = 3;

button_layer_sev_seg button_0 (i_Clk, i_Switch_1, flag_ver[0]);
button_layer_sev_seg button_1 (i_Clk, i_Switch_2, flag_ver[1]);
button_layer_sev_seg button_2 (i_Clk, i_Switch_3, flag_ver[2]);


button_layer_sev_seg equals_op (i_Clk, i_Switch_4, equals_flag);

button_layer_sev_seg add_button (i_Clk, io_PMOD_2, flag_add_op);

button_layer_sev_seg reset_button (i_Clk, io_PMOD_1, reset_flag);

parameter start =                3'b000;
parameter first_num_first_dig =  3'b001;
parameter first_num_sec_dig =    3'b010;
parameter operation =            3'b011;
parameter sec_num_first_dig =    3'b100;
parameter sec_num_sec_dig =      3'b101;
parameter execute =              3'b110;
parameter reset =                3'b111;

parameter all_values = 16'b0011_0010_0001_0000;

reg [2:0] current_case = reset;
reg [18:0] input_buffer = 19'h00000;
wire [18:0] inputs;

reg [3:0] lights_reg = 4'h00;
wire [3:0] lights;

reg [7:0] current_seven_seg = 8'hff;
wire [7:0] output_seven_seg;
wire [7:0] seven_segment_1;
wire [7:0] seven_segment_2;

integer numpad;

always @(posedge i_Clk)
    begin
        case(current_case)
            start:
                begin
                    for (numpad = 1; numpad < num_of_buttons; numpad = numpad +1 )
                        begin
                            if(flag_ver[numpad])
                                begin
                                    input_buffer[14:11] <= all_values [(3+4*numpad) -: 4];
                                    current_seven_seg[3:0] <= all_values [(3+4*numpad) -: 4];
                                    current_case <= first_num_first_dig;
                                end
                        end
                    if(flag_add_op)
                        begin
                            input_buffer[10:8] <= 3'b001;
                            current_case <= operation;
                            lights_reg <= 4'b0001;
                        end
                    if(reset_flag)
                        current_case <= reset; 
                end
            first_num_first_dig:
                begin
                    for (numpad = 0; numpad < num_of_buttons; numpad = numpad +1 )
                        begin
                            if(flag_ver[numpad])
                                begin
                                    input_buffer[18:15] <= input_buffer[14:11];
                                    input_buffer[14:11] <= all_values [(3+4*numpad) -: 4];
                                    current_seven_seg[7:4] <= current_seven_seg[3:0];
                                    current_seven_seg[3:0] <= all_values[(3+4*numpad) -: 4];
                                    current_case <= first_num_sec_dig;
                                end
                        end
                    if(flag_add_op)
                        begin
                            input_buffer[10:8] <= 3'b001;
                            current_case <= operation;
                        end
                    if(reset_flag)
                        current_case <= reset; 
                end
            first_num_sec_dig:
                begin
                    if(flag_add_op)
                        begin
                            input_buffer[10:8] <= 3'b001;
                            current_case <= operation;
                            lights_reg <= 4'b0001;
                        end
                    if(reset_flag)
                        current_case <= reset; 
                end

            operation:
                begin
                    current_seven_seg [7:0] <= 8'hff;
                    for (numpad = 1; numpad < num_of_buttons; numpad = numpad +1 )
                        begin
                            if(flag_ver[numpad])
                                begin
                                    input_buffer[3:0] <= all_values [(3+4*numpad) -: 4];
                                    current_seven_seg[3:0] <= all_values [(3+4*numpad) -: 4];
                                    current_case <= sec_num_first_dig;
                                end
                        end
                    if(reset_flag)
                        current_case <= reset;
                end
            sec_num_first_dig:
                begin
                    for (numpad = 0; numpad < num_of_buttons; numpad = numpad +1 )
                        begin
                            if(flag_ver[numpad])
                                begin
                                    input_buffer[7:4] <= input_buffer[3:0];
                                    input_buffer[3:0] <= all_values [(3+4*numpad) -: 4];
                                    current_seven_seg[7:4] <= current_seven_seg[3:0];
                                    current_seven_seg[3:0] <= all_values[(3+4*numpad) -: 4];
                                    current_case <= sec_num_sec_dig;
                                end
                        end
                    if(equals_flag)
                        begin
                            current_case <= execute;
                        end
                    if(reset_flag)
                        current_case <= reset;

                end
            sec_num_sec_dig:
                begin
                if (equals_flag) 
                    begin
                        current_case <= execute;
                    end
                 if(reset_flag)
                        current_case <= reset;
                end
            execute:
                begin
                    current_seven_seg[7:0] <= 8'h89;
                    if(reset_flag)
                        current_case <= reset;
                       
                end
            reset:
                begin
                    input_buffer [18:0] <= 19'h00000;
                    current_seven_seg[7:0] <= 8'hff;
                    current_case <= start;
                    lights_reg <= 4'b0000;
                end
        endcase


    end

assign output_seven_seg = current_seven_seg;
assign lights = lights_reg;

binary_to_7segment second_screen (i_Clk, current_seven_seg[3:0] ,seven_segment_2);
binary_to_7segment first_screen (i_Clk, current_seven_seg[7:4] ,seven_segment_1);

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

        o_LED_1 = lights[0];
        o_LED_2 = lights[1];
        o_LED_3 = lights[2];
        o_LED_4 = lights[3];
    end


endmodule 