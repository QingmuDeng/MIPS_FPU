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

    $dumpfile("cpu10.vcd");
    $dumpvars();

    $readmemh("test3.text", dut.cpuMemory.memory, 0);
    #5000
    // if (dut.cpuMemory.memory.)
    if (dut.registerFile.mainReg[5'd8].register.q == 32'h65 && dut.registerFile.mainReg[5'd9].register.q == 32'ha && dut.registerFile.mainReg[5'd10].register.q == 32'h65 && dut.registerFile.mainReg[5'd11].register.q == 32'h2a) begin
      $display("Test 3 Passed");
    end
    resetRegFile();
    #500


    $finish();

  end

endmodule //
