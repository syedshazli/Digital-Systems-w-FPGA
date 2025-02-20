`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2025 02:35:19 PM
// Design Name: 
// Module Name: light_sensor
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


module light_sensor #(parameter sensorSampleRate = 1) (
   
    input reset_n,
    input clk_10mHz, // 10 mhz input clock
    input wire sensorData, // sensor data input   
    
    // connections to ALS PMOD
    output reg SCLK,
    output reg CS_N,
    output reg [7:0] SDO
    
    
    );
    
   
    
    // The module should have at least one state 
    // machine for the overall control of the sensor interface
    
    // finite state machine 'states'
    
    localparam S_IDLE       = 2'b00;
    localparam S_STARTSPI   = 2'b01;
    localparam S_READ       = 2'b10;
    localparam S_DONE       = 2'b11;
    
    
    // 10 mhz input clock terminal counter
    localparam C_TERM_COUNT = 10;
    // 50% high, 50% low sclk, use this to generate sclk to be 2-4 mhz
    localparam C_RISE_EDGE = 0;
    localparam C_FALL_EDGE = 5;
    
    reg[23:0] lightSensorCounter;
    reg startSPI;
    reg[6:0] bitCounter;
    reg [14:0] shiftRegister;
     wire risingEdge;
     wire fallingEdge;
     reg[5:0] counter;
     assign risingEdge = (counter == C_RISE_EDGE)? 1'b1: 1'b0;
     assign fallingEdge = (counter == C_FALL_EDGE)? 1'b1: 1'b0;
    // registers for state machine
    reg[2:0] currentState;
    reg[2:0] nextState;
    
    // counter for lightSensor, used to set chip select
    always @ (posedge clk_10mHz or negedge reset_n)
    begin
    if(!reset_n)
    begin
        lightSensorCounter <= 0;
        startSPI <= 0;
    end
    
    else if(lightSensorCounter >= (10_000_000/sensorSampleRate)-1)
    begin
        lightSensorCounter <= 0;
         startSPI <= 1;
    end
    
    else
    begin
        lightSensorCounter <= lightSensorCounter +1;
        startSPI <= 0;
        
    end
    
    end
    
    // shift register logic
    always @ (posedge clk_10mHz or negedge reset_n)
begin
    if(!reset_n)
    begin
        shiftRegister <= 0;
    end
    // check if in read state
    else if(currentState == S_READ && fallingEdge)  // Only shift on SCLK falling edge
    begin
        shiftRegister <= {shiftRegister[13:0], sensorData};
    end
end
    
    // once shifted, we want only the meaningful 8 bits of data located in SR[10:3]
    always @(posedge clk_10mHz or negedge reset_n)
    begin
        if(!reset_n)
        begin
            SDO <= 0;
        end
        
        else if (currentState == S_DONE)
        begin
            SDO <= shiftRegister[10:3]; // put 8 bits of info onto output
        end
        
    end
    
    // generate SCLK based on falling/rising edge signals
    always @ (posedge clk_10mHz or negedge reset_n)
    begin
        if(!reset_n)
        begin
            SCLK <= 0;
        end
        else if(risingEdge)
        begin
            SCLK <= 1;
           
        end
        else if (fallingEdge)
        begin
            SCLK <= 0;
            
        end
    end
    
    // chip select logic
    always @ (posedge clk_10mHz or negedge reset_n)
begin
    if(!reset_n)
    begin
        CS_N <= 1;
    end
    else if(currentState == S_STARTSPI)
    begin
        CS_N <= 0;
    end
    else if(currentState == S_DONE || currentState == S_IDLE)
    begin
        CS_N <= 1;
    end
end
    
    // bitCounter used to increment every clock cycle that CS is active
    always @ (posedge clk_10mHz or negedge reset_n)
    begin
        if(!reset_n)
        begin
            bitCounter <= 0;
        end
        
        else if(currentState == S_READ && fallingEdge)
        begin
            bitCounter <= bitCounter +1;
        end
        
        else
        begin
            bitCounter <= 0;
        end
        
    end
    
    // counter used to check against assign statement
    always @ (posedge clk_10mHz or negedge reset_n)
    begin
    if(!reset_n) 
    begin
        counter <= 6'd0;
    end
    else if(currentState == S_READ) // Only count during READ state
    begin
        if(counter >= C_TERM_COUNT)
            counter <= 6'd0;
        else
            counter <= counter + 1;
    end
    else
    begin
        counter <= 6'd0;  // Reset counter in all other states
    end
end
 
   
    // control reset
    always @ (posedge clk_10mHz)
    begin
        if (reset_n == 1'b0) 
        begin
            currentState <= S_IDLE;
        end
        else    
        begin
            currentState <= nextState;
        end
    end
    
    // next state logic
    always @(*)
    begin
        case(currentState)
            // must change
            S_IDLE: 
                begin
                if(startSPI)
                begin
                    nextState = S_STARTSPI;
                end
                else
                    begin
                    nextState = S_IDLE;
                    end
                end
                // we enter this state only if startSPi is 1, so we can immedietley move on to read
            S_STARTSPI: 
                begin
                    nextState = S_READ;
                 end
            S_READ: 
                begin
                    if(bitCounter == 14)
                    begin
                        nextState = S_DONE;
                    end
                    else
                    begin
                        nextState = S_READ;
                    end
                end
            
            S_DONE: 
                nextState = S_IDLE;
            default: 
                nextState = S_IDLE;
        endcase
    end
    
endmodule
