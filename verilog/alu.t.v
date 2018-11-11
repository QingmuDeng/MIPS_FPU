`timescale 1 ns / 1 ps
`include "alu.v"

`define ADD  3'd0
`define SUB  3'd1
`define XOR  3'd2
`define SLT  3'd3
`define AND  3'd4
`define NAND 3'd5
`define NOR  3'd6
`define OR   3'd7

module testALU();
  wire signed [31:0]    res;
  wire          cout;
  wire          zero;
  wire          ovf;
  reg signed [31:0]     a;
  reg signed [31:0]     b;
  reg[2:0]      cmd;
  reg passed=1;


  ALU dut(.result(res), .carryout(cout), .zero(zero), .overflow(ovf), .operandA(a), .operandB(b), .command(cmd));

  task zero_test;
    if((res==0) && (zero!=1)) begin
      $display("ZERO fault with a=%b, b=%b, res=%d and zero=%d.", a, b, res, zero);
      passed = 0;
    end
  endtask

  // task cout_test;

  // endtask

  task overflow_test;
    if(!ovf)begin
     $display("Overflow Arithmetic Operation didn't incur overflow with a=%d and b=%d", a, b);
     passed=0;
    end
  endtask

  task logic_overflow_test;
    if(ovf) begin
      $display("Logic Operation incurred overflow with command %b", cmd);
      passed=0;
     end
  endtask

  task add_test;
    begin
      if(res != a+b) begin
       $display("Adder fault with a=%d and b=%d. The proper result is %d, but the received is %d.", a, b, a+b, res);
       passed=0;
      end
      zero_test();
    end
  endtask

  task subtractor_test;
    begin
      if(res != a-b)  begin
        $display("subtractor fault with a=%d and b=%d. The proper result is %d, but the received is %d.", a, b, a-b, res);
        passed=0;
       end
      zero_test();
    end
  endtask

  task stl_test;
    begin
      if(res != (a<b)) begin
        $display("SLT fault with a=%d and b=%d. The proper result is %d, but the received is %d.", a, b, a<b, res);
        passed=0;
       end
      zero_test();
    end
  endtask

  task xor_test;
    begin
      if(res != (a^b)) begin
       $display("XOR Logic fault with a=%b and b=%b. The proper result is %d, but the received is %d.", a, b, a^b, res);
       passed=0;
      end
      zero_test();
    end
  endtask

  task nand_test;
    begin
      if(res != ~(a&b)) begin
       $display("NAND Logic fault with a=%b and b=%b. The proper result is %d, but the received is %d.", a, b, ~(a&b), res);
       passed=0;
      end
      zero_test();
    end
  endtask

  task and_test;
    begin
      if(res != (a&b)) begin
       $display("AND Logic fault with a=%b and b=%b. The proper result is %d, but the received is %d.", a, b, (a&b), res);
       passed=0;
      end
      zero_test();
    end
  endtask

  task nor_test;
    begin
      if(res != ~(a|b)) begin
        $display("NOR Logic fault with a=%b and b=%b. The proper result is %d, but the received is %d.", a, b, ~(a|b), res);
        passed=0;
       end
      zero_test();
    end
  endtask

  task or_test;
    begin
      if(res != (a|b)) begin
        $display("OR Logic fault with a=%b and b=%b. The proper result is %d, but the received is %d.", a, b, (a|b), res);
        passed=0;
       end
      zero_test();
    end
  endtask

  initial begin
    $dumpfile("alu.vcd");
    $dumpvars(0, dut);
    a = 32'sd0; b = 32'sd0; cmd = `ADD; #100
    // $display("          A              B    Cmd |          Res Cout  Ovf  Zero | Expected");

    /****************************   Adder Test   ****************************/
    // Adding a positive integer to a positive integer, without overflow
    a = 32'sd2; b = 32'sd1; cmd = `ADD; #10000 add_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   3", a, b, cmd, res, cout, ovf, zero);

    a = 32'sd2312; b = 32'sd123; cmd = `ADD; #10000 add_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   2435", a, b, cmd, res, cout, ovf, zero);

    a = 32'sd543290; b = 32'sd34124123; cmd = `ADD; #10000 add_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   34667413", a, b, cmd, res, cout, ovf, zero);

    // The "zero case"
    a = 32'sd0; b = 32'sd0; cmd = `ADD; #10000 add_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   0", a, b, cmd, res, cout, ovf, zero);

    // Adding a positive integer to a negative integer to get a positive integer
    a = 32'sd4; b = -32'sd2; cmd = `ADD; #10000 add_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   2", a, b, cmd, res, cout, ovf, zero);

    // Adding a negative integer to a negative integer, without overflow
    a = -32'sd5; b = -32'sd7; cmd = `ADD; #10000 add_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   -12", a, b, cmd, res, cout, ovf, zero);

    // Adding a positive integer to a negative integer to get a negative integer
    a = 32'sd5; b = -32'sd7; cmd = `ADD; #10000 add_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   -2", a, b, cmd, res, cout, ovf, zero);

    // Adding zero to a positive integer
    a = 32'sd0; b = 32'sd1321; cmd = `ADD; #10000 add_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   1321", a, b, cmd, res, cout, ovf, zero);

    // Adding zero to a negative integer
    a = -32'sd1213; b = 32'sd0; cmd = `ADD; #10000 add_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   -1213", a, b, cmd, res, cout, ovf, zero);

    // The "all one" case
    a = -32'sd1; b = -32'sd1; cmd = `ADD; #10000 add_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   -2", a, b, cmd, res, cout, ovf, zero);


    // Overflow Tests
    a = 32'sd2147483647; b = 32'sd1; cmd = `ADD; #10000 add_test(); overflow_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   Overflow", a, b, cmd, res, cout, ovf, zero);

    a = -32'sd2147483648; b = -32'sd1; cmd = `ADD; #10000 add_test(); overflow_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   Overflow", a, b, cmd, res, cout, ovf, zero);


    /**************************** Subtractor Test ****************************/
    // Subtracting a positive integer from a positive integer to get a positive integer
    a = 32'sd4; b = 32'sd2; cmd = `SUB; #10000 subtractor_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   2", a, b, cmd, res, cout, ovf, zero);

    // Subtracting a positive integer from a positive integer to get zero
    a = 32'sd100; b = 32'sd100; cmd = `SUB; #10000 subtractor_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   0", a, b, cmd, res, cout, ovf, zero);

    // Subtracting zero from a positive integer
    a = 32'sd107; b = 32'sd0; cmd = `SUB; #10000 subtractor_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   107", a, b, cmd, res, cout, ovf, zero);

    // The "all zero" case
    a = 32'sd0; b = 32'sd0; cmd = `SUB; #10000 subtractor_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   0", a, b, cmd, res, cout, ovf, zero);

    // Subtracting zero from a negative integer
    a = -32'sd3421; b = 32'sd0; cmd = `SUB; #10000 subtractor_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   -3421", a, b, cmd, res, cout, ovf, zero);

    // Subtracting a negative integer from a negative integer to get a negative integer
    a = -32'sd1450; b = -32'sd550; cmd = `SUB; #10000 subtractor_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   -900", a, b, cmd, res, cout, ovf, zero);

    // Subtracting a negative integer from a negative integer to get a positive integer
    a = -32'sd550; b = -32'sd1450; cmd = `SUB; #10000 subtractor_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   900", a, b, cmd, res, cout, ovf, zero);

    // Subtracting a positive integer from a positive integer to get a negative integer
    a = 32'sd550; b = 32'sd1450; cmd = `SUB; #10000 subtractor_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   -900", a, b, cmd, res, cout, ovf, zero);

    // Subtracting a negative integer from a positive integer
    a = 32'sd2500; b = -32'sd324; cmd = `SUB; #10000 subtractor_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   2824", a, b, cmd, res, cout, ovf, zero);

    // Subtracting a positive integer from a negative integer
    a = -32'sd231; b = 32'sd43; cmd = `SUB; #10000 subtractor_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   -274", a, b, cmd, res, cout, ovf, zero);

    // Overflow Tests
    a = -32'sd2147483648; b = 32'sd30; cmd = `SUB; #10000 subtractor_test(); overflow_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   Overflow", a, b, cmd, res, cout, ovf, zero);

    a = 32'sd2147483647; b = -32'sd3; cmd = `SUB; #10000 subtractor_test(); overflow_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   Overflow", a, b, cmd, res, cout, ovf, zero);

    /**************************** Set Less Than Test ****************************/
    // A > B, A > 0, B > 0
    a = 32'sd4; b = 32'sd2; cmd = `SLT; #10000 stl_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   0", a, b, cmd, res, cout, ovf, zero);

    // A < B, A > 0, B > 0
    a = 32'sd2; b = 32'sd4; cmd = `SLT; #10000 stl_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   1", a, b, cmd, res, cout, ovf, zero);

    // A < B, A < 0, B < 0
    a = -32'sd123; b = -32'sd21; cmd = `SLT; #10000 stl_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   1", a, b, cmd, res, cout, ovf, zero);

    // A > B, A < 0, B < 0
    a = -32'sd23423; b = -32'sd43213; cmd = `SLT; #10000 stl_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   0", a, b, cmd, res, cout, ovf, zero);

    // A > B, A > 0, B < 0
    a = 32'sd23423; b = -32'sd43213; cmd = `SLT; #10000 stl_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   0", a, b, cmd, res, cout, ovf, zero);

    // A < B, A < 0, B > 0
    a = -32'sd23423; b = 32'sd43213; cmd = `SLT; #10000 stl_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   1", a, b, cmd, res, cout, ovf, zero);

    a = 32'sd2147483647; b = -32'sd3; cmd = `SLT; #10000 stl_test(); overflow_test();

    a = -32'sd2147483648; b = 32'sd30; cmd = `SLT; #10000 stl_test(); overflow_test();


    /**************************** XOR Logic Test ****************************/
    a = 32'shF0F0F0F0; b = 32'shF0F0F0F0; cmd = `XOR; #10000 xor_test(); logic_overflow_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   2...", a, b, cmd, res, cout, ovf, zero);
    a = 32'sh0F0F0F0F; b = 32'shF0F0F0F0; cmd = `XOR; #10000 xor_test(); logic_overflow_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   2...", a, b, cmd, res, cout, ovf, zero);
    a = 32'sh0F0F0F0F; b = 32'sh0F0F0F0F; cmd = `XOR; #10000 xor_test(); logic_overflow_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   2...", a, b, cmd, res, cout, ovf, zero);
    a = 32'shFFFFFFFF; b = 32'shFFFFFFFF; cmd = `XOR; #10000 xor_test(); logic_overflow_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   2...", a, b, cmd, res, cout, ovf, zero);
    a = 32'sh00000000; b = 32'sh00000000; cmd = `XOR; #10000 xor_test(); logic_overflow_test();
    // $display("%d    %d     %d  |  %d   %d    %d    %d   |   2...", a, b, cmd, res, cout, ovf, zero);

    /**************************** NAND Logic Test ****************************/
    a = 32'shF0F0F0F0; b = 32'shF0F0F0F0; cmd = `NAND; #10000 nand_test(); logic_overflow_test();
    a = 32'sh0F0F0F0F; b = 32'shF0F0F0F0; cmd = `NAND; #10000 nand_test(); logic_overflow_test();
    a = 32'sh0F0F0F0F; b = 32'sh0F0F0F0F; cmd = `NAND; #10000 nand_test(); logic_overflow_test();
    a = 32'shFFFFFFFF; b = 32'shFFFFFFFF; cmd = `NAND; #10000 nand_test(); logic_overflow_test();
    a = 32'sh00000000; b = 32'sh00000000; cmd = `NAND; #10000 nand_test(); logic_overflow_test();

    /**************************** AND Logic Test ****************************/
    a = 32'shF0F0F0F0; b = 32'shF0F0F0F0; cmd = `AND; #10000 and_test(); logic_overflow_test();
    a = 32'sh0F0F0F0F; b = 32'shF0F0F0F0; cmd = `AND; #10000 and_test(); logic_overflow_test();
    a = 32'sh0F0F0F0F; b = 32'sh0F0F0F0F; cmd = `AND; #10000 and_test(); logic_overflow_test();
    a = 32'shFFFFFFFF; b = 32'shFFFFFFFF; cmd = `AND; #10000 and_test(); logic_overflow_test();
    a = 32'sh00000000; b = 32'sh00000000; cmd = `AND; #10000 and_test(); logic_overflow_test();

    /**************************** NOR Logic Test ****************************/
    a = 32'shF0F0F0F0; b = 32'shF0F0F0F0; cmd = `NOR; #10000 nor_test(); logic_overflow_test();
    a = 32'sh0F0F0F0F; b = 32'shF0F0F0F0; cmd = `NOR; #10000 nor_test(); logic_overflow_test();
    a = 32'sh0F0F0F0F; b = 32'sh0F0F0F0F; cmd = `NOR; #10000 nor_test(); logic_overflow_test();
    a = 32'shFFFFFFFF; b = 32'shFFFFFFFF; cmd = `NOR; #10000 nor_test(); logic_overflow_test();
    a = 32'sh00000000; b = 32'sh00000000; cmd = `NOR; #10000 nor_test(); logic_overflow_test();

    /**************************** OR Logic Test ****************************/
    a = 32'shF0F0F0F0; b = 32'shF0F0F0F0; cmd = `OR; #10000 or_test(); logic_overflow_test();
    a = 32'sh0F0F0F0F; b = 32'shF0F0F0F0; cmd = `OR; #10000 or_test(); logic_overflow_test();
    a = 32'sh0F0F0F0F; b = 32'sh0F0F0F0F; cmd = `OR; #10000 or_test(); logic_overflow_test();
    a = 32'shFFFFFFFF; b = 32'shFFFFFFFF; cmd = `OR; #10000 or_test(); logic_overflow_test();
    a = 32'sh00000000; b = 32'sh00000000; cmd = `OR; #10000 or_test(); logic_overflow_test();

    $display("DUT success?: %b", passed);
  end
endmodule
