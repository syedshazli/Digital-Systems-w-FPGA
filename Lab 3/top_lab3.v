`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2025 10:03:17 AM
// Design Name: 
// Module Name: top_lab3
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_lab3(
    input clk, // 100 Mhz input clock
    input btnC, //reset signal
    output [15:0] led, // 16 led's
    output [3:0] JA, // pmod ja for light sensor
     output wire [6:0] seg,  // Seven-segment display segments
    output wire [3:0] an,   // Seven-segment anodes
    input wire SDO, // data from the pmod chip
    output wire SCLK, // sclk from pmod chip
    output wire CS_N // chip select from pmod chip
    );
    
    wire clk_10Mhz; // 10 mhz clock signal
    wire reset_n; // lock signal, used as reset for other logic
    wire [7:0] sensor_value;
    wire [3:0] hex_high;
    wire [3:0] hex_low;
    
    assign hex_high = sensor_value[7:4];  // Upper 4 bits
    assign hex_low  = sensor_value[3:0];  // Lower 4 bits
    
    clock_gen clock_gen_i(
     .clk_10Mhz(clk_10Mhz),     // output clk_10Mhz
    // Status and control signals
    .btnC(btnC), // input reset
    .reset_n(reset_n),       // output locked
   // Clock in ports
    .clk(clk) // input clock
    );
    
    // light sensor module
    light_sensor light_sensor_i(
        .reset_n(reset_n),
        .clk_10mhz(clk_10Mhz),
        .sensorData(SDO),
        .SCLK(SCLK),
        .CS_N(CS_N),
        .SDO(sensor_value)
    );
    
    seven_seg seven_seg_i(
        .displayA(4'h8),
        .displayB(4'h9),
        .displayC(hex_high),
        .displayD(hex_low),
        .segment(seg),
        .reset_n(reset_n),
        .clk_10mHz(clk_10Mhz),
        .anode(an)
    );
    
endmodule
