`timescale 1ns / 1ps

// Company: 
// Engineer: 
// 
// Create Date: 02/10/2025 02:48:26 PM
// Design Name: 
// Module Name: debouncer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// File: debouncer.v
module debouncer(
    input wire clk_25mhz,
    input wire reset_n,
    input wire input_signal,
    output reg debounced_signal
);

    reg [17:0] counter;
    parameter DEBOUNCE_TIME = 250000; // ~10ms at 25MHz

    always @(posedge clk_25mhz or negedge reset_n) begin
        if (!reset_n) begin
            counter <= 0;
            debounced_signal <= 0;
        end
        else begin
            if (input_signal != debounced_signal) begin
                if (counter == DEBOUNCE_TIME) begin
                    debounced_signal <= input_signal;
                    counter <= 0;
                end
                else begin
                    counter <= counter + 1;
                end
            end
            else begin
                counter <= 0;
            end
        end
    end

endmodule


// Description: This module serves to implement the debouncing logic for the switches and buttons
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module debounce(
    input wire clk_25mhz, // input clock
    input wire reset_n,   // reset signal
    input wire button_in,   // 1 bit input
    output reg button_out   // 1 bit output
    );
    
    parameter DEBOUNCE_TIME = 250000; // debouncing time
    
    reg [17:0] counter; // keeps track of counter value
    reg stable_button = 0; // hold state of button input
    
    always @ (posedge clk_25mhz or negedge reset_n)
    begin
        if(!reset_n) // active low reset
        begin
            //  the count value should be zero and the output should be assigned to the input by
            //  passing the debounce logic
            counter <= 0;
            stable_button <= button_in;
            button_out <= button_in;
        end
        
        else if(button_in != stable_button)
        begin
            counter <= 0;
        end
        
        else if(counter >= DEBOUNCE_TIME)
        begin
            button_out <= button_in;
            stable_button <= button_in;
            counter <= 0;
             
        end
        
        else
        begin
            counter <= counter + 1;
        end
    end
    
    
endmodule
