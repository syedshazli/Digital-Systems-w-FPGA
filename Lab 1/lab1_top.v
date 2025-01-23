`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WPI
// Engineer: Syed Sjazli
// 
// Create Date: 01/22/2025 02:35:38 PM
// Design Name: 
// Module Name: lab1_top
// Project Name: lab_1_ECE3829
// Target Devices: FPGA
// Description: This file serves as the top level file for lab 1, which includes information about submodules as well as button assignments that allow us to push buttons for viewing the seven segment display
// 
// 
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////2

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
   
    // make sure whenever a switch is turned on, that its corresponding LED turns on
    // This is done through this always @ block
    always @*
    begin
        led = sw;
        
    end
   
  
    
     
// input select submodule
   input_select inputSel(
        .mode(sw[15:14]),   // mode is bits [15:14]
        .slider(sw[13:0]),  // slider for changing the seven seg output is switches [13:0]
        .dispA(dispAWire),  // wire to configure display A
        .dispB(dispBWire),  // wire to configure display B
        .dispC(dispCWire),  // wire to configure display C
        .dispD(dispDWire)   // wire to configure display D
    );

// seven seg submodule
seven_seg sevseg(
    .displayA(dispAWire), // in the seven seg module, reference display A wire
    .displayB(dispBWire), // in the seven seg module, reference display B wire
    .displayC(dispCWire),  // in the seven seg module, reference display C wire
    .displayD(dispDWire),   // // in the seven seg module, reference display D wire
    .select(pushbutton),    // // our button that will be mapped to the select input
    .segment(seg), // used for the seven seg defined in the constraints file
    .anode(an)            // used for the anodes, will consult the constraints file

);

endmodule
