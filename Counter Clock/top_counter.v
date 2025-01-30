`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2025 07:06:49 PM
// Design Name: 
// Module Name: top_counter
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


module top_counter(
    input clk,     /* 100 MHz input clock */
    input btnC,    /* reset signal */
    output [15:0] led /* LED outputs */
);

/* top level signal declarations */
wire clk_10Mhz; /* 10 MHz clock signal */
wire reset_n;   /* locked output to be used as reset for the reset of the logic */

/* clock module converting 100 MHz input clock to 10 MHz output clock */
clk_mmcm_wiz clk_mmcm_wiz1
(
    // Clock out ports
    .clk_10Mhz(clk_10Mhz),  // output clk_10Mhz
    
    // Status and control signals
    .reset(btnC),           // input reset
    .locked(reset_n),       // output locked
    
    // Clock in ports
    .clk_in1(clk)           // input clk_in1
);

/* module updates led value at 1 Hz interval, rotates LED to left */
led_counter led_counter1
(
    .clk(clk_10Mhz),    // 10 MHz clock input
    .reset_n(reset_n),  // active low reset
    .led_out(led[15:0]) // LED output value
);

endmodule

