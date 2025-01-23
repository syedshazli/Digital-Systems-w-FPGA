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
    output wire [3:0] an         // Anodes for the seven-segment display
    );
    // internal wires
    wire [3:0] pushbutton;
    wire [3:0] dispAWire;
    wire [3:0] dispBWire; 
    wire [3:0] dispCWire;
    wire [3:0] dispDWire;
    
    
    // Assign button signals to the internal pb wire
    assign pushbutton[0] = btnU; //display A
    assign pushbutton[1] = btnL; // display B
    assign pushbutton[2] = btnR; // display C
    assign pushbutton[3] = btnD; //display D
    assign dp = 0;
    
    always @*
    begin
        led = sw;
        
    end
   
  
    
     
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
    .select(pushbutton),
    .segment(seg),
    .anode(an)
);

endmodule
