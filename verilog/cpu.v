`include "alu.v"
`include "memory.v"
`include "lshift2.v"
`include "instructionDecoder.v"
`include "mux.v"
`include "signextend.v"
`include "regfile.v"
`include "dff.v"
`include "multiplier.v"
`include "floatingPointCoprocessor.v"

module cpu(
  input clk
    );

wire [31:0] pcIn, pcOut, instruction, dataOut;
wire [31:0] opA, opB;
wire [4:0] regWrAddress;
wire [31:0] writeData;
wire [31:0] signExtended;
wire [31:0] branchALUin;
wire [27:0] jumpShifted;
wire [31:0] aluResult;
wire [31:0] readOut1, readOut2;
wire [1:0] pcMuxSelect, regWriteSelectControl, muxB_en, muxWd3_en;
wire dm_we, regWr_en, muxAselect, multiplyEn, zeroFlag;
wire [31:0] pcPlusFour;
wire [31:0] branchAddress;
wire [2:0] ALUop;
wire [31:0] Hi, Lo, floatRes;
// wire [4:0] RsFsSeclect;

wire [31:0] float_readOut1, float_readOut2, float_writeData, dataMemIn;
wire [4:0] float_regWrAddress;
wire float_regWrite, floatRegWRSelect, floatWriteAddrSelect, dmDataSelect;
wire [4:0] fs, ftrt, fd;
assign fs = instruction[15:11];
assign ftrt = instruction[20:16];
assign fd = instruction[10:6];

mux2to1by5 floatAddrMux(
  .address(floatWriteAddrSelect),
  .input0(fd),
  .input1(ftrt),
  .out(float_regWrAddress)
  );

mux2to1by32 floatDataMux(
  .address(floatRegWRSelect),
  .input0(dataOut),
  .input1(floatRes),
  .out(float_writeData)
  );

fpuregfile floatRegFile(
  .Clk(clk),
  .RegWrite(float_regWrite),
  .WriteRegister(float_regWrAddress),
  .ReadRegister1(fs),
  .ReadRegister2(ftrt),
  .WriteData(float_writeData),
  .ReadData1(float_readOut1),
  .ReadData2(float_readOut2)
  );

mux2to1by32 dataMemoryMux(
  .address(dmDataSelect),
  .input0(readOut2),
  .input1(float_readOut2),
  .out(dataMemIn)
  );

coprocessor1 fpu(.data1(float_readOut1),
                 .data2(float_readOut2),
                 .FloatALUop(ALUop),
                 .floatRes(floatRes));

memory cpuMemory (
  .clk(clk),
  .dataMemorydataOut(dataOut),
  .instructionOut(instruction),
  .InstructionAddress(pcOut), // initially we set these to [15:0], address are not full 32 bits???
  .dataMemoryAddress(aluResult), //// address are not full 32 bits???
  .dataMemorywriteEnable(dm_we),
  .dataMemorydataIn(dataMemIn)
  );


programCounter pc (
  .d(pcIn),
  .clk(clk),
  .q(pcOut)
  );

mux4to1by32 muxPC(
  .address(pcMuxSelect),
  .input0(pcPlusFour),
  .input1({pcPlusFour[31:28], jumpShifted}),
  .input2(readOut1),
  .input3(branchAddress),
  .out(pcIn)
  );

mux4to1by5 muxRegWriteSelect(
  .address(regWriteSelectControl),
  .input0(instruction[20:16]),
  .input1(5'h1F),
  .input2(instruction[15:11]),
  .input3(instruction[10:6]),
  .out(regWrAddress)
  );

// mux2to1by32 rsfs(
//   .address(FloatingPointEn),
//   .input0(instruction[25:21]),
//   .input1(instruction[15:11]),
//   .out(RsFsSeclect)
//   );

mux4to1by32 muxB(
    .address(muxB_en),
    .input0(signExtended),
    .input1(readOut2),
    .input2(32'd4),
    .out(opB)
    );

mux2to1by32 muxA(
  .address(muxAselect),
  .input0(readOut1),
  .input1(pcOut),
  .out(opA)
  );

mux4to1by32 muxWD3(
  .address(muxWd3_en),
  .input0(dataOut),
  .input1(aluResult),
  .input2(Hi),
  .input3(Lo),
  .out(writeData)
  );

signExtend signExtension(
  .immediate(instruction[15:0]),
  .extended(signExtended)
  );

lshift32 shiftSignExt(
  .immediate(signExtended),
  .lshifted(branchALUin)
  );

lshift28 shiftPC(
  .immediate(instruction[25:0]),
  .lshifted(jumpShifted)
  );

ALU OpALU(
  .operandA(opA),
  .operandB(opB),
  .command(ALUop),
  .overflow(),
  .zero(zeroFlag),
  .carryout(),
  .result(aluResult)
  );

regfile registerFile(
  .Clk(clk),
  .RegWrite(regWr_en),
  .WriteRegister(regWrAddress),
  .ReadRegister1(instruction[25:21]),
  .ReadRegister2(instruction[20:16]),
  .WriteData(writeData),
  .ReadData1(readOut1),
  .ReadData2(readOut2)
  );

instructionDecoder opDecoder(
  .opcode(instruction[31:26]),
  .functcode(instruction[5:0]),
  .regWrite(regWr_en),
  .muxA_en(muxAselect),
  .zero(zeroFlag),
  .dm_we(dm_we),
  .muxWD3_en(muxWd3_en),
  .multiplyEn(multiplyEn),
  .muxB_en(muxB_en),
  .regWriteAddSelect(regWriteSelectControl),
  .floatWriteAddrSelect(floatWriteAddrSelect),
  .floatRegWrite(float_regWrite),
  .floatRWSelect(floatRegWRSelect),
  .dmDataSelect(dmDataSelect),
  .muxPC(pcMuxSelect),
  .ALUop(ALUop)
  );

ALU pcAddFour(
  .operandA(32'd4),
  .operandB(pcOut),
  .command(3'd0), // Add Command
  .overflow(),
  .zero(),
  .carryout(),
  .result(pcPlusFour)
  );

ALU pcBranch(
  .operandA(branchALUin),
  .operandB(pcPlusFour),
  .command(3'd0), // Add Command
  .overflow(),
  .zero(),
  .carryout(),
  .result(branchAddress)
  );

multiply X(.enable(multiplyEn),
           .A(opA),
           .B(opB),
           .Hi(Hi),
           .Lo(Lo));

endmodule
