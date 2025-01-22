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
    input [3:0] Select,
    output reg [6:0] seg,
    output reg [3:0] anode // reg because it is inside an always block
  
   
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
    always @ Select
    begin
        // for each case of select, set the corresponding hex to that of the display, and set the anode to 1
        if (Select[0] ==1) 
        begin
            hex = displayA;
            anode[3] = 1;
        end
        else if (Select[1] ==1)
        begin
            hex = displayB;
            anode[2] = 1;
        end
        else if (Select[2] == 2)
        begin
            hex = displayC;
            anode[1] = 0;
        end
        else
        begin
            hex = displayD;
            anode[0] = 1;
        end
        
    end // end of mux that selects
    
   
 
 
 
 
    // Build the hex to seven seg decoder, evaluate different cases for hex and convert to seven seg
    always @*
    begin
        case(hex)
            4'h0: seg[6:0] = 7'b1000000;    // digit 0
            4'h1: seg[6:0] = 7'b1111001;    // digit 1
            4'h2: seg[6:0] = 7'b0100100;    // digit 2
            4'h3: seg[6:0] = 7'b0110000;    // digit 3
            4'h4: seg[6:0] = 7'b0011001;    // digit 4
            4'h5: seg[6:0] = 7'b0010010;    // digit 5
            4'h6: seg[6:0] = 7'b0000010;    // digit 6
            4'h7: seg[6:0] = 7'b1111000;    // digit 7
            4'h8: seg[6:0] = 7'b0000000;    // digit 8
            4'h9: seg[6:0] = 7'b0010000;    // digit 9
            4'ha: seg[6:0] = 7'b0001000;    // digit A
            4'hb: seg[6:0] = 7'b0000011;    // digit B
            4'hc: seg[6:0] = 7'b1000110;    // digit C
            4'hd: seg[6:0] = 7'b0100001;    // digit D
            4'he: seg[6:0] = 7'b0000110;    // digit E
            default: seg[6:0] = 7'b0001110; // digit F
        endcase
        
    end // end of hex to seven seg decoder
    

    
endmodule
