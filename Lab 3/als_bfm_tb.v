`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WPI
// Engineer: Syed Shazli
// 
// Create Date: 02/14/2025 07:42:21 PM
// Design Name: Lab 3
// Module Name: als_bfm_tb
// Project Name: ECE_3829_Lab3
// Target Devices: FPGA
// Description: Testbench for als_bfm using a full 15-bit capture scheme.
// 
// Revision:
// Revision 0.02 - Modified to sample SDO 40 ns after falling edge
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////
module als_bfm_tb();
    
    reg SCLK;
    reg CS_N;
    wire SDO;
    reg [14:0] captured_sequence;  // Store all 15 bits
    reg [7:0] captured_data;      // Final 8-bit data
    integer i;
    reg [7:0] expected_data;
    integer current_sequence;
    
    als_bfm uut (
        .SCLK(SCLK),
        .CS_N(CS_N),
        .SDO(SDO)
    );
    
    // Clock generation
    initial begin
        SCLK = 0;
        forever #125 SCLK = ~SCLK;
    end
    
    // Capture all bits on negedge SCLK
    always @(negedge SCLK) begin
        if (!CS_N) begin
            captured_sequence <= {captured_sequence[13:0], SDO};
        end
    end
    
    initial begin
        CS_N = 1;
        current_sequence = 0;
        captured_sequence = 15'b0;
        #500;
        
        repeat (4) begin
            // Start transaction
            CS_N = 0;
            captured_sequence = 15'b0;  // Clear the capture register
            
            // Wait for all 15 bits to be captured
            repeat (15) @(negedge SCLK);
            
            // Extract the 8 data bits (bits 9:2 of the 15-bit sequence)
            captured_data = captured_sequence[9:2];
            
            @(posedge SCLK);
            CS_N = 1;
            
            // Get expected data for current sequence
            expected_data = uut.data_sequence[current_sequence];
            
            if (captured_data == expected_data)
                $display("[%0t] PASS: Expected = %b, Actual = %b", $realtime, expected_data, captured_data);
            else
                $display("[%0t] FAIL: Expected = %b, Actual = %b", $realtime, expected_data, captured_data);
                
            current_sequence = (current_sequence + 1) % 4;
            #500;
        end
        
        $display("Simulation completed");
        $stop;
    end
    
endmodule
