/*
* D-Flip Flop module
*/

module programCounter
   (
    input [31:0] d,
    input  clk,
    output reg [31:0] q
    );

   always @(posedge clk) begin
        q <= d;
    end

    initial begin
      q = 32'b0;
    end
endmodule
