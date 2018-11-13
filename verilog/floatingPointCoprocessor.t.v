`include "floatingPointCoprocessor.v"
module fpuTest ();

  reg [31:0] data1, data2;
  reg [2:0] FloatALUop;
  wire [31:0] floatRes;

  coprocessor1 dut(.data1(data1),
                   .data2(data1),
                   .FloatALUop(FloatALUop),
                   .floatRes(floatRes));

  initial begin
    $dumpfile("fpu.vcd");
    $dumpvars();
    data1=32'h3dcccccd;
    data2=32'h3f800000;
    FloatALUop=3'd0; #10
    if(floatRes!=32'h3f8ccccd) begin
      $display("Test 1 failed. We got %h!", floatRes);
    end
    if(floatRes==32'h3f8ccccd) begin
      $display("Test 1 succeeded. We got %h!", floatRes);
    end
  end

endmodule // fpuTest
