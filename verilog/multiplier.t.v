`include "multiplier.v"
module multiplier_test ();
  wire [31:0] Hi, Lo;
  reg [31:0] A, B;
  reg enable, pass;

  multiply dut(.enable(enable), .A(A), .B(B), .Hi(Hi), .Lo(Lo));
  initial begin
  A = 32'd0; B = 32'd0; enable = 1'b0; #5
  A = 32'd0; B = 32'd0; enable = 1'b1; #5

  $finish;

  end
endmodule // multiplier_test
