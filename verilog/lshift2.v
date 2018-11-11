module lshift28(
  input[25:0] immediate,
  output[27:0] lshifted
);

  assign lshifted = immediate<<2;

endmodule

module lshift32(
  input[31:0] immediate,
  output[31:0] lshifted
);

  assign lshifted = immediate<<2;

endmodule
