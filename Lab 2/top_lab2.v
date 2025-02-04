`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WPI
// Engineer: Syed Shazli
// 
// Create Date: 01/30/2025 02:36:30 PM
// Design Name: top_lab2 top file
// Module Name: top_lab2
// Project Name: Lab2_ECE_3829
// Target Devices: Basys3 FPGA
// Description: This is the top level module for lab 2 for the FPGA lab
// 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_lab2(
    input clk, // input clock
    input btnC, // actuve low negedge, pass down to reset
    input [1:0] sw, // negedge
    output wire [6:0] seg,       // Seven-segment display segments
    output wire [3:0] an         // Anodes for the seven-segment display
    );
    // internal wires A-D for sev seg display
    wire [3:0] dispAWire;
    wire [3:0] dispBWire; 
    wire [3:0] dispCWire;
    wire [3:0] dispDWire;
    
    wire hCount;
    wire vCount;
    wire blank; // default in all cases
    wire reset_n;
    wire clk_25mhz; // 25 mhz output clock
    
    // convert 100 mhz input clock to 25 mhz output clock
    clk_wiz_0 clk_wiz_0i(
    // Clock out ports
    .clk_25mhz(clk_25mhz),     // output clk_25mhz
    
    // Status and control signals
    .reset(btnC), // A push button connects to the reset input 
    .locked(reset_n),       // output locked
   // Clock in ports
    .clk_in1(clk)     // input clk_in1
    ); // end of conversion
    
    // seven seg module
    seven_seg sevseg(
        .displayA(4'd2),
        .displayB(4'd7),
        .displayC(4'd8),
        .displayD(4'd9),
        .reset_n(reset_n),
        .clk_25mhz(clk_25mhz),
        .segment(segment),
        .anode(anode)
    );
endmodule
