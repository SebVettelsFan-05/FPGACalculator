/* Written for the NANDLAND board with it's default settings
All names are for NANDLAND board
Library will include all things needed for debounce and button, seperate module for both
The goal of this is to take an input (button) and create a toggle 
*/


module button_press 
/* Principal of this module: 
if the current value of the button doesn't align with the previous version,
toggle the state_of_button variable on or off
*/
(
    input       clk,
    input       current_button,
    output      state_of_button
);

reg     final_state = 1'b0;
reg     previous_state = 1'b0;
wire    debounced_button;

debounce Instance1 (current_button,clk,debounced_button);

always @(posedge clk)
    begin
        previous_state <= debounced_button;
        if(debounced_button == 1'b0 && previous_state == 1'b1)
            begin
                final_state <= ~final_state;
            end  
    end
assign state_of_button = final_state;

endmodule 


module debounce
/* Principal of this module:
Add a delay to theoritical button press for debounce purposes
*/
(
    input      button_state,
    input      clk,
    output     debounced_button
);

parameter debounce_time = 250000;
reg previous_state = 1'b0;
reg [17:0] r_count = 0;

always @(posedge clk)
    begin
        if (previous_state !== button_state && r_count < debounce_time)
            begin
                r_count <= r_count + 1;
            end
        else if (r_count == debounce_time)
            begin
                previous_state <= button_state;
                r_count <= 0;
            end
        else
            begin
                r_count <= 0;
            end
    end
assign debounced_button = previous_state;
endmodule

module button_layer_sev_seg
(
    input clk,
    input button_pressed,
    output o_DV_Final
);

wire button_filtered;
button_press Instance (clk, button_pressed, button_filtered);

reg o_DV = 1'b0;
reg last_state = 1'b0;
always @(posedge clk)
    begin
        o_DV = 1'b0;
        last_state <= button_filtered;
        if(last_state !== button_filtered)
            begin
                o_DV = 1'b1;
            end
    end
assign o_DV_Final = o_DV;
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