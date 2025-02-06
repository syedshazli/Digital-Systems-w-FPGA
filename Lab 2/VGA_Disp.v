`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2025 11:27:40 PM
// Design Name: top_lab2
// Module Name: VGA_Disp
// Project Name: Lab2_ECE_3829
// Target Devices: FPGA
// Description: This file aims to provide the functionality for part 3A of Lab 2, 
//              displaying colors based on input select
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module VGA_Disp(
    input [1:0] sw, // switch for color display
    input clk_25mhz, // 25 mhz clock
    input reset, // negedge reset controlled by button D
    input wire [10:0] hCount, // wire from VGA controller output
    input wire [10:0] vCount, // wire from VGA controller output
    input wire blank, // default in all cases
    output [3:0] vgaRed, // for VGA output color
    output [3:0] vgaGreen, // VGA output color green
    output [3:0] vgaBlue // VGA output color blue
  
    );
    reg [11:0] colorValue; 
    
   // Define 12-bit color parameters: 4 bits per channel
    parameter COLOR_YELLOW = 12'b1111_1111_0000; // Yellow (R=F, G=F, B=0)
    parameter COLOR_WHITE  = 12'b1111_1111_1111; // White (R=F, G=F, B=F)
    parameter COLOR_RED    = 12'b1111_0000_0000; // Red (R=F, G=0, B=0)
    parameter COLOR_GREEN  = 12'b0000_1111_0000; // Green (R=0, G=F, B=0)
    parameter COLOR_BLUE   = 12'b0000_0000_1111; // Blue (R=0, G=0, B=F)
    parameter COLOR_BLACK  = 12'b0000_0000_0000; // Black (R=0, G=0, B=0)
    
    
    
    always @(*)
    begin
        if(!blank)
        begin
            case(sw)
                2'b00: 
                    begin
                    //oompletely yellow display
                        colorValue = COLOR_YELLOW;
                    end
            
                2'b01:
                    begin
                        // Vertical bars of alternating red and white. Each bar is 16-pixels wide in the
                        // horizontal direction
                        // notice that every 16 shifts in binary the 5th bit flips from 0 to 1 or 1 to 0
                        // so we use the 5th bit of hcount 
                        if(hCount[4] == 1'b0)
                            begin
                                colorValue = COLOR_RED;
                            end
                        else
                            begin
                                colorValue = COLOR_WHITE;
                            end
                    end
            
                2'b10:
                    begin
                    end
                2'b11:
                    begin
                    end
                default: colorValue = COLOR_BLACK;
                endcase
          end // end of case
          
          else //
          begin
            colorValue = COLOR_BLACK;
          end
    end
    // always @ posedge clock
    //      // case (select color based on this)
    //  need combination of rgb to generate yello
    
     assign vgaRed = colorValue[11:8];
    assign vgaGreen = colorValue[7:4];
    assign vgaBlue = colorValue[3:0];
endmodule
