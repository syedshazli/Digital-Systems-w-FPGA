`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2025 08:59:25 PM
// Design Name: 
// Module Name: test_led_counter
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


module test_led_counter(
    );
    
    //declare input signals as registers
    reg btnC; // Center button to reset logic
    reg clk_100m; // 100 mhz clock
    
    wire [15:0] led; // output is a wire
    
    //Create a clock signal
    // time in units are in nanoseconds, as defined in 'timestamp in first line
    // 100 mHz clock => 10 nsec period, 5 nsec high, 5 nsec low
    parameter C_CLK_HALF_PERIOD = 5;
    
    // # means delay or wait before executing signal
    // toggle state every 5 nanoseconds
    always begin
        # C_CLK_HALF_PERIOD clk_100m <= ~clk_100m;
    end
    
    //Create the reset signal
    initial begin
        clk_100m = 1'b0; // initialise clock to 0 and button to 1
        btnC = 1'b1;
        // wait 2000 nanoseconds and release from reset
        # 2000 btnC = 1'b0;
        // run for 200 useconds, then stop simulation
        # 200000;
        $stop;
    end
    
    // instantiate top_counter as the unit under test
    top_counter uuti(
        .clk(clk_100m), // input clock
        .btnC(btnC),    // button for reset
        .led(led)       // led
        );
    
    // temporarily override your counter value to speed simulation results
    // without having to modify code
    defparam uuti.led_counteri.C_MAX_COUNT = 100;
    
endmodule
