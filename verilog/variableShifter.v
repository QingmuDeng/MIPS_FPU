module variableShifter(
  input[31:0] significand,
  input [7:0] shamt,
  output[31:0] rshifted
);

  assign rshifted = significand>>shamt;

endmodule

module lShiftOne(
  input[31:0] aluOut,
  output[31:0] lshifted
);

  assign lshifted = aluOut<<1;

endmodule
