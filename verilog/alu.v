`ifndef _alu_
`define _alu_

`define NOT not //#10
`define NOT3 not //#30
`define NAND nand //#20
`define NOR nor //#20
`define NOR32 nor //#320
`define AND and// #30
`define AND4 and //#//50 // 4 inputs plus inverter
`define OR or //#30
`define OR3 or //#40
`define OR5 or //#60 // 5 inputs plus inverter
`define XOR xor //#30
`define AND3 and //#40 // 3 inputs plus inverter

`define ADD  3'd0
`define SUB  3'd1
`define XORSIGNAL  3'd2
`define SLT  3'd3
`define ANDSIGNAL  3'd4
`define NANDSIGNAL 3'd5
`define NORSIGNAL  3'd6
`define ORSIGNAL   3'd7

`include "adder_1bit.v"

// One Bit of the ALU
module ALU_slice
(
  output result,  // 2's complement sum of a and b
  output carryout,  // Carry out of the summation of a and b
  input a,     // First operand in 2's complement format
  input b,     // Second operand in 2's complement format
  input carryin,     // carryin for subtraction in the future,
  input slt,   // for set less than
  input invertB,
  input invertOut,
  input[2:0] muxindex
);
  wire bOut;
  wire addSubtract, xorgate, andgate, nandgate, norgate, orgate, norOut, nandOut;

  `XOR invB(bOut, b, invertB);
  structuralFullAdder adder(.sum(addSubtract), .carryout(carryout), .a(a), .b(bOut), .carryin(carryin));

  `NOR AnorB(norgate, a, b);
  `XOR AxorB(xorgate, a, b);
  `NAND AnandB(nandgate, a, b);
  `XOR invOutNor(norOut, invertOut, norgate);
  `XOR invOutNand(nandOut, invertOut, nandgate);

  multiplexer mux(result, addSubtract, xorgate, slt, nandOut, norOut, muxindex);
endmodule

// Slice for most significant bit in ALU, needed to for the Set Less Than Operation
module ALU_slice_MSB
(
  output result,  // 2's complement sum of a and b
  output carryout,  // Carry out of the summation of a and b
  output set,
  input a,     // First operand in 2's complement format
  input b,     // Second operand in 2's complement format
  input carryin,     // carryin for subtraction in the future,
  input slt,   // for set less than
  input invertB,
  input invertOut,
  input[2:0] muxindex
);
  wire bOut;
  wire xorgate, andgate, nandgate, norgate, orgate, norOut, nandOut;

  `XOR invB(bOut, b, invertB);
  structuralFullAdder adder(.sum(set), .carryout(carryout), .a(a), .b(bOut), .carryin(carryin));

  `NOR AnorB(norgate, a, b);
  `XOR AxorB(xorgate, a, b);
  `NAND AnandB(nandgate, a, b);
  `XOR invOutNor(norOut, invertOut, norgate);
  `XOR invOutNand(nandOut, invertOut, nandgate);

  multiplexer mux(result, set, xorgate, slt, nandOut, norOut, muxindex);
endmodule

// Lookup table: keeps track of when to invert the second input and/or output
module ALUcontrolLUT
(
  output reg[2:0] 	muxindex,
  output reg	invertB,
  output reg invertOut,
  input[2:0]	ALUcommand
);

  always @(ALUcommand) begin
    case (ALUcommand)
      `ADD:        begin muxindex = 0; invertB=0; invertOut=0; end
      `SUB:        begin muxindex = 0; invertB=1; invertOut=0; end
      `XORSIGNAL:  begin muxindex = 1; invertB=0; invertOut=0; end
      `SLT:        begin muxindex = 2; invertB=1; invertOut=0; end
      `ANDSIGNAL:  begin muxindex = 3; invertB=0; invertOut=1; end
      `NANDSIGNAL: begin muxindex = 3; invertB=0; invertOut=0; end
      `NORSIGNAL:  begin muxindex = 4; invertB=0; invertOut=0; end
      `ORSIGNAL:   begin muxindex = 4; invertB=0; invertOut=1; end
    endcase
  end
endmodule

// Bit-Slice ALU for 32 bits
module ALU
(
output[31:0]  result,
output        carryout,
output        zero,
output        overflow,
input[31:0]   operandA,
input[31:0]   operandB,
input[2:0]    command
);

  wire[30:0] Cout;
  wire [2:0] muxindex, ALUcommand;
  wire invertB, invertOut, set_out, set_in, ovf_internal, opOvf, addMode, subSltMode, ncmd0, ncmd1, ncmd2;
  ALUcontrolLUT control(.muxindex(muxindex), .invertB(invertB), .invertOut(invertOut), .ALUcommand(command));

  ALU_slice aluOneBit0(.result(result[0]), .carryout(Cout[0]), .a(operandA[0]), .b(operandB[0]), .carryin(invertB), .slt(set_in), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));

  // Generate results for all bits except first and last
  genvar bit;
  generate
    for (bit=1; bit<31; bit=bit+1) begin: genALUs
      ALU_slice aluOneBit(.result(result[bit]), .carryout(Cout[bit]), .a(operandA[bit]), .b(operandB[bit]), .carryin(Cout[bit-1]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));
    end
  endgenerate

  // ALU MSB with adder/subtractor results wired out for SLT logic
  ALU_slice_MSB aluOneBit31(.result(result[31]), .carryout(carryout), .set(set_out), .a(operandA[31]), .b(operandB[31]), .carryin(Cout[30]), .slt(1'b0), .invertB(invertB), .invertOut(invertOut), .muxindex(muxindex));

  // Ensures there is no overflow when performing a logic operation
  `NOT cmd0inv(ncmd0, command[0]);
  `NOT cmd1inv(ncmd1, command[1]);
  `NOT cmd2inv(ncmd2, command[2]);
  `AND modeAdd(addMode, ncmd2, ncmd1, ncmd0);
  `AND3 modeSubSlt(subSltMode, ncmd2, command[0]);
  `OR3 operation_ovf(opOvf, addMode, subSltMode);

  `XOR ovf(ovf_internal, carryout, Cout[30]);
  `AND ovf_out(overflow, ovf_internal, opOvf);

  // Set is true when A<B and false otherwise
  `XOR slt_logic(set_in, overflow, set_out);

  // NOR all the results gives the zero output`
  `NOR32 zero_out(zero, result[0],result[1],result[2],result[3],result[4],result[5],result[6],result[7],result[8],result[9],result[10],result[11],result[12],result[13],result[14],result[15],result[16],result[17],result[18],result[19],result[20],result[21],result[22],result[23],result[24],result[25],result[26],result[27],result[28],result[29],result[30],result[31]);
endmodule

// Multiplexer with 3 select inputs
module multiplexer
(
  output out,
  input a0, a1, a2, a3, a4,
  input[2:0] select
);
  wire ns0, ns1, ns2;
  wire addWire, subtractWire, xorWire, sltWire;
  wire andWire, nandWire, norWire, orWire;

  `NOT s0inv(ns0, select[0]);
  `NOT s1inv(ns1, select[1]);
  `NOT s2inv(ns2, select[2]);

  `AND4 andgateAdd(addWire, ns2, ns1, ns0, a0);
  `AND4 andgateXor(xorWire, ns2, ns1, select[0], a1);
  `AND4 andgateSlt(sltWire, ns2, select[1], ns0, a2);
  `AND4 andgateNand(nandWire, ns2, select[1], select[0], a3);
  `AND4 andgateNor(norWire, select[2], ns1, ns0, a4);

  `OR5 orgateOut(out, addWire, xorWire, sltWire, nandWire, norWire);
endmodule

`endif
