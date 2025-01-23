`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/21/2025 10:41:12 AM
// Design Name: 
// Module Name: seven_seg
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

//create the module and initalise inputs and outputs
module seven_seg(
    input [3:0] displayA,
    input [3:0] displayB,
    input [3:0] displayC,
    input [3:0] displayD,
    input [3:0] select,
    output reg [6:0] segment, // segment to be connected to the seg in the constraints file
    output reg [3:0] anode // anode, reg because it is inside an always block
  
   
    );
    reg [3:0] hex; // Used internally for hex to 7 seg decoder
 
    
    
    
    // Create a mux to select which value to display
    // Instead of using the ? operator to use our mux, we will use if-else if-else
    
     //Syntax is as follows
//    if ([expression 1])
//	   Single statement
//    else if ([expression 2]) begin
//	   Multiple Statements
//    end else
//	   Single statement
    always @*
    begin
        // for each case of select, set the corresponding hex to that of the display, and set the anode to 1
        
    if (select[0]) // Activate AN0
    begin
        hex = displayA;
        anode = 4'b0111; // AN0 active (low)
    end
    else if (select[1]) // Activate AN1
    begin
        hex = displayB;
        anode = 4'b1011; // AN1 active (low)
    end
    else if (select[2]) // Activate AN2
    begin
        hex = displayC;
        anode = 4'b1101; // AN2 active (low)
    end
    else if (select[3]) // Activate AN3
    begin
        hex = displayD;
        anode = 4'b1110; // AN3 active (low)
    end
    else
    begin
        hex = 4'b0000;
        anode = 4'b1111; // All anodes inactive (high)
    end

        
    end // end of mux that selects
    
   
 
 
 
 
    // Build the hex to seven seg decoder, evaluate different cases for hex and convert to seven seg
    always @*
    begin
        case(hex)
            4'h0: segment[6:0] = 7'b1000000;    // digit 0
            4'h1: segment[6:0] = 7'b1111001;    // digit 1
            4'h2: segment[6:0] = 7'b0100100;    // digit 2
            4'h3: segment[6:0] = 7'b0110000;    // digit 3
            4'h4: segment[6:0] = 7'b0011001;    // digit 4
            4'h5: segment[6:0] = 7'b0010010;    // digit 5
            4'h6: segment[6:0] = 7'b0000010;    // digit 6
            4'h7: segment[6:0] = 7'b1111000;    // digit 7
            4'h8: segment[6:0] = 7'b0000000;    // digit 8
            4'h9: segment[6:0] = 7'b0010000;    // digit 9
            4'ha: segment[6:0] = 7'b0001000;    // digit A
            4'hb: segment[6:0] = 7'b0000011;    // digit B
            4'hc: segment[6:0] = 7'b1000110;    // digit C
            4'hd: segment[6:0] = 7'b0100001;    // digit D
            4'he: segment[6:0] = 7'b0000110;    // digit E
            default: segment[6:0] = 7'b0001110; // digit F
        endcase
        
    end // end of hex to seven seg decoder
    

    
endmodule
