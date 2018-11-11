`include "lshift2.v"

module testlshift();

  reg[31:0] immediate;
  wire[31:0] res;
  reg passed = 1;

  lshift28 dut28(.immediate(immediate[25:0]), .lshifted(res[27:0]));


  task shift_check;
    if(immediate<<2!=res) begin
      $display("immediate(%d) and shifted values(%d) disagreed.", immediate, res);
      passed = 0;
    end
  endtask

  initial begin
    immediate = 32'b0; #100
    $dumpfile("lshift.vcd");
    $dumpvars(0, dut28);

    // Test 0
    shift_check();

    // Test 1
    immediate = 32'd1; #10
    shift_check();

    // Test 2
    immediate = 32'd5; #10
    shift_check();

    // Test 3
    immediate = 32'd234; #10
    shift_check();

    // Test 4
    immediate = 32'd3934; #10
    shift_check();

    $display("DUT28 success?: %b", passed);
  end

  // lshift32 dut32(.immediate(immediate), .lshifted(res));
  // initial begin
  //   immediate = 32'b0; #100
  //   $dumpfile("lshift.vcd");
  //   $dumpvars(0, dut28);
  //
  //   // Test 0
  //   shift_check();
  //
  //   // Test 1
  //   immediate = 32'd1; #10
  //   shift_check();
  //
  //   // Test 2
  //   immediate = 32'd5; #10
  //   shift_check();
  //
  //   // Test 3
  //   immediate = 32'd234; #10
  //   shift_check();
  //
  //   // Test 4
  //   immediate = 32'd3934; #10
  //   shift_check();
  //
  //   $display("DUT32 success?: %b", passed);
  // end

endmodule
