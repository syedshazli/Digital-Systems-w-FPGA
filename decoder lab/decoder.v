`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WPI ECE3829
// Engineer: Syed Shazli
// 
// Create Date: 01/16/2025 02:11:32 PM
// Design Name: My Design
// Module Name: decoder
// Project Name: Decoder Tutorial
// Target Devices: Basys3 development Board
// Tool Versions: 2020.1
// Description: 
// 3 to 8 decoder. Takes 3 inputs and lights a single LED corresponding to the value
// Dependencies: 
// none
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module decoder(
    input [2:0] sw, //Switch inputs
    output reg [7:0] led // LED outputs, reg types required because in always block
    );
    
    // Decoder maps three switch inputs to seven LED outputs
    // lighting on output at a time corresponding to the switch setting
    always @ (sw)
        case (sw)
            3'b000: led = 8'b00000001;
            3'b001: led = 8'b00000010;
            3'b010: led = 8'b00000100;
            3'b011: led = 8'b00001000;
            3'b100: led = 8'b00010000;
            3'b101: led = 8'b00100000;
            3'b110: led = 8'b01000000;
            3'b111: led = 8'b10000000;
        endcase
endmodule
