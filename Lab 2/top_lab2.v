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
    input clk,       // 100 MHz clock input
    input btnC,      // Active-low reset button
    input btnL,      // Moving block button
    input wire [1:0] sw,  // switches for mode select on VGA
    output wire Hsync, // vga horizontal sync
    output wire Vsync, // vga vertical sync
    output wire [6:0] seg,  // Seven-segment display segments
    output wire [3:0] an,    // Seven-segment anodes
    output wire [3:0] vgaRed, // vga red output
    output wire [3:0] vgaBlue, // vga blue  output
    output wire [3:0] vgaGreen // vga green output
);

    wire debounced_btnL;  // Debounced buttonL (Moving Block)
    wire [1:0] debounced_sw; // Debounced switches
    wire [10:0] hCount;
    wire[10:0] vCount;
    wire blank;
    wire clk_25mhz;
    wire reset_n;
    wire locked;

    assign reset_n = locked & ~btnC;  // Ensure reset_n is active-low
    assign reset = ~reset_n;           // Pass active-low reset to all modules
    
    debounce db_btnL(
        .clk_25mhz(clk_25mhz),
        .reset_n(reset_n),
        .button_in(btnL),
        .button_out(debounced_btnL)
    );
    
    debounce db_sw0(
        .clk_25mhz(clk_25mhz),
        .reset_n(reset_n),
        .button_in(sw[0]),
        .button_out(debounced_sw[0])
    );
    
    debounce db_sw1(
        .clk_25mhz(clk_25mhz),
        .reset_n(reset_n),
        .button_in(sw[1]),
        .button_out(debounced_sw[1])
    );
    
    clk_wiz_0 clk_wiz_0i(
        .clk_25mhz(clk_25mhz),
        .reset(reset),
        .locked(locked),
        .clk_in1(clk)
    );
    VGA_Disp VGAdisplay(
    .vgaRed(vgaRed),
    .vgaBlue(vgaBlue),
    .vgaGreen(vgaGreen),
    .clk_25mhz(clk_25mhz),
    .buttonL(debounced_btnL),
    .hCount(hCount),
    .vCount(vCount),
    .reset(reset),
    .blank(blank),
    .sw(debounced_sw)
    
    );
    
    vga_controller_640_60 vgaController(
    .rst(reset),
    .pixel_clk(clk_25mhz),
    .HS(Hsync),
    .VS(Vsync),
    .hcount(hCount),
    .vcount(vCount),
    .blank(blank)
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

