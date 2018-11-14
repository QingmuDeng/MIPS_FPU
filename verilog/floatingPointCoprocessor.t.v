`include "floatingPointCoprocessor.v"
module fpuTest ();

  reg [31:0] data1, data2;
  reg [2:0] FloatALUop;
  wire [31:0] floatRes;

  coprocessor1 dut(.data1(data1),
                   .data2(data2),
                   .FloatALUop(FloatALUop),
                   .floatRes(floatRes));

  initial begin
    $dumpfile("fpu.vcd");
    $dumpvars();
    data1=32'h42C80000;
    data2=32'h41C80000;
    FloatALUop=3'd0; #10
    if(floatRes!=32'h42fa0000) begin
      $display("Test 1 failed. We got %h!", floatRes);
      $display("We got %b!", floatRes);
    end
    if(floatRes==32'h42fa0000) begin
      $display("Test 1 succeeded. We got %h!", floatRes);
    end

    #100;
    data1=32'h3f800000;
    data2=32'h3f800000;
    FloatALUop=3'd0; #10
    if(floatRes!=32'h40000000) begin
      $display("Test 2 failed. We got %h!", floatRes);
      $display("We got %b!", floatRes);
    end
    if(floatRes==32'h40000000) begin
      $display("Test 2 succeeded. We got %h!", floatRes);
    end


    #100;
    data1=32'h3f800000; // +1
    data2=32'h3dcccccd; // +0.100000001490116119384765625
    FloatALUop=3'd0; #10
    if(floatRes!=32'h3f8ccccd) begin
      $display("Test 3 failed. We got %h!", floatRes);
      $display("We got %b!", floatRes);
    end
    if(floatRes==32'h3f8ccccd) begin
      $display("Test 3 succeeded. We got %h!", floatRes);
    end


    #100;
    data1=32'h40133333; // +2.2999999523162841796875
    data2=32'h3ecccccd; // +0.4000000059604644775390625
    FloatALUop=3'd0; #10
    if(floatRes!=32'h402ccccd) begin
      $display("Test 4 failed. We got %h!", floatRes);
      $display("We got %b!", floatRes);
    end
    if(floatRes==32'h402ccccd) begin
      $display("Test 4 succeeded. We got %h!", floatRes);
    end

    #100;
    data1=32'h44b30000; // +1432
    data2=32'h40466666; // +3.099999904632568359375
    FloatALUop=3'd0; #10
    if(floatRes!=32'h44ada000) begin
      $display("Test 5 failed. We got %h!", floatRes);
      $display("We got %b!", floatRes);
    end
    if(floatRes==32'h44ada000) begin
      $display("Test 5 succeeded. We got %h!", floatRes);
    end

    #100;
    data1=32'hc1b80000; // -23
    data2=32'hc5af3800; //-5607
    FloatALUop=3'd0; #10
    if(floatRes!=32'hc5aff000) begin //-5630, getting positive 25.0, 0x41c80000
      $display("Test 6 failed. We got %h!", floatRes);
      $display("We got %b!", floatRes);
    end
    if(floatRes==32'hc5aff000) begin
      $display("Test 6 succeeded. We got %h!", floatRes);
    end

  end





endmodule // fpuTest
