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
      $display("21: %b", floatRes[21]);
      $display("22: %b", floatRes[22]);
      $display("23: %b", floatRes[23]);
      $display("24: %b", floatRes[24]);
      $display("25: %b", floatRes[25]);
      $display("26: %b", floatRes[26]);
      $display("27: %b", floatRes[27]);
      $display("28: %b", floatRes[28]);
      $display("29: %b", floatRes[29]);
      $display("30: %b", floatRes[30]);
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
    if(floatRes!=32'h44b36333) begin
      $display("Test 5 failed. We got %h!", floatRes);
      $display("We got %b!", floatRes);
    end
    if(floatRes==32'h44b36333) begin
      $display("Test 5 succeeded. We got %h!", floatRes);
    end

    #100;
    data1=32'hc1b80000; // -23
    data2=32'hc5af3800; //-5607
    FloatALUop=3'd0; #10
    if(floatRes!=32'hc5aff000) begin //-5630, getting positive 25.0, 0x41c80000
      $display();
      $display("Test 6 failed. We got %h", floatRes);
      $display("We exp %b", 32'hc5aff000);
      $display("We got %b", floatRes);
      $display("Sign: ");
      $display("31: %b", floatRes[31]);
      $display("Exponent: ");
      $display("30-23: %b%b%b%b%b%b%b%b", floatRes[30], floatRes[29], floatRes[28], floatRes[27], floatRes[26], floatRes[25], floatRes[24], floatRes[23]);
      $display("Exp:   10001011");
      $display("Significand: ");
      $display("22-0: %b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b", floatRes[22], floatRes[21], floatRes[20], floatRes[19], floatRes[18], floatRes[17], floatRes[16], floatRes[15], floatRes[14], floatRes[13], floatRes[12], floatRes[11], floatRes[10], floatRes[9], floatRes[8], floatRes[7], floatRes[6], floatRes[5], floatRes[4], floatRes[3], floatRes[2], floatRes[1], floatRes[0]);
      $display("Exp:  01011111111000000000000");
      $display();
    end
    if(floatRes==32'hc5aff000) begin
      $display("Test 6 succeeded. We got %h!", floatRes);
    end

    #100;
    data1=32'h00FFFFFF; //
    data2=32'h00FFFFFF; //
    FloatALUop=3'd0; #10
    if(floatRes!=32'h017FFFFF) begin //
      $display("Test 7 failed. We got %h!", floatRes);
      $display("We got %b!", floatRes);
    end
    if(floatRes==32'h017FFFFF) begin
      $display("Test 7 succeeded. We got %h!", floatRes);
    end

    #100;
    data1=32'h3f800000; // +1
    data2=32'h3dcccccd; // +0.100000001490116119384765625
    FloatALUop=`SUB; #10
    if(floatRes!=32'h3f666666) begin
      $display("Test 8 failed. We got %h!", floatRes);
      $display("We got %b!", floatRes);
    end
    if(floatRes==32'h3f666666) begin
      $display("Test 8 succeeded. We got %h!", floatRes);
    end

    #100;
    data1=32'h3f800000; // +1
    data2=32'hbdcccccd; // -0.100000001490116119384765625
    FloatALUop=`ADD; #10
    if(floatRes!=32'h3f666666) begin
      $display("Test 9 failed. We got %h!", floatRes);
      $display("We got %b!", floatRes);
    end
    if(floatRes==32'h3f666666) begin
      $display("Test 9 succeeded. We got %h!", floatRes);
    end

    #100;
    data1=32'h404f8d50; // -3.243
    data2=32'h40cdc28f; // +6.43
    FloatALUop=`ADD; #10
    if(floatRes!=32'h404bf7ce) begin //3.1869998
      $display();
      $display("Test 10 failed. We got %h", floatRes);
      $display("We exp %b", 32'h404bf7ce);
      $display("We got %b", floatRes);
      $display("Sign: ");
      $display("31: %b", floatRes[31]);
      $display("Exponent: ");
      $display("30-23: %b%b%b%b%b%b%b%b", floatRes[30], floatRes[29], floatRes[28], floatRes[27], floatRes[26], floatRes[25], floatRes[24], floatRes[23]);
      $display("Exp:   10000000");
      $display("Significand: ");
      $display("22-0: %b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b", floatRes[22], floatRes[21], floatRes[20], floatRes[19], floatRes[18], floatRes[17], floatRes[16], floatRes[15], floatRes[14], floatRes[13], floatRes[12], floatRes[11], floatRes[10], floatRes[9], floatRes[8], floatRes[7], floatRes[6], floatRes[5], floatRes[4], floatRes[3], floatRes[2], floatRes[1], floatRes[0]);
      $display("Exp:  10010111111011111001110");
      $display();

    end
    if(floatRes==32'h404bf7cf) begin
      $display("Test 10 succeeded. We got %h!", floatRes);
    end

  end





endmodule // fpuTest
