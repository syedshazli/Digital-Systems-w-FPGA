`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/09/2025 05:56:40 PM
// Design Name: top_lab2
// Module Name: debounce
// Project Name: lab2_ece_3829
// Target Devices: Basys3 FPGA
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
