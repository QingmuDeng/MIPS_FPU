module register32
(
  output reg [31:0] q,
  input [31:0] d,
  input wrenable,
  input clk
  );

  always @(posedge clk) begin
      if(wrenable) begin
          q <= d;
      end
  end

endmodule


module register32zero
(
  output [31:0] q,
  input [31:0] d,
  input wrenable,
  input clk
);
  // always @(posedge clk) begin
  //     if(wrenable) begin
      assign    q = 32'b0;
  //     end
  // end

endmodule
