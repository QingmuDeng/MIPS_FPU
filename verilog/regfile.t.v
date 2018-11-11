//------------------------------------------------------------------------------
// Test harness validates hw4testbench by connecting it to various functional
// or broken register files, and verifying that it correctly identifies each
//------------------------------------------------------------------------------

`include "regfile.v"

module hw4testbenchharness();

  wire[31:0]	ReadData1;	// Data from first register read
  wire[31:0]	ReadData2;	// Data from second register read
  wire[31:0]	WriteData;	// Data to write to register
  wire[4:0]	ReadRegister1;	// Address of first register to read
  wire[4:0]	ReadRegister2;	// Address of second register to read
  wire[4:0]	WriteRegister;  // Address of register to write
  wire		RegWrite;	// Enable writing of register when High
  wire		Clk;		// Clock (Positive Edge Triggered)

  reg		begintest;	// Set High to begin testing register file
  wire  	endtest;    	// Set High to signal test completion
  wire		dutpassed;	// Indicates whether register file passed tests

  // Instantiate the register file being tested.  DUT = Device Under Test
  regfile DUT
  (
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .WriteData(WriteData),
    .ReadRegister1(ReadRegister1),
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),
    .RegWrite(RegWrite),
    .Clk(Clk)
  );

  // Instantiate test bench to test the DUT
  hw4testbench tester
  (
    .begintest(begintest),
    .endtest(endtest),
    .dutpassed(dutpassed),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .WriteData(WriteData),
    .ReadRegister1(ReadRegister1),
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),
    .RegWrite(RegWrite),
    .Clk(Clk)
  );

  // Test harness asserts 'begintest' for 1000 time steps, starting at time 10
  initial begin
    begintest=0;
    #10;
    begintest=1;
    #1000;
  end

  // Display test results ('dutpassed' signal) once 'endtest' goes high
  always @(posedge endtest) begin
    $display("DUT passed?: %b", dutpassed);
  end

endmodule


//------------------------------------------------------------------------------
// Your HW4 test bench
//   Generates signals to drive register file and passes them back up one
//   layer to the test harness. This lets us plug in various working and
//   broken register files to test.
//
//   Once 'begintest' is asserted, begin testing the register file.
//   Once your test is conclusive, set 'dutpassed' appropriately and then
//   raise 'endtest'.
//------------------------------------------------------------------------------

module hw4testbench
(
// Test bench driver signal connections
input	   		begintest,	// Triggers start of testing
output reg 		endtest,	// Raise once test completes
output reg 		dutpassed,	// Signal test result

// Register File DUT connections
input[31:0]		ReadData1,
input[31:0]		ReadData2,
output reg[31:0]	WriteData,
output reg[4:0]		ReadRegister1,
output reg[4:0]		ReadRegister2,
output reg[4:0]		WriteRegister,
output reg		RegWrite,
output reg		Clk
);
  integer address, seed;

  task reset_all;
    for(address=0; address<=31; address=address+1) begin
      WriteRegister = address;
      WriteData = 32'd0;
      RegWrite = 1;
      #5 Clk=1; #5 Clk=0; #5 Clk=1; #5 Clk=0;
    end
  endtask

  // Initialize register driver signals
  initial begin
    WriteData=32'd0;
    ReadRegister1=5'd0;
    ReadRegister2=5'd0;
    WriteRegister=5'd0;
    RegWrite=0;
    Clk=0;
  end

  // Once 'begintest' is asserted, start running test cases
  always @(posedge begintest) begin
    endtest = 0;
    dutpassed = 1;
    #10

  // Test Case 1:
  //   Write '42' to register 2, verify with Read Ports 1 and 2
  //   (Passes because example register file is hardwired to return 42)
  reset_all();
  WriteRegister = 5'd2;
  WriteData = 32'd42;
  RegWrite = 1;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;	// Generate single clock pulse

  // Verify expectations and report test result
  if((ReadData1 !== 42) || (ReadData2 !== 42)) begin
    dutpassed = 0;	// Set to 'false' on failure
    $display("Test Case 1 Failed, WPORT: %d; RPORT1: %d, %h; RPORT2: %d, %h", WriteRegister, ReadRegister1, ReadData1, ReadRegister2, ReadData2);
  end

  // Test Case 2:
  //   Write '15' to register 2, verify with Read Ports 1 and 2
  //   (Fails with example register file, but should pass with yours)
  reset_all();
  WriteRegister = 5'd2;
  WriteData = 32'd15;
  RegWrite = 1;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;

  if((ReadData1 !== 15) || (ReadData2 !== 15)) begin
    dutpassed = 0;
    $display("Test Case 2 Failed, WPORT: %d; RPORT1: %d, %h; RPORT2: %d, %h", WriteRegister, ReadRegister1, ReadData1, ReadRegister2, ReadData2);
  end

  // Test Case 3:
  //   Read register zero with Read Ports 1 and 2 and verify that
  //   the read result is actually zero despite any write operation
  reset_all();
  WriteRegister = 5'd0;
  WriteData = 32'd15;
  RegWrite = 1;
  ReadRegister1 = 5'd0;
  ReadRegister2 = 5'd0;
  #5 Clk=1; #5 Clk=0;

  if((ReadData1 !== 0) || (ReadData2 !== 0)) begin
    dutpassed = 0;
    $display("Test Case 3 Failed, WPORT: %d; RPORT1: %d, %h; RPORT2: %d, %h", WriteRegister, ReadRegister1, ReadData1, ReadRegister2, ReadData2);
  end

  // Test Case 4:
  //   Test whether Write Enable is broken / ignored by writing to
  //   a register with Write Enable false. Verify by reading that
  //   register back from Read Ports 1 and 2.
  reset_all();
  WriteRegister = $random%31+1;
  WriteData = 32'hFF;
  RegWrite = 0;
  ReadRegister1 = WriteRegister;
  ReadRegister2 = WriteRegister;
  #5 Clk=1; #5 Clk=0;

  if((ReadData1 == WriteData) || (ReadData2 == WriteData)) begin
    dutpassed = 0;
    $display("Test Case 4 Failed, WPORT: %d; RPORT1: %d, %h; RPORT2: %d, %h", WriteRegister, ReadRegister1, ReadData1, ReadRegister2, ReadData2);
  end

  // Test Case 5:
  //   Test whether decoder is broken by checking whether the write
  //   spilled into other registers. Check by reading the registers back
  //   through Read Ports 1 and 2
  reset_all();
  WriteRegister = $random%31+1;
  WriteData = 32'hEE;
  RegWrite = 1;
  for(address=0; address<=16; address=address+1) begin: decoderCheck
    ReadRegister1 = address;
    ReadRegister2 = address+15;
    #5 Clk=1; #5 Clk=0;

    // If the Read port is different from the write port but the register data is the same
    if(((ReadData1 == WriteData) || (ReadData2 == WriteData)) && !((ReadRegister1 == WriteRegister) || (ReadRegister2 == WriteRegister))) begin
      dutpassed = 0;
      $display("Test Case 5 Failed, WPORT: %d; RPORT1: %d, %h; RPORT2: %d, %h", WriteRegister, ReadRegister1, ReadData1, ReadRegister2, ReadData2);
    end
  end

  // Test Case 6:
  //   Test whether Port 2 is broken and always reads register as
  //   the same number everytime
  reset_all();
  for(address=1; address<=31; address=address+1) begin: Port2_Check
    WriteRegister = 5'd3;
    WriteData = $urandom%(32'hFFFFFFFF)+1;
    RegWrite = 1;
    ReadRegister2 = 5'd3;
    #5 Clk=1; #5 Clk=0;
    if(ReadData2 != WriteData) begin
      dutpassed = 0;
      $display("Test Case 6 Failed, WPORT: %d; RPORT1: %d, %h; RPORT2: %d, %h", WriteRegister, ReadRegister1, ReadData1, ReadRegister2, ReadData2);
    end
  end

  // Test Case 7:
  //   Test whether Port 1 is broken and always reads register as
  //   the same number everytime
  reset_all();
  for(address=1; address<=31; address=address+1) begin: Port1_Check
    WriteRegister = 5'd2;
    WriteData = $urandom%(32'hFFFFFFFF)+1;
    RegWrite = 1;
    ReadRegister1 = 5'd2;
    #5 Clk=1; #5 Clk=0;
    if(ReadData1 != WriteData) begin
      dutpassed = 0;
      $display("Test Case 7 Failed, WPORT: %d; RPORT1: %d, %h; RPORT2: %d, %h", WriteRegister, ReadRegister1, ReadData1, ReadRegister2, ReadData2);
    end
  end

  // Test Case 8:
  //   Test whether Write happens even if no rising clock edge occurs
  //   Verify by reading back from Read Ports 1 and 2
  reset_all();
  for(address=1; address<=31; address=address+1) begin: Clock_check
    WriteRegister = address;
    WriteData = $urandom%(32'hFFFFFFFF)+1;
    RegWrite = 1;
    ReadRegister1 = address;
    ReadRegister2 = address;
    if(ReadData1 == WriteData || ReadData2 == WriteData) begin
      dutpassed = 0;
      $display("Test Case 8 Failed before clock edge, WPORT: %d; RPORT1: %d, %h; RPORT2: %d, %h", WriteRegister, ReadRegister1, ReadData1, ReadRegister2, ReadData2);
    end
    #5 Clk=1; #5 Clk=0;
    if(!(ReadData1 == WriteData && ReadData2 == WriteData)) begin
      dutpassed = 0;
      $display("Test Case 8 Failed after clock edge, WPORT: %d; RPORT1: %d, %h; RPORT2: %d, %h", WriteRegister, ReadRegister1, ReadData1, ReadRegister2, ReadData2);
    end
  end

  // Test Case 9:
  //   Test whether Read Ports 1 and 2 are independent of each other
  //   rather than just a copy of the other. Verify by reading two
  //  different ports with different values at the same time and
  // compare results
  reset_all();
  for(address=0; address<=16; address=address+1) begin: RP1_RP2_Redundancy
    WriteRegister = address;
    WriteData = 32'hBBBBBBBB;
    RegWrite = 1;
    #5 Clk=1; #5 Clk=0;
    WriteRegister = address+15;
    WriteData = 32'hAAAAAAAA;
    RegWrite = 1;
    #5 Clk=1; #5 Clk=0;
    ReadRegister1 = address;
    ReadRegister2 = address+15;

    // If the Read port is different from the write port but the register data is the same
    if(ReadData1 == ReadData2) begin
      dutpassed = 0;
      $display("Test Case 5 Failed, WPORT: %d; RPORT1: %d, %h; RPORT2: %d, %h", WriteRegister, ReadRegister1, ReadData1, ReadRegister2, ReadData2);
    end
  end

  // All done!  Wait a moment and signal test completion.
  #5
  endtest = 1;

end

endmodule
