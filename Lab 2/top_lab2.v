`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WPI
// Engineer: Syed Shazli
// 
// Create Date: 01/30/2025 02:36:30 PM
// Design Name: top_lab2 top file
// Module Name: top_lab2
// Project Name: Lab2_ECE_3829
// Target Devices: Basys3 FPGA
// Description: This is the top level module for lab 2 for the FPGA lab
// 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_lab2(
    input clk,       // 100 MHz clock input
    input btnC,      // Active-low reset button
    output wire [6:0] seg,  // Seven-segment display segments
    output wire [3:0] an    // Seven-segment anodes
);

    wire clk_25mhz;
    wire reset_n;
    wire locked;

    assign reset_n = locked; // Active-low reset
    assign reset = btnC;     // Active-high reset for MMCM

    clk_wiz_0 clk_wiz_0i(
        .clk_25mhz(clk_25mhz),
        .reset(reset),
        .locked(locked),
        .clk_in1(clk)
    );

    seven_seg sevseg(
        // WPI ID digits
        .displayA(4'h2),  
        .displayB(4'h7),
        .displayC(4'h8),
        .displayD(4'h9),
        .reset_n(reset_n),
        .clk_25mhz(clk_25mhz),
        .segment(seg),
        .anode(an)
    );

endmodule

