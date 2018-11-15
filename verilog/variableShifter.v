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

module normalizer (
  input [31:0] FloataluResult,
  output reg [31:0] normalizedFloataluResult,
  output reg [31:0] exponentChange
  );

  always @ ( * ) begin
    if(FloataluResult[24]&~(|(FloataluResult[31:25]))) begin
      exponentChange <= 32'sd1;
      normalizedFloataluResult <= FloataluResult>>>1;
    end
    else if(FloataluResult[22]&~(|(FloataluResult[31:23]))) begin
      exponentChange <= -32'sd1;
      normalizedFloataluResult <= FloataluResult<<1;
    end
    else begin
      exponentChange <= 32'sd0;
      normalizedFloataluResult <= FloataluResult;
    end
  end
endmodule // normalizer

module lShiftOne(
  input[31:0] aluOut,
  output[31:0] lshifted
);

  assign lshifted = aluOut<<1;

endmodule
