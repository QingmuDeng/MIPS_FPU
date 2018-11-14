module multiply (
  input enable,
  input [31:0] A,
  input [31:0] B,
  output reg [31:0] Hi,
  output reg [31:0] Lo
  );

  always @ ( * ) begin
    if(enable) begin
      {Hi, Lo} <= A*B;
    end
  end

endmodule // multiply
