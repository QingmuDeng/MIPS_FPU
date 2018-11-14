`include "multiplier.v"
module multiplier_test ();
  wire [31:0] Hi, Lo;
  reg [31:0] A, B;
  reg enable, pass;

  multiply dut(.enable(enable), .A(A), .B(B), .Hi(Hi), .Lo(Lo));

  initial begin
  $dumpfile("multiplier.vcd");
  $dumpvars(0, dut);

  pass=1;

  // Test 1
  A = 32'sd0; B = 32'sd0; enable = 1'b1; #5
  if({Hi, Lo}!=A*B) begin
    $display("Test 1 failed. We got %d from A=%d and B=%d.", {Hi, Lo}, A, B);
    pass=0;
  end

  // Test 2
  A = 32'sd1; B = 32'sd5; enable = 1'b1; #5
  if({Hi, Lo}!=A*B) begin
    $display("Test 2 failed. We got %d from A=%d and B=%d.", {Hi, Lo}, A, B);
    pass=0;
  end

  // Test 3
  A = -32'sd1; B = 32'sd5; enable = 1'b1; #5
  if({Hi, Lo}!=A*B) begin
    $display("Test 3 failed. We got %d from A=%d and B=%d.", {Hi, Lo}, A, B);
    pass=0;
  end

  // Test 4
  A = -32'sd50; B = -32'sd5; enable = 1'b1; #5
  if({Hi, Lo}!=A*B) begin
    $display("Test 4 failed. We got %d from A=%d and B=%d.", {Hi, Lo}, A, B);
    pass=0;
  end

  $display("DUT passed?: %d",pass);
  $finish;

  end
endmodule // multiplier_test
