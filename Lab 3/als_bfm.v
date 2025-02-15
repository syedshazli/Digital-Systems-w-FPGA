`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2025 07:41:47 PM
// Design Name: 
// Module Name: als_bfm
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


module als_bfm(
    input cs_n, // falling edge of cs_n, conversion process begins
    input sclk,
    output reg sdata,
    output reg [7:0] lastValSent
    );
    
    parameter DATA_ACCESS_TIME = 40;
    
    reg [7:0] sensorValue = 8'd0;
    reg[3:0] bitCounter;
    // ADC enters normal mode when cs is low
    
    always @ (negedge cs_n)
    begin
        sensorValue <= sensorValue + 41; // prime number large enough
        bitCounter <= 4'd0;
    end
    
    always @ (posedge cs_n or negedge sclk)
    begin
        
    end
endmodule

