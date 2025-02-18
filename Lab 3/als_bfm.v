`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  WPI
// Engineer: Syed Shazli
// 
// Create Date: 02/14/2025 07:41:47 PM
// Design Name: Lab 3
// Module Name: als_bfm
// Project Name: ECE_3829_Lab3
// Target Devices: FPGA
// Description: This file serves to be the implementation of the bus functional module 
                // Following the requirements posted in the ALS data sheet
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module als_bfm(
    input wire SCLK, // 4 mhz sclk
    input wire CS_N,    // active low chip select
    output reg SDO      // sData output defined in data sheet
);
    
    reg [7:0] data_sequence [0:3]; // data sequence for the 4 different random numbers
    reg [4:0] bit_index; // counts up to 15, then resets
    reg [1:0] data_index;   // counts up to 3
    parameter DATA_ACCESS_TIME = 40; // 40 ns
    initial begin
        // Initialize data sequence
        data_sequence[0] = 8'b10100011;
        data_sequence[1] = 8'b01001111;
        data_sequence[2] = 8'b11010010;
        data_sequence[3] = 8'b01101011;
        bit_index = 0;
        data_index = 0;
        SDO = 0;
    end
    
    always @(negedge SCLK) begin
        // CS is low, begin process
        if (!CS_N) begin
            if (bit_index < 3) begin
                #DATA_ACCESS_TIME;
                 SDO <= 1'b0;  // 3 leading zeros
                bit_index <= bit_index + 1;
            end
            else if (bit_index < 11) begin  // Bits 3-10 are data
                #DATA_ACCESS_TIME 
                SDO <= data_sequence[data_index][10 - bit_index];
                bit_index <= bit_index + 1;
            end
            else if (bit_index < 15) begin  // Bits 11-14 are trailing zeros
                #DATA_ACCESS_TIME 
                SDO <= 1'b0;
                bit_index <= bit_index + 1;
            end
        end else begin
            SDO <= 1'bz;  // Tri-state when CS_N is high
            bit_index <= 0;
            if (bit_index == 15) begin  // Only increment data_index when we've completed a full sequence
                data_index <= data_index + 1;
                if (data_index == 3) data_index <= 0;
            end
        end
    end
endmodule 
