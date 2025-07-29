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

//set number of output ready flags and how many number buttons system have
wire flag_ver [10:0];
parameter num_of_buttons = 3;
wire flag_ops [3:0];
parameter num_of_operations = 2;

//button initiation
button_layer_sev_seg button_0 (i_Clk, io_PMOD_1, flag_ver[0]);
button_layer_sev_seg button_1 (i_Clk, io_PMOD_2, flag_ver[1]);
button_layer_sev_seg button_2 (i_Clk, io_PMOD_3, flag_ver[2]);
//button_layer_sev_seg button_3 (i_Clk, io_PMOD_3, flag_ver[3]);

//equals button
button_layer_sev_seg equals_op (i_Clk, i_Switch_4, equals_flag);

//operation button init
button_layer_sev_seg add_button (i_Clk, i_Switch_2, flag_ops[0]);
button_layer_sev_seg sub_button (i_Clk, i_Switch_1, flag_ops[1]);

//reset button init
button_layer_sev_seg reset_button (i_Clk, i_Switch_3, reset_flag);

//parameters for state machine
parameter start =                3'b000;
parameter first_num_first_dig =  3'b001;
parameter first_num_sec_dig =    3'b010;
parameter operation =            3'b011;
parameter sec_num_first_dig =    3'b100;
parameter sec_num_sec_dig =      3'b101;
parameter execute =              3'b110;
parameter reset =                3'b111;

//lots of numbers
parameter all_values = 40'h9876543210;
reg [2:0] current_case = reset;

//list of operation codes
parameter operation_values = 6'b101_001;

//reg, wire pair for inputs
reg [18:0] input_buffer = 19'h00000;
wire [18:0] inputs;

//stuff for lights
reg [3:0] lights_reg = 4'h00;
wire [3:0] lights;

//stuff for display
reg [7:0] current_seven_seg = 8'hff;
wire [7:0] output_seven_seg;
wire [7:0] seven_segment_1;
wire [7:0] seven_segment_2;

//seperation of numbers for processing
wire [7:0] num_prior_one;
wire [7:0] num_prior_two;
reg r_en_bbc1 = 0;
wire en_bbc_1;
reg r_en_bbc2 = 0;
wire en_bbc_2;
wire o_dvbbc_r1;
wire o_dvbbc_r2;

//Final results to add
reg [7:0] result_first  = 8'h00;
reg [7:0] result_second  = 8'h00;

wire [7:0] w_result_f;
wire [7:0] w_result_s;

//init bcd_to_binary
bcd_to_bin_conversion first_num(i_Clk, inputs[18:11], en_bbc_1, num_prior_one, o_dvbbc_r1);
bcd_to_bin_conversion second_num(i_Clk, inputs [7:0], en_bbc_2, num_prior_two, o_dvbbc_r2);

//testing double dabble
wire[7:0] output_dd;
reg r_en_dd = 0;
wire en_dd;
wire o_dvdd;
double_dabble test(i_Clk, ALU_Out, en_dd, output_dd, o_dvdd);

//for the for loops
integer numpad;
integer numpad_ops;

//ALU Instance for Integration
wire [7:0] ALU_Out;
ALU compute(w_result_f, w_result_s, operation_code, ALU_Out);

//wire, reg pair
wire [2:0] operation_code;
reg [2:0] r_operation_code = 3'b000;

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
                    for(numpad_ops = 0; numpad_ops < num_of_operations; numpad_ops = numpad_ops + 1)
                        begin
                            if(flag_ops[numpad_ops])
                                begin
                                    input_buffer[10:8] <= operation_values[(2+3*numpad_ops) -: 3];
                                    lights_reg [numpad_ops] <= 1;
                                    current_case <= operation;
                                end
                        
                        end

                    if(reset_flag)
                        current_case <= reset; 
                end
            first_num_sec_dig:
                begin
                    for(numpad_ops = 0; numpad_ops < num_of_operations; numpad_ops = numpad_ops + 1)
                        begin
                            if(flag_ops[numpad_ops])
                                begin
                                    input_buffer[10:8] <= operation_values[(2+3*numpad_ops) -: 3];
                                    lights_reg [numpad_ops] <= 1;
                                    current_case <= operation;
                                end
                        
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
                    //conversion to binary
                    r_en_bbc1 <= 1;
                    r_en_bbc2 <= 1;
                    r_operation_code <= input_buffer[10:8];
                    if(o_dvbbc_r1)
                        result_first[7:0] <= num_prior_one[7:0];
                    if(o_dvbbc_r2)
                        result_second[7:0] <= num_prior_two[7:0];
                    if(o_dvbbc_r1 && o_dvbbc_r2)
                        r_en_dd <= 1;
                    if(o_dvdd)
                        current_seven_seg[7:0] <= output_dd;
                    if(reset_flag)
                        current_case <= reset;    
                end
            reset:
                begin
                    input_buffer [18:0] <= 19'h00000;
                    current_seven_seg[7:0] <= 8'hff;
                    current_case <= start;
                    lights_reg <= 4'b0000;
                    r_en_bbc1 <= 0;
                    r_en_bbc2 <=0;
                    result_first <= 12'h000;
                    result_second <= 12'h000;
                    r_en_dd <= 0;
                end
        endcase
    end

assign output_seven_seg = current_seven_seg;
assign lights = lights_reg;
assign inputs = input_buffer;
assign en_bbc_1 = r_en_bbc1;
assign en_bbc_2 = r_en_bbc2;

assign w_result_f = result_first;
assign w_result_s = result_second;
assign en_dd = r_en_dd;
assign operation_code = r_operation_code;

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