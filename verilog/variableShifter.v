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
      normalizedFloataluResult <= FloataluResult>>1;
    end
    else if(FloataluResult[25]&~(|(FloataluResult[31:26]))) begin
      exponentChange <= 32'sd2;
      normalizedFloataluResult <= FloataluResult>>2;
    end
    else if(FloataluResult[26]&~(|(FloataluResult[31:27]))) begin
      exponentChange <= 32'sd3;
      normalizedFloataluResult <= FloataluResult>>3;
    end
    else if(FloataluResult[27]&~(|(FloataluResult[31:28]))) begin
      exponentChange <= 32'sd4;
      normalizedFloataluResult <= FloataluResult>>4;
    end
    else if(FloataluResult[28]&~(|(FloataluResult[31:29]))) begin
      exponentChange <= 32'sd5;
      normalizedFloataluResult <= FloataluResult>>5;
    end
    else if(FloataluResult[29]&~(|(FloataluResult[31:30]))) begin
      exponentChange <= 32'sd6;
      normalizedFloataluResult <= FloataluResult>>6;
    end
    else if(FloataluResult[30]&~(|(FloataluResult[31]))) begin
      exponentChange <= 32'sd7;
      normalizedFloataluResult <= FloataluResult>>7;
    end

     /*** The below checks for left shift ***/
    else if(FloataluResult[22]&~(|(FloataluResult[31:23]))) begin
      exponentChange <= -32'sd1;
      normalizedFloataluResult <= FloataluResult<<1;
    end
    else if(FloataluResult[21]&~(|(FloataluResult[31:22]))) begin
      exponentChange <= -32'sd2;
      normalizedFloataluResult <= FloataluResult<<2;
    end
    else if(FloataluResult[20]&~(|(FloataluResult[31:21]))) begin
      exponentChange <= -32'sd3;
      normalizedFloataluResult <= FloataluResult<<3;
    end
    else if(FloataluResult[19]&~(|(FloataluResult[31:20]))) begin
      exponentChange <= -32'sd4;
      normalizedFloataluResult <= FloataluResult<<4;
    end
    else if(FloataluResult[18]&~(|(FloataluResult[31:19]))) begin
      exponentChange <= -32'sd5;
      normalizedFloataluResult <= FloataluResult<<5;
    end
    else if(FloataluResult[17]&~(|(FloataluResult[31:18]))) begin
      exponentChange <= -32'sd6;
      normalizedFloataluResult <= FloataluResult<<6;
    end
    else if(FloataluResult[16]&~(|(FloataluResult[31:17]))) begin
      exponentChange <= -32'sd7;
      normalizedFloataluResult <= FloataluResult<<7;
    end
    else if(FloataluResult[15]&~(|(FloataluResult[31:16]))) begin
      exponentChange <= -32'sd8;
      normalizedFloataluResult <= FloataluResult<<8;
    end
    else if(FloataluResult[14]&~(|(FloataluResult[31:15]))) begin
      exponentChange <= -32'sd9;
      normalizedFloataluResult <= FloataluResult<<9;
    end
    else if(FloataluResult[13]&~(|(FloataluResult[31:14]))) begin
      exponentChange <= -32'sd10;
      normalizedFloataluResult <= FloataluResult<<10;
    end
    else if(FloataluResult[12]&~(|(FloataluResult[31:13]))) begin
      exponentChange <= -32'sd11;
      normalizedFloataluResult <= FloataluResult<<11;
    end
    else if(FloataluResult[11]&~(|(FloataluResult[31:12]))) begin
      exponentChange <= -32'sd12;
      normalizedFloataluResult <= FloataluResult<<12;
    end
    else if(FloataluResult[10]&~(|(FloataluResult[31:11]))) begin
      exponentChange <= -32'sd13;
      normalizedFloataluResult <= FloataluResult<<13;
    end
    else if(FloataluResult[9]&~(|(FloataluResult[31:10]))) begin
      exponentChange <= -32'sd14;
      normalizedFloataluResult <= FloataluResult<<14;
    end
    else if(FloataluResult[8]&~(|(FloataluResult[31:9]))) begin
      exponentChange <= -32'sd15;
      normalizedFloataluResult <= FloataluResult<<15;
    end
    else if(FloataluResult[7]&~(|(FloataluResult[31:8]))) begin
      exponentChange <= -32'sd16;
      normalizedFloataluResult <= FloataluResult<<16;
    end
    else if(FloataluResult[6]&~(|(FloataluResult[31:7]))) begin
      exponentChange <= -32'sd17;
      normalizedFloataluResult <= FloataluResult<<17;
    end
    else if(FloataluResult[5]&~(|(FloataluResult[31:6]))) begin
      exponentChange <= -32'sd18;
      normalizedFloataluResult <= FloataluResult<<18;
    end
    else if(FloataluResult[4]&~(|(FloataluResult[31:5]))) begin
      exponentChange <= -32'sd19;
      normalizedFloataluResult <= FloataluResult<<19;
    end
    else if(FloataluResult[3]&~(|(FloataluResult[31:4]))) begin
      exponentChange <= -32'sd20;
      normalizedFloataluResult <= FloataluResult<<20;
    end
    else if(FloataluResult[2]&~(|(FloataluResult[31:3]))) begin
      exponentChange <= -32'sd21;
      normalizedFloataluResult <= FloataluResult<<21;
    end
    else if(FloataluResult[1]&~(|(FloataluResult[31:2]))) begin
      exponentChange <= -32'sd22;
      normalizedFloataluResult <= FloataluResult<<22;          /*** End of left shift lookup****/
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
