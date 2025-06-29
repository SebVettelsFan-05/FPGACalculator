/*
The goals of this file:
- Binary to seven segment display 
*/

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
            4'b1111 : sev_seg_inter <= 7'h47;
        endcase

    end
assign seven_seg_out = ~sev_seg_inter;

endmodule
