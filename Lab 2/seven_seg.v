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
// Description: This module implements a 4-digit seven-segment display with multiplexing.
//
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module seven_seg(
    input [3:0] displayA, // First digit
    input [3:0] displayB, // Second digit
    input [3:0] displayC, // Third digit
    input [3:0] displayD, // Fourth digit
    input wire reset_n,    // Active-low reset
    input clk_25mhz,       // 25 MHz clock input
    output reg [6:0] segment, // 7-segment output
    output reg [3:0] anode     // Active-low anode control
);

    reg [19:0] refresh_counter = 0; // Counter for multiplexing 
                                    // we are most interested in refresh_counter[15] for our clock cycle
    reg [1:0] anode_select = 0;     // 2-bit counter to select active digit
    reg [3:0] hex;                  // Stores the current hex digit to display

    // Slow down multiplexer rate using counter
    always @(posedge clk_25mhz or negedge reset_n) 
    begin
        if (!reset_n) // reset_n is 0
        begin
            refresh_counter <= 0;
        end 
        
        else 
        begin
            refresh_counter <= refresh_counter + 1; // increment counter
        end
    end

    // Select which digit to display based on counter
    always @(posedge refresh_counter[15] or negedge reset_n) begin
        if (!reset_n) begin
            anode_select <= 0;
        end 
        else 
        begin
            anode_select <= anode_select + 1;
        end
    end

    // Multiplexing logic: Select active display and corresponding hex value
    always @(*) begin
    if (!reset_n) // reset is active, displays must be off
    begin
        anode = 4'b1111;  // Force all anodes off during reset
        hex = 4'b0000;    // Ensure segments are off
    end 
    else 
    begin
        case (anode_select)
            2'b00: begin
                hex = displayA;
                anode = 4'b0111; // AN0 active
            end
            2'b01: begin
                hex = displayB;
                anode = 4'b1011; // AN1 active
            end
            2'b10: begin
                hex = displayC;
                anode = 4'b1101; // AN2 active
            end
            2'b11: begin
                hex = displayD;
                anode = 4'b1110; // AN3 active
            end
        endcase
    end
end


    // Hex to 7-segment decoder (same as lab 1)
    always @(*) begin
        case (hex)
            4'h0: segment = 7'b1000000;  // 0
            4'h1: segment = 7'b1111001;  // 1
            4'h2: segment = 7'b0100100;  // 2
            4'h3: segment = 7'b0110000;  // 3
            4'h4: segment = 7'b0011001;  // 4
            4'h5: segment = 7'b0010010;  // 5
            4'h6: segment = 7'b0000010;  // 6
            4'h7: segment = 7'b1111000;  // 7
            4'h8: segment = 7'b0000000;  // 8
            4'h9: segment = 7'b0010000;  // 9
            4'hA: segment = 7'b0001000;  // A
            4'hB: segment = 7'b0000011;  // B
            4'hC: segment = 7'b1000110;  // C
            4'hD: segment = 7'b0100001;  // D
            4'hE: segment = 7'b0000110;  // E
            4'hF: segment = 7'b0001110;  // F
            default: segment = 7'b1111111; // Blank display
        endcase
    end

endmodule
