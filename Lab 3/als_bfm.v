module als_bfm(
    input wire SCLK,
    input wire CS_N,
    output reg SDO
);
    
    reg [7:0] data_sequence [0:3];
    reg [4:0] bit_index;
    reg [1:0] data_index;
    
    initial begin
        // Initialize data sequence
        data_sequence[0] = 8'b10100011;
        data_sequence[1] = 8'b01001111;
        data_sequence[2] = 8'b11010010;
        data_sequence[3] = 8'b01101011;
        bit_index = 0;
        data_index = 0;
        SDO = 0;
    end
    
    always @(negedge SCLK) begin
        if (!CS_N) begin
            if (bit_index < 3) begin
                #40 SDO <= 1'b0;  // 3 leading zeros
                bit_index <= bit_index + 1;
            end
            else if (bit_index < 11) begin  // Bits 3-10 are data
                #40 SDO <= data_sequence[data_index][10 - bit_index];
                bit_index <= bit_index + 1;
            end
            else if (bit_index < 15) begin  // Bits 11-14 are trailing zeros
                #40 SDO <= 1'b0;
                bit_index <= bit_index + 1;
            end
        end else begin
            SDO <= 1'bz;  // Tri-state when CS_N is high
            bit_index <= 0;
            if (bit_index == 15) begin  // Only increment data_index when we've completed a full sequence
                data_index <= data_index + 1;
                if (data_index == 3) data_index <= 0;
            end
        end
    end
endmodule
