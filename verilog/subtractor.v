module Subtractor(
  input [7:0] A_exp, B_exp,
  output reg [7:0] diff
  );
  always@(*) begin
    diff = A_exp - B_exp;
  end
endmodule
