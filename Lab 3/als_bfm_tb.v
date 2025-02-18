timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WPI
// Engineer: Syed Shazli
// 
// Create Date: 02/14/2025 07:42:21 PM
// Design Name: Lab 3
// Module Name: als_bfm_tb
// Project Name: ECE_3829_Lab3
// Target Devices: FPGA
// Description: This file serves as the testbench for the als_BFM module in the lab.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module als_bfm_tb();
    
    reg SCLK;
    reg CS_N;
    wire SDO;
    reg [7:0] captured_data;
    integer i;
    reg [7:0] expected_data;
    integer current_sequence;  // Added to track sequence number
    
    als_bfm uut (
        .SCLK(SCLK),
        .CS_N(CS_N),
        .SDO(SDO)
    );
    
    initial begin
        SCLK = 0;
        forever #125 SCLK = ~SCLK;
    end
    
    initial begin
        CS_N = 1;
        current_sequence = 0;  // Initialize sequence counter
        #500;
        
        repeat (4) begin
            CS_N = 0;
            #125;
            
            // Skip 3 leading zeros
            for (i = 0; i < 3; i = i + 1) begin
                @(negedge SCLK);
            end
            
            // Capture 8 data bits
            captured_data = 8'b0;
            for (i = 0; i < 8; i = i + 1) begin
                @(negedge SCLK);
                #40;
                @(posedge SCLK);
                
                captured_data = {captured_data[6:0], SDO};
            end
            
            // Skip 4 trailing zeros
            for (i = 0; i < 4; i = i + 1) begin
                @(negedge SCLK);
            end
            
            @(posedge SCLK);
            CS_N = 1;
            
            // Get expected data for current sequence
            expected_data = uut.data_sequence[current_sequence];
            
            if (captured_data == expected_data)
                $display("[%0t] PASS: Expected = %b, Actual = %b", $realtime, expected_data, captured_data);
            else
                $display("[%0t] FAIL: Expected = %b, Actual = %b", $realtime, expected_data, captured_data);
                
            current_sequence = (current_sequence + 1) % 4;  // Increment sequence counter
            #500;
        end
        
        $display("Simulation completed");
        $stop;
    end
    
endmodule 
