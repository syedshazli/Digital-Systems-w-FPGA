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
    input wire reset, // negedge reset controlled by button D
    input wire buttonL,
    input wire [10:0] hCount, // wire from VGA controller output
    input wire [10:0] vCount, // wire from VGA controller output
    input wire blank, // default in all cases
    output [3:0] vgaRed, // for VGA output color
    output [3:0] vgaGreen, // VGA output color green
    output [3:0] vgaBlue // VGA output color blue
  
    );
    reg [11:0] colorValue; 
    reg pushedButton; // for making sure moving block takes priority, must be pinned to a button on FPGA
    
   // Define 12-bit color parameters: 4 bits per channel
    parameter COLOR_YELLOW = 12'b1111_1111_0000; // Yellow (R=F, G=F, B=0)
    parameter COLOR_WHITE  = 12'b1111_1111_1111; // White (R=F, G=F, B=F)
    parameter COLOR_RED    = 12'b1111_0000_0000; // Red (R=F, G=0, B=0)
    parameter COLOR_GREEN  = 12'b0000_1111_0000; // Green (R=0, G=F, B=0)
    parameter COLOR_BLUE   = 12'b0000_0000_1111; // Blue (R=0, G=0, B=F)
    parameter COLOR_BLACK  = 12'b0000_0000_0000; // Black (R=0, G=0, B=0)
    
    // 2 HZ clock rate to move block down
    parameter MODIFIED_CLK_RATE = 12500000;

    // Registers for block movement (part 3B)
    // we don't want to completely reset hCount and vCount, as they are wires defined by the vga controller
    // instead, we will make x, y regs that will monitor the positioning of vCount and hCount
        // helping us determine if we can make a valid move for our 32 x 32 block
    reg [9:0] block_y_pos = 0; 
    reg [9:0] block_x_pos = 302; // Fixed x-position in the middle of screen
    reg [23:0] clock_counter = 0; // 2 hz clock counter
    reg moving_block_mode = 0;
    
    
     // part 3B: moving block
   // maybe create a flag whenever this button is pressed because it takes priority. Need to let other button functions know
   always @ (posedge clk_25mhz)
   begin
            // clock cycle reset
           if(!reset)
           begin
                moving_block_mode <= 0;
                block_y_pos <= 0;
                clock_counter <= 0;
           end
           
           // button is pressed down indicating we want to see the moving block
           // must keep incrmeenting block_y_pos
           else if(buttonL)
           begin
           moving_block_mode <= 1;
           clock_counter <= clock_counter +1;
           
           // 2 Hz rate, let's move the block down
           if(clock_counter >= MODIFIED_CLK_RATE)
           begin
           if(block_y_pos < 416) // 448 - 32 (make sure we are placing in a valid y position)
                block_y_pos <= block_y_pos +1;
                
            clock_counter <= 0; // reset counter
           end
            
            
           end // end of else if
           
           // button is not pressed down, stop block from moving    
           else
           begin
           moving_block_mode <=1;
           clock_counter <=0; // reset frame counter
           end
    
   end
    
    always @(*)
    begin
        
        
        if(!blank)
        begin
        // checks if pixels are in the moving block area
            if(moving_block_mode ==1 && hCount >= block_x_pos && hCount < block_x_pos + 32 &&
                vCount >= block_y_pos && vCount < block_y_pos + 32)
            begin
                colorValue = COLOR_RED;
            end
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
            
                2'b10: // A black screen with a green block 128-pixels wide by 128-pixels high in the top right-
                        //hand corner
                    begin
                        if(hCount >= 512 && hCount < 640 && vCount < 128)
                        begin
                                colorValue = COLOR_GREEN;
                        end 
                        else
                            begin
                                colorValue = COLOR_BLACK;
                            end
                    end
                2'b11: // A single horizontal blue stripe 32-pixels wide at the bottom of the screen.
                        //Rest of the screen is black
                    begin
                        if(vCount >= 447 && vCount < 479 )
                        begin
                            colorValue = COLOR_BLUE;
                        end
                        
                        else
                        begin
                            colorValue = COLOR_BLACK;
                        end
                    end
                    
                    
                default: colorValue = COLOR_BLACK;
                endcase
          end // end of case
          
          else // if it's blank, make colorValue black
          begin
            colorValue = COLOR_BLACK;
          end
    end
 
            
  
    // as stated in lab instructions
     assign vgaRed = colorValue[11:8];
    assign vgaGreen = colorValue[7:4];
    assign vgaBlue = colorValue[3:0];
endmodule
