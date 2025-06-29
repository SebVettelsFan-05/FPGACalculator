module button_to_7_test
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

wire [3:0] out_but_1;
wire flag_ver_1;
button_layer_sev_seg button_1 (i_Clk, i_Switch_1, 4'b0001, flag_ver_1);

wire [3:0] out_but_2;
wire flag_ver_2;
button_layer_sev_seg button_2 (i_Clk, i_Switch_2, 4'b0001, flag_ver_2);

wire [3:0] out_but_3;
wire flag_ver_3;
button_layer_sev_seg button_3 (i_Clk, i_Switch_3, 4'b0001, flag_ver_3);

wire [3:0] add_operation;
wire flag_add_op;
button_layer_sev_seg add_button (i_Clk, i_Switch_4, 4'b0001, flag_add_op);

parameter start =                3'b000;
parameter first_num_first_dig =  3'b001;
parameter first_num_sec_dig =    3'b010;
parameter operation =            3'b011;
parameter sec_num_first_dig =    3'b100;
parameter sec_num_sec_dig =      3'b101;
parameter execute =              3'b110;
parameter reset =                3'b111;

reg [2:0] current_case = start;
reg [18:0] input_buffer = 18'h00000;
wire [18:0] inputs;

always @(posedge i_Clk)
    begin
        case(current_case)
            start
                begin
                    if(flag_ver_1)
                        begin
                            input_buffer[14:11] <= 4'b0001
                            current_case <= first_num_first_dig;
                        end
                    else if(flag_ver_2)
                        begin 
                            input_buffer[14:11] <= 4'b0010
                            current_case <= first_num_first_dig;
                        end
                    else if(flag_add_op)
                        begin
                            input_buffer[10:8] <= 3'b001;
                            current_case <= operation;
                        end 
                end
            first_num_first_dig
                begin
                    if(flag_ver_1)
                        begin
                            input_buffer[18:15] <= 4'b0001
                            current_case <= first_num_sec_dig;
                        end
                    else if(flag_ver_2)
                        begin 
                            input_buffer[18:15] <= 4'b0001
                            current_case <= first_num_sec_dig;
                        end

                    else if(flag_add_op)
                        begin
                            input_buffer[10:8] <= 3'b001;
                            current_case <= operation;
                        end
                end
            first_num_sec_dig
                begin

                end

        endcase


    end

assign inputs = input_buffer;

endmodule