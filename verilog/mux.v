`ifndef _my_incl_vh_
`define _my_incl_vh_
module mux4to1by32
(
  output reg[31:0]      out,
  input[1:0]  address,
  input[31:0]  input0, input1, input2, input3
);

    always @ ( * ) begin
      if(address==2'd0) begin
        out <= input0; // Connect the output of the array
      end else if (address==2'd1)begin
        out <= input1; // Connect the output of the array
      end else if (address==2'd2)begin
        out <= input2; // Connect the output of the array
      end else if (address==2'd3)begin
        out <= input3; // Connect the output of the array
      end
    end
endmodule

module mux4to1by5
(
  output reg [4:0]      out,
  input[1:0]  address,
  input[4:0]  input0, input1, input2, input3
);


    always @ ( * ) begin
      if(address==2'd0) begin
        out <= input0; // Connect the output of the array
      end else if (address==2'd1)begin
        out <= input1; // Connect the output of the array
      end else if (address==2'd2)begin
        out <= input2; // Connect the output of the array
      end else if (address==2'd3)begin
        out <= input3; // Connect the output of the array
      end
    end

endmodule


module mux2to1by1
(
  output reg      out,
  input  address,
  input  input0, input1
);


    always @ ( * ) begin
      if(address==2'd0) begin
        out <= input0; // Connect the output of the array
      end else if (address==2'd1)begin
        out <= input1; // Connect the output of the array
      end
    end

endmodule

module mux2to1by8
(
  output reg[7:0]      out,
  input  address,
  input[7:0]  input0, input1
);


    always @ ( * ) begin
      if(address==2'd0) begin
        out <= input0; // Connect the output of the array
      end else if (address==2'd1)begin
        out <= input1; // Connect the output of the array
      end
    end

endmodule

// module mux4to1by5
// (
//   output[4:0]      out,
//   input[1:0]  address,
//   input[4:0]  input0, input1, input2, input3
// );
//     wire[3:0] mux[4:0]; // Create a 2D array of wires
//
//     assign mux[0] = input0;
//     assign mux[1] = input1;
//     assign mux[2] = input2;
//     assign mux[3] = input3;
//
//     assign out = mux[address]; // Connect the output of the array
// endmodule

module mux2to1by32
(
  output reg[31:0]      out,
  input  address,
  input[31:0]  input0, input1
);

    always @ ( * ) begin
      if(address==2'd0) begin
        out <= input0; // Connect the output of the array
      end else if (address==2'd1)begin
        out <= input1; // Connect the output of the array
      end
    end
endmodule
`endif
