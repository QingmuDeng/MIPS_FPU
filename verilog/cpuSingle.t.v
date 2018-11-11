`include "cpu.v"
module cpuTest ();
  reg clk;
  reg[1:0] test;

  initial clk=0;
  always #1 clk=~clk;

  cpu dut(clk);
  // initial dut.pcIn=0;
  // dut.registerFile.register29=16'h3ffc;

  // assign dut.registerFile.mainReg[5'd29].register.d=16'h3ffc;


  // reg regfreset=0;
  integer index;
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
    // $display(dut.registerFile.register.q);
    // $display(dut.registerFile.mainReg[5'd1].register.q);
    // $display(dut.registerFile.mainReg[5'd2].register.q);
    // $display(dut.registerFile.mainReg[5'd3].register.q);
    // $display(dut.registerFile.mainReg[5'd4].register.q);
    // $display(dut.registerFile.mainReg[5'd5].register.q);
    // $display(dut.registerFile.mainReg[5'd6].register.q);
    // $display(dut.registerFile.mainReg[5'd7].register.q);
    // $display(dut.registerFile.mainReg[5'd8].register.q);
    // $display(dut.registerFile.mainReg[5'd9].register.q);
    // $display(dut.registerFile.mainReg[5'd10].register.q);
    // $display(dut.registerFile.mainReg[5'd11].register.q);
    // $display(dut.registerFile.mainReg[5'd12].register.q);
    // $display(dut.registerFile.mainReg[5'd13].register.q);
    // $display(dut.registerFile.mainReg[5'd14].register.q);
    // $display(dut.registerFile.mainReg[5'd15].register.q);
    // $display(dut.registerFile.mainReg[5'd16].register.q);
    // $display(dut.registerFile.mainReg[5'd17].register.q);
    // $display(dut.registerFile.mainReg[5'd18].register.q);
    // $display(dut.registerFile.mainReg[5'd19].register.q);
    // $display(dut.registerFile.mainReg[5'd20].register.q);
    // $display(dut.registerFile.mainReg[5'd21].register.q);
    // $display(dut.registerFile.mainReg[5'd22].register.q);
    // $display(dut.registerFile.mainReg[5'd23].register.q);
    // $display(dut.registerFile.mainReg[5'd24].register.q);
    // $display(dut.registerFile.mainReg[5'd25].register.q);
    // $display(dut.registerFile.mainReg[5'd26].register.q);
    // $display(dut.registerFile.mainReg[5'd27].register.q);
    // $display(dut.registerFile.mainReg[5'd28].register.q);
    // $display(dut.registerFile.mainReg[5'd29].register.q);
    // $display(dut.registerFile.mainReg[5'd30].register.q);
    // $display(dut.registerFile.mainReg[5'd31].register.q);

initial begin

    $dumpfile("cpuSingle.vcd");
    $dumpvars();

    $readmemh("fib.text", dut.cpuMemory.memory, 0);
    #250000; // Run Program


    $finish();

  end

endmodule //
