`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2025 06:26:47 PM
// Design Name: 
// Module Name: led_counter
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


module led_counter(
    input clk, // 10 mhz clock input
    input reset_n, // active low reset
    output reg [15:0] led_out // LED output
    );
    
    //parameter statements
    parameter C_MAX_COUNT = 10_000_000 -1; //max count on counter for 1 Hz
    
    // wire and reg declarations
    wire update_ena; // when high allows LED value to update 
    reg [23:0] count_value; // holds current count value
    
    //enables LED value to update
    assign update_ena = (count_value == C_MAX_COUNT);
    
    //counter with a 1 Hz count cycle
    always @(posedge clk)
    begin
        if (reset_n == 1'b0)
        begin
            count_value <= 24'd0;
        end 
        else if (count_value == C_MAX_COUNT)
        begin
            count_value <= 24'd0;
        end
        else
        begin
            count_value <= count_value + 24'd1;
        end
    end // awlays @ (posedge clock)
    
    // LED output logic, rotate LED value left each time
    always @(posedge clk)
    begin
        if (reset_n == 1'b0)
        begin
            led_out[15:0] <= 16'd1;
        end
        
        else if(update_ena == 1'b1)
        begin
            led_out[15:0] <= {led_out[14:0], led_out[15]};
        end
    end
    
    
endmodule

