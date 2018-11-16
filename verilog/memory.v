
//------------------------------------------------------------------------
// Memory
//   Outputs both instruction and data memroy
//   Positive edge triggered
//   dataOut always has the value mem[address]
//   If writeEnable is true, writes dataIn to mem[address]
//------------------------------------------------------------------------

// module memory
// (
//   input clk, dataMemorywriteEnable,
//   input [9:0] InstructionAddress,
//   input [9:0] dataMemoryAddress,
//   input[31:0] dataMemorydataIn,
//   output[31:0]  dataMemorydataOut,
//   output[31:0] instructionOut
// );
//
//   reg [31:0] mem[1023:0];
//
//   always @(posedge clk) begin
//     if (dataMemorywriteEnable) begin
//       mem[dataMemoryAddress] <= dataMemorydataIn;
//     end
//   end
//
//   assign dataMemorydataOut = mem[dataMemoryAddress];
//   assign instructionOut = mem[InstructionAddress];
//
// endmodule

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
        memory[compactDataMemoryAddress>>2] <= dataMemorydataIn;

   end

   assign dataMemorydataOut = memory[compactDataMemoryAddress>>2];
   assign instructionOut = memory[compactInstructionAddress>>2];

endmodule

//
// module memory
//   #(
//     parameter addresswidth  = 32,
//     parameter depth         = 2**15,
//     parameter width         = 32
//     )
//    (
//     input                    clk,
//     output [width-1:0]   dataMemorydataOut,
//     output [width-1:0]   instructionOut,
//     input [addresswidth-1:0] InstructionAddress,
//     input [addresswidth-1:0] dataMemoryAddress,
//     input                    dataMemorywriteEnable,
//     input [width-1:0]        dataMemorydataIn
//     );
//
//
//    wire [14:0] compactInstructionAddress;
//    wire [14:0] compactDataMemoryAddress;
//
//    reg [8-1:0]           memory [depth-1:0];
//
//    assign compactInstructionAddress = InstructionAddress[14:0];
//    assign compactDataMemoryAddress = dataMemoryAddress[14:0];
//
//    always @(posedge clk) begin
//       if(dataMemorywriteEnable)
//         memory[compactDataMemoryAddress] <= dataMemorydataIn[31:24];
//         memory[compactDataMemoryAddress+1] <= dataMemorydataIn[23:16];
//         memory[compactDataMemoryAddress+2] <= dataMemorydataIn[15:8];
//         memory[compactDataMemoryAddress+3] <= dataMemorydataIn[7:0];
//    end
//
//    // initial $readmemh("test1.text", memory, 0);
//    // initial $readmemh("test1.data", memory, 16'h1000);
//
//    assign dataMemorydataOut = {memory[compactDataMemoryAddress],memory[compactDataMemoryAddress+1],memory[compactDataMemoryAddress+2],memory[compactDataMemoryAddress+3]};
//    assign instructionOut = {memory[compactInstructionAddress],memory[compactInstructionAddress+1],memory[compactInstructionAddress+2],memory[compactInstructionAddress+3]};
//
// endmodule
