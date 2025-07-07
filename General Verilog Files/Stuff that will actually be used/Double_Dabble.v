//This is only for 8-bits
//Uses state machine


module bcd_to_bin_conversion
( //Do I even need this?
    input clk,
    input [7:0] input_number,
    input enable,
    

    output [11:0] output_num,
    output out_dataV
);

reg [3:0] cases = 3'h0; 
reg r_out_dataV = 0;

reg [11:0] seperation = 12'h000;
reg [11:0] bottom_half = 12'h000;
reg [11:0] final_result = 12'h000;

parameter start = 3'b000;
parameter shift =  3'b001;
parameter add = 3'b010;
parameter finish = 3'b011;

always @(posedge clk)
    begin
        case (cases)
            start:
                begin
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
                seperation <= ((seperation << 3) + (seperation << 1));
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

/*module double_dabble
(
    input [7:0] i_Binary,
    input clk,

    output [7:0] BCD_rep,
    output o_DV
);





endmodule */

