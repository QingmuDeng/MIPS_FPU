
//------------------------------------------------------------------------
// Memory
//   Outputs both instruction and data memroy
//   Positive edge triggered
//   dataOut always has the value mem[address]
//   If writeEnable is true, writes dataIn to mem[address]
//------------------------------------------------------------------------

module memory
  #(
    parameter addresswidth  = 32,
    parameter depth         = 2**15,
    parameter width         = 32
    )
   (
    input                    clk,
    output [width-1:0]   dataMemorydataOut,
    output [width-1:0]   instructionOut,
    input [addresswidth-1:0] InstructionAddress,
    input [addresswidth-1:0] dataMemoryAddress,
    input                    dataMemorywriteEnable,
    input [width-1:0]        dataMemorydataIn
    );


   wire [14:0] compactInstructionAddress;
   wire [14:0] compactDataMemoryAddress;

   reg [width-1:0]           memory [depth-1:0];

   assign compactInstructionAddress = InstructionAddress[14:0];
   assign compactDataMemoryAddress = dataMemoryAddress[14:0];

   always @(posedge clk) begin
      if(dataMemorywriteEnable)
        memory[compactDataMemoryAddress] <= dataMemorydataIn;
   end

   // initial $readmemh("test1.text", memory, 0);
   // initial $readmemh("test1.data", memory, 16'h1000);

   assign dataMemorydataOut = memory[compactDataMemoryAddress];
   assign instructionOut = memory[compactInstructionAddress>>2];

endmodule
