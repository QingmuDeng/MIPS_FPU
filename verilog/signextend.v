`ifndef _sign_extend_
`define _sign_extend_

module signExtend(
  input[15:0] immediate,
  output[31:0] extended
);

  assign extended = {{16{immediate[15]}}, immediate};

endmodule

module signExtendFloat(
  input sign,
  input[31:0] significand,
  output[31:0] extended
);

  assign extended = {{8{sign}}, significand[23:0]};

endmodule

`endif
