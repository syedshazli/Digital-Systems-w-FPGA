`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WPI
// Engineer: Syed Shazli
// 
// Create Date: 01/21/2025 10:41:12 AM
// Design Name: lab1_top
// Module Name: seven_seg
// Project Name: lab_1_ECE 3829
// Target Devices: FPGA
// Description: This module is used to display the logic for a hex to seven segment display decoder
//               as well as creation of a mux to select which values to display on our seven segment display
// 
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module seven_seg(
    input [3:0] displayA, // displayA
    input [3:0] displayB, // display B
    input [3:0] displayC, // displayC
    input [3:0] displayD, // displayD
    input [3:0] select,   // select mode
    output reg [6:0] segment, // segment to be connected to the seg in the constraints file
    output reg [3:0] anode    // anode, reg because it is inside an always block
);

    reg [3:0] hex;           // Used internally for hex to 7 seg decoder
    integer active_buttons;  // Counter for the number of active buttons
    
    // Always block to handle display selection and ensure no latches
    always @* begin
        // Default assignments to avoid latches
        hex = 4'b0000;        // Default hex value (turns off display by default)
        anode = 4'b1111;      // Default anode state (all anodes off)
        
        // Count active buttons
        active_buttons = select[0] + select[1] + select[2] + select[3];

        // Display logic
        if (active_buttons == 1) begin
            if (select[0]) // display A
            begin
                hex = displayA; // set hex to display A
                anode = 4'b0111; // AN0 active (low)
            end 
            
            else if (select[1]) 
            begin
                hex = displayB;
                anode = 4'b1011; // AN1 active (low)
            end 
            
            else if (select[2]) begin // set hex to display C
                hex = displayC; 
                anode = 4'b1101; // AN2 active (low)
            end 
            
            
            else if (select[3]) begin // set hex to display D
                hex = displayD;
                anode = 4'b1110; // AN3 active (low)
            end
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
