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
    output reg  state_of_button
);

reg     previous_state = 1'b0;
wire    debounced_state;

debounce Instance
(.clk(clk),
.button_state(current_button),
.debounced_button(debounced_state));


always @(posedge clk)
    begin
        previous_button <= debounced_button;
        if(previous_button = 1'b1 && debounced_button = 1'b1)
            begin
                state_of_button <= !state_of_button;
            end
    end

endmodule 


module debounce
/* Principal of this module:
Add a delay to theoritical button press for debounce purposes
*/
(
    input      button_state;
    input      clk;
    output reg debounced_button;
)

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
                debounced_button = button_state;
                r_count = 0;
            end
        else
            r_count = 0;
    end
endmodule