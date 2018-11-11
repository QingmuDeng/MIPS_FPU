`include "cpu.v"
module cpuTest ();
  reg clk;

  initial clk=0;
  always #5 clk=~clk;

  cpu dut(clk);

  integer regfAddress;
  task resetRegFile;
    #100
    for(regfAddress=1; regfAddress<=31; regfAddress=regfAddress+1) begin
      dut.muxWD3.out = 32'b0;
      dut.muxRegWriteSelect.out = regfAddress;
      dut.opDecoder.regWrite = 1;
      dut.pc.q = 32'b0;
      #20;
    end
  endtask

initial begin

    $dumpfile("cpu00.vcd");
    $dumpvars();

    $readmemh("test1.text", dut.cpuMemory.memory, 0);
    #250; // Run Program

    if (dut.registerFile.mainReg[5'd12].register.q == 32'h38) begin
      $display(dut.registerFile.mainReg[5'd12].register.q);
      $display("Test 1 Passed");
    end
    resetRegFile();
    #500


    $finish();

  end

endmodule //
