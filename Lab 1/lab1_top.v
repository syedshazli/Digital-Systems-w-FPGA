`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/22/2025 02:35:38 PM
// Design Name: 
// Module Name: lab1_top
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


module lab1_top(
    input wire [15:0] sw,        // 16 switches
    output reg [15:0] led,       // 16 LEDs
    input wire btnU,             // Button Up
    input wire btnL,             // Button Left
    input wire btnR,             // Button Right
    input wire btnD,             // Button Down
    output wire [6:0] seg,       // Seven-segment display segments
    output wire dp,              // Decimal point for the seven-segment display
    output wire [3:0] an         // Anodes for the seven-segment display
    );
    // internal wires
    wire [3:0] pushbutton;
    wire [3:0] dispAWire;
    wire [3:0] dispBWire; 
    wire [3:0] dispCWire;
    wire [3:0] dispDWire;
    
    
    // Assign button signals to the internal pb wire
    assign pushbutton[0] = btnU;
    assign pushbutton[1] = btnL;
    assign pushbutton[2] = btnR;
    assign pushbutton[3] = btnD;
    
    
    always @*
    begin
        led = sw;
        
    end
    assign pushbutton[0] = btnU;
  
    
     
// input select submodule
input_select inputSel(
    .mode(sw[15:14]),
    .slider(sw[13:0]),
    .dispA(dispAWire),
    .dispB(dispBWire),
    .dispC(dispCWire),
    .dispD(dispDWire)
);

// seven seg submodule
seven_seg sevseg(
    .displayA(dispAWire),
    .displayB(dispBWire),
    .displayC(dispCWire),
    .displayD(dispDWire),
    .select(pb),
    .segment(seg),
    .anode(an)
);

endmodule

