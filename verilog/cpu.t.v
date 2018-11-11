`include "cpu.v"
module cpuTest ();
  reg clk;
  reg[1:0] test;

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

    $dumpfile("cpu.vcd");
    $dumpvars();

    test=3;
    $readmemh("hanoi.text", dut.cpuMemory.memory, 0);
    $readmemh("empty.data", dut.cpuMemory.memory, 16'h1000);
    #5000
    if (dut.registerFile.mainReg[5'd2].register.q == 32'h10e)begin//dut.registerFile.mainReg[5'd1].register.q == 32'h1 &&  && dut.registerFile.mainReg[5'd4].register.q == 32'h1 && dut.registerFile.mainReg[5'd5].register.q == 32'h8) begin
      $display("Test 3 Passed");
    end
    resetRegFile();

    #500


    $finish();

  end

endmodule //
