`include "signextend.v"

module testSignExtend();

  reg[31:0] immediate;
  wire[31:0] extended;
  reg passed = 1;

  signExtend dut(.immediate(immediate[15:0]), .extended(extended));

  task extend_check;
    if(immediate!=extended) begin
      $display("immediate(%d) and extened values(%d) disagreed.", immediate, extended);
      passed = 0;
    end
  endtask

  initial begin
    immediate = 32'b0; #100
    $dumpfile("signextend.vcd");
    $dumpvars(0, dut);

    // Test 0
    extend_check();

    // Test 1
    immediate = 32'sd1; #10
    extend_check();

    // Test 2
    immediate = -32'sd2; #10
    extend_check();

    // Test 3
    immediate = -32'sd234; #10
    extend_check();

    // Test 4
    immediate = 32'sd3934; #10
    extend_check();

    $display("DUT success?: %b", passed);
  end

endmodule
