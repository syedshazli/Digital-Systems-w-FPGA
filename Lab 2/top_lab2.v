`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WPI
// Engineer: Syed Shazli
// 
// Create Date: 01/30/2025 02:36:30 PM
// Design Name: top_lab2 top file
// Module Name: top_lab2
// Project Name: Lab2_ECE_3829
// Target Devices:  FPGA
// Description: This is the top level module for lab 2 for the FPGA lab
// 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module top_lab2(
    input clk,         // 100 MHz clock input
    input btnC,        // Active-low reset button
    input btnL,        // Moving block button (debounced)
    input [1:0] sw,    // Switches (debounced)
    output wire Hsync, // VGA horizontal sync
    output wire Vsync, // VGA vertical sync
    output wire [6:0] seg,  // Seven-segment display segments
    output wire [3:0] an,    // Seven-segment anodes
    output wire [3:0] vgaRed, // VGA red output
    output wire [3:0] vgaBlue, // VGA blue output
    output wire [3:0] vgaGreen // VGA green output
);

    // Internal signals
    wire clk_25mhz;
    wire reset_n;      // Active-low reset
    wire locked;       // MMCM lock output
    wire vga_reset;    // Active-high reset for VGA controller
    wire blank;        // Blank signal from VGA controller
    
    // VGA counter signals
    wire [10:0] hCount;
    wire [10:0] vCount;
    
    // Debounced inputs
    wire debounced_btnL;
    wire [1:0] debounced_sw;
    
    // Reset signal assignments
    assign reset_n = locked;    // Active-low reset for all modules
    assign vga_reset = !locked; // Active-high reset for VGA controller

    // Instantiate the Clock Module
    clk_wiz_0 clk_wiz_0i(
        .clk_25mhz(clk_25mhz),
        .reset(btnC),     // MMCM reset is active-high
        .locked(locked),
        .clk_in1(clk)
    );

    // Debouncer for btnL
    debouncer btnL_debouncer(
        .clk_25mhz(clk_25mhz),
        .reset_n(reset_n),
        .input_signal(btnL),
        .debounced_signal(debounced_btnL)
    );

    // Debouncer for sw[0]
    debouncer sw0_debouncer(
        .clk_25mhz(clk_25mhz),
        .reset_n(reset_n),
        .input_signal(sw[0]),
        .debounced_signal(debounced_sw[0])
    );

    // Debouncer for sw[1]
    debouncer sw1_debouncer(
        .clk_25mhz(clk_25mhz),
        .reset_n(reset_n),
        .input_signal(sw[1]),
        .debounced_signal(debounced_sw[1])
    );

    // Instantiate the VGA Display Module
    VGA_Disp VGAdisplay(
        .vgaRed(vgaRed),
        .vgaBlue(vgaBlue),
        .vgaGreen(vgaGreen),
        .clk_25mhz(clk_25mhz),
        .buttonL(debounced_btnL),
        .hCount(hCount),
        .vCount(vCount),
        .reset_n(reset_n),
        .blank(blank),
        .sw(debounced_sw)
    );

    // Instantiate the VGA Controller
    vga_controller_640_60 vgaController(
        .rst(vga_reset),
        .pixel_clk(clk_25mhz),
        .HS(Hsync),
        .VS(Vsync),
        .hcount(hCount),
        .vcount(vCount),
        .blank(blank)
    );

    // Seven Segment Display
    seven_seg sevseg(
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
