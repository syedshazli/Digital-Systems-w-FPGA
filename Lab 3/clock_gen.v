`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2025 10:19:48 AM
// Design Name: 
// Module Name: clock_gen
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


module clock_gen(
    input clk,      // 100 MHz input clock
    input btnC,     // Reset button (active-high)
    output clk_10MHz, // 10 MHz clock output
    output reg reset_n // Synchronized locked/reset signal
    );
    
    reg inp_d; // 1 clock delay
    reg inp_dd; // 2 clock delays
    
    wire lockedWire; // locked wire for clock delays
    
     clk_mmcm_wiz clk_mmcm_wiz_i
   (
    // Clock out ports
    .clk_10Mhz(clk_10Mhz),     // output clk_10Mhz
    // Status and control signals
    .reset(btnC), // input reset
    .locked(lockedWire),       // output locked
   // Clock in ports
    .clk_in1(clk) // input clock
    
    );   
    
    
    always @(posedge clk_10Mhz)
    begin
        // use two non blocking assignments for 2 flip flops
        // decreases metastability
        inp_d <= lockedWire;
        inp_dd <= inp_d;
        assign reset_n = inp_dd;
    end
    

   
    
endmodule
