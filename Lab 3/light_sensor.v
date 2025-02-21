`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WPI
// Engineer: Syed Shazli
// 
// Create Date: 02/18/2025 02:35:19 PM
// Design Name: Lab 3
// Module Name: light_sensor
// Project Name:ECE_3829_Lab_3
// Target Devices: FPGA
// Description: This module aims to serve the light sensor logic using counters and a FSM
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module light_sensor
#( parameter TERM_COUNT = 10_000_000)
    (  //Port Paramter
    input clk_10Mhz, // 10 mhz clock from clock_gen
    input reset_n,
    input JA2, //SData
    output reg JA0, //Chip Select
    output reg JA3, //sclk
    output reg [7:0] dataRead //8 bit number for the light sensor reading
    );

    //Registers
    reg [1:0]  newState; // newstate reg for finite state machine logic
    reg [32:0] counter; //1 second delay counter
    reg [4:0] sclk_counter; // 5 bit sclk counter
    reg [7:0] trackingReg; //because its updating too fast place holder register

   
    wire rising_edge;// rising edge used for assign statement w/counter and rise edge param
    wire falling_edge; // falling edge used for assign statement w/counter and fall edge param
    
    //Local Parameters
    localparam C_RISE_EDGE = 0;
    localparam C_FALL_EDGE = 5;
    
    // finite state machine states 
    localparam S_IDLE = 2'b00;
    localparam S_WAIT = 2'b01;
    localparam S_READ = 2'b10;
    
    //Assign rising edge and falling edge statements
    assign rising_edge = (counter == C_RISE_EDGE) ? 1'b1 : 1'b0;
    assign falling_edge = (counter == C_FALL_EDGE) ? 1'b1 : 1'b0;


    //clock frequency divider
    always @ (posedge clk_10Mhz) 
    begin  
    // counter must reach 10, and we must be in the read state 
    // note that counter starts at 0 so once we reach 9 that is 10 cycles     
        if (counter >= 9 && newState == S_READ) begin 
            counter <= 0;
        end
        else begin
            // otherwise, increment counter (used for checking rising edge and falling edge)
            counter <= counter + 1; 
        end
    end
    
    always @ (posedge clk_10Mhz) 
    begin 
        if (reset_n == 0) begin
            // IDLE is the reset state, goes idle when reset is active
            newState <= S_IDLE; 
        end       
        // logic for all 3 states in FSM
       case (newState)
            S_IDLE : 
            begin  //A reset state to initialize the interface on power up
                JA0 <= 1; //Chip select is pulled high (and is not active)
                
                newState <= S_WAIT; // enter the wait state
            end
            
            //Wait state, reset clk divider and make sure sampling time isn't too fast
            S_WAIT : 
            begin 
                if (counter >= TERM_COUNT) 
                begin
                    newState <= S_READ; // have finished counting, safe to read data now
                    sclk_counter <= 0; // reset sclk divider counter                
                end
                
               else
               begin
                newState <= S_WAIT;
               end
                
            end
            
            // read state, use shift register to bring in temporary data
            // once temp data is read, load temp data into output register
            // allows us to 'slow down' the fast coming data
            S_READ : 
            begin
                // chip select is active 
                JA0 <= 0; 
                
                if (rising_edge) // if our counter is 0, set sclk to 1
                begin 
                    JA3 <= 1;
                end
                
                // if our counter has reached 5, set sclk to 0 (done counting)
                // increment sclk counter
                else if (falling_edge) begin
                    JA3 <= 0;
                    sclk_counter <= sclk_counter + 1;
                end    
                
                // read data, 3 leading 0's, 8 bits of data, 4 trailing 0's
                // must be on a rising edge
                if (sclk_counter >= 4 && sclk_counter <= 11 && rising_edge) 
                begin 
                    // chip select is not active, no data to read
                    if (JA0) begin 
                        dataRead <= 0;
                    end
                    // chip select is active, fill the tracking register and shift left with SDATA
                    if (!JA0) begin 
                        trackingReg <= {trackingReg[6:0], JA2}; 
                    end
                end
                
                // implementing a delay using sclk counter, 
                //use trackingReg to give steady data to output regsiter
                // which is then used to put on seven seg
                if (sclk_counter >= 16) 
                begin        
                    dataRead <= trackingReg;
                    newState <= S_IDLE; // reset state after transferring data
                end 
            end
        endcase
    end
endmodule
