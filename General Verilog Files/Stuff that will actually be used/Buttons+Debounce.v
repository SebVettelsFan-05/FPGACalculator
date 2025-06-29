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