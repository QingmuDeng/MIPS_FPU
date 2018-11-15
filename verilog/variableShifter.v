module variableShifter(
  input[31:0] significand,
  input [7:0] shamt,
  output reg [31:0] rshifted
);

  always@ (*)begin
    if(shamt[7]==0) begin
      if(significand[shamt-1])begin
        rshifted = (significand>>shamt)+32'b1;
      end
      else begin
        rshifted = (significand>>shamt);
      end
    end
    else begin
      if(significand[shamt-1])begin
        rshifted = significand>>(~shamt+8'd1)+32'b1;
      end
      else begin
        rshifted = significand>>(~shamt+8'd1);
      end
    end
  end

endmodule

module lShiftOne(
  input[31:0] aluOut,
  output[31:0] lshifted
);

  assign lshifted = aluOut<<1;

endmodule
