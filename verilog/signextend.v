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
  output reg [31:0] extended
);
  always @(*) begin
    if(!sign)begin
      extended <= {{8{1'b0}}, significand[23:0]};
    end
    else begin
      extended <= ~significand[23:0]+1'b1;
    end
  end

endmodule

`endif
