module encoder(
  input [2:0] D_In,
  output reg [1:0] D_Out
)

  
  always @(*)
    begin
      case (D_in):
        3'101: D_Out = 2'b10;
        3'110: D_out = 2'b01;
        3'011: D_out = 2'b11;
        3'000: D_out = 2'b11;
        default: D_out = 2'b00;
      endcase
    end
endmodule
