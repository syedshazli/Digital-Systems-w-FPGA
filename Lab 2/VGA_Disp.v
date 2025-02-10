`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WPI
// Engineer: Syed Shazli
// 
// Create Date: 02/04/2025 11:27:40 PM
// Design Name: top_lab2
// Module Name: VGA_Disp
// Project Name: Lab2_ECE_3829
// Target Devices: FPGA
// Description: This module handles VGA display selection and moving block functionality.
// 
// Dependencies: vga_controller_640_60.vhd
// 
// Revision 0.02 - Fixed move mode priority and switch functionality
//////////////////////////////////////////////////////////////////////////////////

module VGA_Disp(
    input [1:0] sw,         // Switches for color display selection
    input clk_25mhz,        // 25 MHz clock input
    input wire reset_n,     // Active-low reset signal
    input wire buttonL,     // Button for moving block mode
    input wire [10:0] hCount, // Horizontal pixel count from VGA controller
    input wire [10:0] vCount, // Vertical pixel count from VGA controller
    input wire blank,       // Blank signal from VGA controller
    output reg [3:0] vgaRed,    // VGA red color output
    output reg [3:0] vgaGreen,  // VGA green color output
    output reg [3:0] vgaBlue    // VGA blue color output
);

    // Define 12-bit color parameters (4 bits per channel)
    parameter COLOR_YELLOW = 12'b1111_1111_0000; // Yellow 
    parameter COLOR_WHITE  = 12'b1111_1111_1111; // White 
    parameter COLOR_RED    = 12'b1111_0000_0000; // Red 
    parameter COLOR_GREEN  = 12'b0000_1111_0000; // Green 
    parameter COLOR_BLUE   = 12'b0000_0000_1111; // Blue 
    parameter COLOR_BLACK  = 12'b0000_0000_0000; // Black 

    // 2 Hz clock rate parameters
    parameter MODIFIED_CLK_RATE = 12500000;

    // Registers for block movement
    reg [9:0] block_y_pos;
    reg [23:0] clock_counter;
    reg moving_block_mode;
    wire active_display;

    // Center the moving block horizontally
    parameter BLOCK_X_POS = 304; // Centered position (640/2 - 16)

    // Determine if we're in the active display area
    assign active_display = !blank;

    // Moving Block Logic
    always @(posedge clk_25mhz or negedge reset_n) begin
        if (!reset_n) begin
            block_y_pos <= 0;
            clock_counter <= 0;
            moving_block_mode <= 0;
        end
        else begin
            if (buttonL) begin
                moving_block_mode <= 1;
                clock_counter <= clock_counter + 1;
                
                if (clock_counter >= MODIFIED_CLK_RATE) begin
                    if (block_y_pos >= 448) // Reset position at bottom
                        block_y_pos <= 0;
                    else
                        block_y_pos <= block_y_pos + 32;
                    clock_counter <= 0;
                end
            end
            else begin
                moving_block_mode <= 0;
            end
        end
    end

    // Display Logic
    always @(*) begin
        if (!active_display) begin
            vgaRed = 4'b0000;
            vgaGreen = 4'b0000;
            vgaBlue = 4'b0000;
        end
        else begin
            if (moving_block_mode) begin
                // Moving block display logic
                if (hCount >= BLOCK_X_POS && hCount < (BLOCK_X_POS + 32) &&
                    vCount >= block_y_pos && vCount < (block_y_pos + 32)) begin
                    vgaRed = COLOR_RED[11:8];
                    vgaGreen = COLOR_RED[7:4];
                    vgaBlue = COLOR_RED[3:0];
                end
                else begin
                    vgaRed = COLOR_BLUE[11:8];
                    vgaGreen = COLOR_BLUE[7:4];
                    vgaBlue = COLOR_BLUE[3:0];
                end
            end
            else begin
                case(sw)
                    2'b00: begin // Yellow screen
                        vgaRed = COLOR_YELLOW[11:8];
                        vgaGreen = COLOR_YELLOW[7:4];
                        vgaBlue = COLOR_YELLOW[3:0];
                    end
                    2'b01: begin // Red/white bars
                        if (hCount[4]) begin
                            vgaRed = COLOR_WHITE[11:8];
                            vgaGreen = COLOR_WHITE[7:4];
                            vgaBlue = COLOR_WHITE[3:0];
                        end
                        else begin
                            vgaRed = COLOR_RED[11:8];
                            vgaGreen = COLOR_RED[7:4];
                            vgaBlue = COLOR_RED[3:0];
                        end
                    end
                    2'b10: begin // Green block in top-right
                        if (hCount >= 512 && hCount < 640 && vCount < 128) begin
                            vgaRed = COLOR_GREEN[11:8];
                            vgaGreen = COLOR_GREEN[7:4];
                            vgaBlue = COLOR_GREEN[3:0];
                        end
                        else begin
                            vgaRed = COLOR_BLACK[11:8];
                            vgaGreen = COLOR_BLACK[7:4];
                            vgaBlue = COLOR_BLACK[3:0];
                        end
                    end
                    2'b11: begin // Blue stripe at bottom
                        if (vCount >= 447 && vCount < 479) begin
                            vgaRed = COLOR_BLUE[11:8];
                            vgaGreen = COLOR_BLUE[7:4];
                            vgaBlue = COLOR_BLUE[3:0];
                        end
                        else begin
                            vgaRed = COLOR_BLACK[11:8];
                            vgaGreen = COLOR_BLACK[7:4];
                            vgaBlue = COLOR_BLACK[3:0];
                        end
                    end
                    default: begin
                        vgaRed = COLOR_BLACK[11:8];
                        vgaGreen = COLOR_BLACK[7:4];
                        vgaBlue = COLOR_BLACK[3:0];
                    end
                endcase
            end
        end
    end

endmodule
