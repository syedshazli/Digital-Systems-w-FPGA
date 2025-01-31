`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WPI
// Engineer: Syed Shazli
// 
// Create Date: 01/30/2025 10:41:12 AM
// Design Name: top_lab2
// Module Name: seven_seg
// Project Name: Lab2_ECE_3829
// Target Devices: FPGA
// Description: This module is used to display the logic for a hex to seven segment display decoder
//               as well as creation of a mux to select which values to display on our seven segment display. 

// 
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module seven_seg(
    input [3:0] displayA, // displayA
    input [3:0] displayB, // display B
    input [3:0] displayC, // displayC
    input [3:0] displayD, // displayD
    input wire reset_n, // active low reset input
    input clk_25mhz, // 25 mhz clock
    output reg [6:0] segment, // segment to be connected to the seg in the constraints file
    output reg [3:0] anode    // anode, reg because it is inside an always block
    
);

    reg [3:0] hex;           // Used internally for hex to 7 seg decoder
    
    // one always block to handle counter, incrmenting, if reset is low, set counter to 0
        // when reset is 0, counter starts countin
     
     //posedge clk_25mhz or negedge reset_n
     
     // a reminder that we are keeping the display constant, as our 4 WPI ID digits, nothing on the display is being incremented
    // always @ posedge for timing and counter
    // always @ * for the logic with the actual display (turning on only one at a tine)
    // always @ * is the mux for outputting the seven seg
    
    // Always block for timing constraints, probably shouldn't include hex and anode???
    always @(*) begin
        // Default assignments to avoid latches
        hex = 4'b0000;        // Default hex value (turns off display by default)
        anode = 4'b1111;      // Default anode state (all anodes off)
        
 
        
         
            
            begin
                hex = displayA; // set hex to display A
                anode = 4'b0111; // AN0 active (low)
            end 
            
       
            begin
                hex = displayB;
                anode = 4'b1011; // AN1 active (low)
            end 
            
            begin
                hex = displayC; 
                anode = 4'b1101; // AN2 active (low)
            end 
            
            
           begin // set hex to display D
                hex = displayD;
                anode = 4'b1110; // AN3 active (low)
            end
    
        // No need for an explicit else block, as defaults are already set above
    end

    // Hex to seven-segment decoder
    always @* begin
        case (hex)
            4'h0: segment[6:0] = 7'b1000000;    // digit 0
            4'h1: segment[6:0] = 7'b1111001;    // digit 1
            4'h2: segment[6:0] = 7'b0100100;    // digit 2
            4'h3: segment[6:0] = 7'b0110000;    // digit 3
            4'h4: segment[6:0] = 7'b0011001;    // digit 4
            4'h5: segment[6:0] = 7'b0010010;    // digit 5
            4'h6: segment[6:0] = 7'b0000010;    // digit 6
            4'h7: segment[6:0] = 7'b1111000;    // digit 7
            4'h8: segment[6:0] = 7'b0000000;    // digit 8
            4'h9: segment[6:0] = 7'b0010000;    // digit 9
            4'ha: segment[6:0] = 7'b0001000;    // digit A
            4'hb: segment[6:0] = 7'b0000011;    // digit B
            4'hc: segment[6:0] = 7'b1000110;    // digit C
            4'hd: segment[6:0] = 7'b0100001;    // digit D
            4'he: segment[6:0] = 7'b0000110;    // digit E
            4'hf: segment[6:0] = 7'b0001110;    // digit F
            default: segment[6:0] = 7'b1111111; // Turn off segments
        endcase
    end
endmodule
