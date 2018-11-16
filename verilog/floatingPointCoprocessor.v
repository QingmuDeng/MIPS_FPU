`include "subtractor.v"
`include "variableShifter.v"
`include "signextend.v"
`include "alu.v"
`include "mux.v"


module coprocessor1 (
  input [31:0] data1, data2,
  input[2:0] FloatALUop,
  output reg [31:0] floatRes
  );

  wire [7:0] exponentDiff, exponentResult;
  wire [31:0] shiftedSignificand;
  wire [31:0] significandA, significandB;
  wire [31:0] floatA, floatB, FloataluResult, floatResult;
  // wire FloatALUop;
  wire nonShiftMux, signExtendA, signExtendB;
  reg shiftMux;

  wire xorSign;
  wire [31:0] exponentALUResult, rightShifteddalu, notAluRes, correctFloataluResult;
  wire [31:0] normalizedFloataluResult;
  wire [31:0] exponentChange, aluOpA, aluOpB;


  // case (exponentDiff[7]):
  //   0: begin
  //     shiftMux = 0;
  //   end
  //   1: begin
  //     shiftMux = 1;
  //   end
  //   <3
  //
  // endcase

  // xor signCheck(xorSign, signExtendB, FloataluResult[31]);

  not floatNormalizeInv(nonShiftMux, shiftMux);

  Subtractor subtractor(.A_exp(data1[30:23]),
                        .B_exp(data2[30:23]),
                        .diff(exponentDiff));

  mux2to1by32 FloatmuxA(
    .address(nonShiftMux),
    .input0({9'b000000001, data1[22:0]}),
    .input1({9'b000000001, data2[22:0]}),
    .out(significandA)
  );

  mux2to1by32 FloatmuxB(
    .address(shiftMux),
    .input0({9'b000000001, data1[22:0]}),
    .input1({9'b000000001, data2[22:0]}),
    .out(significandB)
  );

  variableShifter shiftPlease(.significand(significandA),
                              .shamt(exponentDiff),
                              .rshifted(shiftedSignificand));
  mux2to1by1 FloatSignmuxA(
    .address(nonShiftMux),
    .input0(data1[31]),
    .input1(data2[31]),
    .out(signExtendA)
  );

  mux2to1by1 FloatSignmuxB(
    .address(shiftMux),
    .input0(data1[31]),
    .input1(data2[31]),
    .out(signExtendB)
  );

  signExtendFloat extendA(.sign(signExtendA), .significand(shiftedSignificand), .extended(floatA));
  signExtendFloat extendB(.sign(signExtendB), .significand(significandB), .extended(floatB));

  ALU FloatALU(
    .operandA(floatA),
    .operandB(floatB),
    .command(FloatALUop),
    .overflow(),
    .zero(),
    .carryout(),
    .result(FloataluResult)
  );


  mux2to1by32 addSubtract(
    .address(FloataluResult[31]),
    .input0(FloataluResult),
    .input1(notAluRes + 32'b1),
    .out(correctFloataluResult)
    );

  mux2to1by8 ExponentSelect(
    .address(shiftMux),
    .input0(data1[30:23]),
    .input1(data2[30:23]),
    .out(exponentResult)
  );

  ALU exponentALU(
    .operandA(exponentChange),//{31'b0, (correctFloataluResult[24]&~(|(correctFloataluResult[31:25])))}),
    .operandB({{24{1'b0}}, exponentResult}),
    .command(`ADD),//FloatALUop),
    .overflow(),
    .zero(),
    .carryout(),
    .result(exponentALUResult)
  );

  normalizer normal(
    .FloataluResult(correctFloataluResult),
    .normalizedFloataluResult(normalizedFloataluResult),
    .exponentChange(exponentChange)
  );

    assign notAluRes = ~FloataluResult;
  always @ ( * ) begin

    if (FloatALUop[0] && exponentDiff[7]==1'b0 && |exponentDiff[6:0]!=1'b0) begin
      floatRes <= {floatB[31], exponentALUResult[7:0], normalizedFloataluResult[22:0]};
    end
    else if (FloatALUop[0] && exponentDiff[7]==1'b0 && |exponentDiff[6:0]==1'b0) begin
      floatRes <= {~floatB[31], exponentALUResult[7:0], normalizedFloataluResult[22:0]};
    end
    else if (FloatALUop[0] && exponentDiff[7] == 1'b1) begin
      floatRes <= {~floatB[31], exponentALUResult[7:0], normalizedFloataluResult[22:0]};
    end
    else begin
      floatRes <= {FloataluResult[31], exponentALUResult[7:0], normalizedFloataluResult[22:0]};
    end

    // floatRes <= {FloataluResult[31], exponentALUResult[7:0], FloataluResult[22:0]};

    if (exponentDiff[7] == 1'b0) begin
      shiftMux <= 0;
    end
    else begin
      shiftMux <= 1;
    end

  end

endmodule
