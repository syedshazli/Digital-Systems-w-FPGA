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
    wire reset_n; // Active-low reset
    wire locked;  // MMCM lock output
    wire vga_reset; // Active-high reset for VGA controller
    
    // instantiate hCount and vCount
    wire [10:0] hCount;
    wire [10:0] vCount;
    
    // Debounced inputs
    reg debounced_btnL = 0;
    reg [1:0] debounced_sw = 0;
    
    // Debounce counters
    reg [17:0] btnL_counter = 0;
    reg [17:0] sw0_counter = 0;
    reg [17:0] sw1_counter = 0;

    parameter DEBOUNCE_TIME = 250000; // ~10ms debounce delay

    //  Set up reset signals
    assign reset_n = locked; // Active-low reset for all modules
    assign vga_reset = btnC; // Invert for VGA controller (active-high)

    //  Debounce for btnL
    always @(posedge clk_25mhz or negedge reset_n) begin
        if (!reset_n) begin
            btnL_counter <= 0;
            debounced_btnL <= 0;
        end 
        else if (btnL != debounced_btnL) begin
            btnL_counter <= 0; // Reset debounce counter
        end 
        else if (btnL_counter >= DEBOUNCE_TIME) begin
            debounced_btnL <= btnL;
            btnL_counter <= 0;
        end 
        else begin
            btnL_counter <= btnL_counter + 1;
        end
    end

    //   Debounce for sw[0]
    always @(posedge clk_25mhz or negedge reset_n) begin
        if (!reset_n) begin
            sw0_counter <= 0;
            debounced_sw[0] <= 0;
        end 
        else if (sw[0] != debounced_sw[0]) begin
            sw0_counter <= 0;
        end 
        else if (sw0_counter >= DEBOUNCE_TIME) begin
            debounced_sw[0] <= sw[0];
            sw0_counter <= 0;
        end 
        else begin
            sw0_counter <= sw0_counter + 1;
        end
    end

    // Debounce for sw[1]
    always @(posedge clk_25mhz or negedge reset_n) begin
        if (!reset_n) begin // active low
            sw1_counter <= 0;
            debounced_sw[1] <= 0;
        end 
        else if (sw[1] != debounced_sw[1]) begin
            sw1_counter <= 0;
        end 
        else if (sw1_counter >= DEBOUNCE_TIME) begin
            debounced_sw[1] <= sw[1];
            sw1_counter <= 0;
        end 
        else begin // increment counter as usual
            sw1_counter <= sw1_counter + 1;
        end
    end

    // Instantiate the Clock Module
    clk_wiz_0 clk_wiz_0i(
        .clk_25mhz(clk_25mhz),
        .reset(btnC), // MMCM reset is active-high
        .locked(locked),
        .clk_in1(clk)
    );

    //  Instantiate the VGA Display Module (Uses reset_n, and debounced button + switches)
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

    // Instantiate the VGA Controller (Uses Inverted Reset)
    vga_controller_640_60 vgaController(
        .rst(vga_reset),  //  VGA controller requires active-high reset
        .pixel_clk(clk_25mhz),
        .HS(Hsync),
        .VS(Vsync),
        .hcount(hCount),
        .vcount(vCount),
        .blank(blank)
    );

    // Seven Segment Display, pass in WPI ID Digits
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
