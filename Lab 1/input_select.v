`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/17/2025 11:00:25 PM
// Design Name: 
// Module Name: input_select
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


module input_select(
    input wire [1:0] mode, // mode selector
    input wire [13:0] slider, // 14 bit slider
    output reg [3:0] dispA, // display A
    output reg [3:0] dispB, // display B
    output reg [3:0] dispC, // display C
    output reg [3:0] dispD // displayD
           
    );
    wire [4:0] sum; // used to calculate sum in mode 3
    assign sum = slider[7:4] + slider[3:0]; // initialise 5 bit register
  
    always @*
    begin
        case (mode)
            //mode 0, show WPI ID digits
            2'b00: 
            begin
                //mode 0, all 4 outputs are wpi ID
                dispA <= 4'b0010; //digit 2
                dispB <= 4'b0001; // digit 1
                dispC <= 4'b1000; // digit 8
                dispD <= 4'b0100; // digit 4
                
         
            end
            //mode 1, hexa to decimal
            2'b01:
            begin
                 dispA <= slider[13:12]; // display A
                 dispB <= slider[11:8]; // disp;ay B
                 dispC <= slider[7:4];  // display C
                 dispD <= slider[3:0];  // display D
            end
            
            //mode 2, multiplication operator 
            2'b10:
            begin
                dispA <= slider[13:12]; //  display A, remians unchanged
                dispB <= slider[11:8];  //  display B, remains unchanged
                dispC <= slider[7:4]<<1;//  display C, multiply by 2
                dispD <= slider[3:0]<<1; // display D, multiply by 2
            end
//                sum <= slider[7:4] + slider[3:0]; // initialise 5 bit register          
            // mode 3, combination of outputs
            2'b11:
            begin
                dispA <= slider[7:4];
                dispB <= slider[3:0];
                dispC <= sum[4]; // 5th bit
                dispD <= sum[3:0]; // bits 3 to 0
            end
        endcase
    end
        
        
endmodule
