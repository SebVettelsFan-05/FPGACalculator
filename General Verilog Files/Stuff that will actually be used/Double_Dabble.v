//This is only for 8-bits
//Uses state machines 


module bcd_to_bin_conversion
(
    input clk,
    input [7:0] input_number,
    input enable,
    

    output [7:0] output_num,
    output out_dataV
);

reg [3:0] cases = 3'h0; 
reg r_out_dataV = 0;

reg [7:0] seperation = 8'h00;
reg [7:0] bottom_half = 8'h00;
reg [7:0] final_result = 8'h00;

parameter start = 3'b000;
parameter shift =  3'b001;
parameter add = 3'b010;
parameter finish = 3'b011;

always @(posedge clk)
    begin
        case (cases)
            start:
                begin
                seperation [7:0] <= 8'h00;
                bottom_half [7:0] <= 8'h00;
                final_result [7:0] <= 8'h00;
                r_out_dataV <= 0;
                if(enable)
                    begin
                        seperation[3:0] <= input_number[7:4];
                        bottom_half[3:0] <= input_number[3:0];
                        cases <= shift;
                    end
                end
            shift:
            begin
                seperation <= (seperation << 3) + (seperation << 1);
                cases <= add;
            end
            add:
            begin
                final_result <= seperation + bottom_half; 
                cases <= finish;
            end
            finish:
            begin
                r_out_dataV <= 1;
                cases <= start;
            end

        endcase 
    end
assign output_num = final_result;
assign out_dataV = r_out_dataV;

endmodule 

module double_dabble
(
    input [7:0] i_Binary,
    input clk,
    input start,

    output [7:0] BCD_rep,
    output o_DV
);

parameter start = 3'b000;
parameter shift = 3'b001;
parameter check = 3'b010;
parameter add_3 = 3'b011;
parameter finished = 3'b100;

reg [2:0] case_machine = 3'b000;
reg r_o_DV = 0;

reg [19:0] buffer_size = 20'h00000;
reg [3:0] shift_count = 4'd0;

reg [3:0] upper_buf = 4'b0000;
reg [3:0] lower_buf = 4'b0000;

reg flag_upper = 0;
reg flag_lower = 0;

always @(posedge clk)
    begin
        case (case_machine)
            start:
                begin
                    buffer_size <= 0'h00000;
                    r_o_DV <= 0;
                    upper_buf <= 4'd0;
                    lower_buf <= 4'd0;
                    shift_count <= 4'd0;
                    flag_upper <= 0;
                    flag_lower <= 0;
                    if(start)
                        begin
                            buffer_size[7:0] <= i_Binary[7:0];
                            case_machine <= shift;
                        end
                end
            shift:
                begin
                    shift_count <= shift_count + 1;
                    buffer_size <= buffer_size << 1;
                    case_machine <= check;

                end
            check:
                begin
                    if(shift_count == 8)
                        case_machine <= finished;
                    else
                        if()

                end
            add_3:
                begin
                end
            finished: 
                begin
                end
        endcase 

    end

assign BCD_rep = buffer_size[13:8];



endmodule */

