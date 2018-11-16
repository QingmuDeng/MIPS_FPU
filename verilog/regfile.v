//------------------------------------------------------------------------------
// MIPS register file
//   width: 32 bits
//   depth: 32 words (reg[0] is static zero register)
//   2 asynchronous read ports
//   1 synchronous, positive edge triggered write port
//------------------------------------------------------------------------------
`include "register.v"
`include "mux.v"
`include "decoders.v"

module regfile
(
  output[31:0]	ReadData1,	// Contents of first register read
  output[31:0]	ReadData2,	// Contents of second register read
  input[31:0]	WriteData,	// Contents to write to register
  input[4:0]	ReadRegister1,	// Address of first register to read
  input[4:0]	ReadRegister2,	// Address of second register to read
  input[4:0]	WriteRegister,	// Address of register to write
  input		RegWrite,	// Enable writing of register when High
  input		Clk		// Clock (Positive Edge Triggered)
);
  wire[31:0] regFile[31:0];
  wire[31:0] decode;

  /******** Read Operation ********/

  assign ReadData1 = regFile[ReadRegister1];//regFile[ReadRegister1];
  assign ReadData2 = regFile[ReadRegister2];

  /******** The end of Read Operation ********/

  /******** Write Operation ********/
  decoder1to32 decoder(.out(decode), .enable(RegWrite), .address(WriteRegister));

  // register32zero register(.q(32'b0), .d(32'b0), .wrenable(decode[0]), .clk(Clk));
  register32zero register(.q(regFile[0]), .d(WriteData), .wrenable(decode[0]), .clk(Clk));
  genvar regNum;
  generate
    for(regNum=1; regNum<32; regNum=regNum+1)begin: mainReg
      register32 register(.q(regFile[regNum]), .d(WriteData), .wrenable(decode[regNum]), .clk(Clk));
    end
  endgenerate
  /******** The end of Write Operation ********/

endmodule


module fpuregfile
(
  output[31:0]	ReadData1,	// Contents of first register read
  output[31:0]	ReadData2,	// Contents of second register read
  input[31:0]	WriteData,	// Contents to write to register
  input[4:0]	ReadRegister1,	// Address of first register to read
  input[4:0]	ReadRegister2,	// Address of second register to read
  input[4:0]	WriteRegister,	// Address of register to write
  input		RegWrite,	// Enable writing of register when High
  input		Clk		// Clock (Positive Edge Triggered)
);
  wire[31:0] regFile[31:0];
  wire[31:0] decode;

  /******** Read Operation ********/

  assign ReadData1 = regFile[ReadRegister1];//regFile[ReadRegister1];
  assign ReadData2 = regFile[ReadRegister2];

  /******** The end of Read Operation ********/

  /******** Write Operation ********/
  decoder1to32 decoder(.out(decode), .enable(RegWrite), .address(WriteRegister));

  // register32zero register(.q(32'b0), .d(32'b0), .wrenable(decode[0]), .clk(Clk));
  // register32zero register(.q(regFile[0]), .d(WriteData), .wrenable(decode[0]), .clk(Clk));
  genvar regNum;
  generate
    for(regNum=0; regNum<32; regNum=regNum+1)begin: mainReg
      register32 register(.q(regFile[regNum]), .d(WriteData), .wrenable(decode[regNum]), .clk(Clk));
    end
  endgenerate
  /******** The end of Write Operation ********/

endmodule
