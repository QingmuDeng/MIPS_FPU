// Finite State Machine Module

// Op Codes
`define RTYPE 6'b0
`define LW 6'h23
`define SW 6'h2b
`define BEQ 6'h4
`define BNE 6'h5
`define ADDI 6'h8
`define XORI 6'he
`define JUMP 6'h2
`define JAL 6'h3

// Funct Codes
`define JR 6'h8
`define SUB 6'h22
`define SLT 6'h2a
`define ADD 6'h20

//ALU Op Codes
`define ADDSIGNAL  3'd0
`define SUBSIGNAL  3'd1
`define XORSIGNAL  3'd2
`define SLTSIGNAL  3'd3
`define ANDSIGNAL  3'd4
`define NANDSIGNAL 3'd5
`define NORSIGNAL  3'd6
`define ORSIGNAL   3'd7


module instructionDecoder(
    input [5:0] opcode,
    input [5:0] functcode,
    input zero,

    output reg regWrite, muxA_en, dm_we, muxWD3_en, multiplyEn,
    output reg [1:0] muxB_en, regWriteAddSelect, muxPC,
    output reg [2:0] ALUop
  );
  wire nzero;
  not not0(nzero, zero);

  initial begin
    muxPC = 2'b0;
    muxA_en = 1'b0;
    muxB_en = 2'b0;
  end

  always @(*) begin
    case(opcode)

      `RTYPE: begin
        dm_we <= 1'b0;
        muxA_en <= 1'b0;
        muxB_en <= 2'd1;
        muxWD3_en <= 1'b1;
        regWriteAddSelect <= 2'd2;

        case(functcode)
          `JR: begin
            regWrite <= 1'b0;
            muxPC <= 2'd2;
            ALUop <= 3'd0;
          end

          `ADD: begin
            regWrite <= 1'b1;
            muxPC <= 2'd0;
            ALUop <= `ADDSIGNAL;
          end
          `SUB: begin
            regWrite <= 1'b1;
            muxPC <= 2'd0;
            ALUop <= `SUBSIGNAL;
          end
          `SLT: begin
            regWrite <= 1'b1;
            muxPC <= 2'd0;
            ALUop <= `SLTSIGNAL;
          end

        endcase
      end

      `LW: begin
        regWrite <= 1'b1;
        muxA_en <= 1'b0;
        dm_we <= 1'b0;
        muxWD3_en <= 1'b0;
        muxB_en <= 2'd0;
        regWriteAddSelect <= 2'd0;
        muxPC <= 2'd0;
        ALUop <= `ADDSIGNAL;
      end

      `SW: begin
        regWrite <= 1'b0;
        muxA_en <= 1'b0;
        dm_we <= 1'b1;
        muxWD3_en <= 1'b0;
        muxB_en <= 2'd0;
        regWriteAddSelect <= 2'b0;
        muxPC <= 2'd0;
        ALUop <= `ADDSIGNAL;
      end

      `BEQ: begin
        regWrite <= 1'b0;
        muxA_en <= 1'b0;
        dm_we <= 1'b0;
        muxWD3_en = 1'b0;
        muxB_en <= 2'd1;
        regWriteAddSelect = 2'b0;
        ALUop <= `SUBSIGNAL;
        if(zero) begin
          muxPC <= 2'd3;
        end else begin
          muxPC <= 2'd0;
        end
      end

      `BNE: begin
        regWrite <= 1'b0;
        muxA_en <= 1'b0;
        dm_we <= 1'b0;
        muxWD3_en = 1'b0;
        muxB_en <= 2'd1;
        regWriteAddSelect = 2'b0;
        ALUop <= `SUBSIGNAL;
        if(nzero) begin
          muxPC <= 2'd3;
        end else begin
          muxPC <= 2'd0;
        end
      end

      `ADDI: begin
        regWrite <= 1'b1;
        muxA_en <= 1'b0; // Changed this to 1 from 0
        dm_we <= 1'b0;
        muxWD3_en <= 1'b1;
        muxB_en = 2'd0;
        regWriteAddSelect <= 2'b0;
        muxPC <= 2'd0;
        ALUop <= `ADDSIGNAL;
      end

      `XORI: begin
        regWrite <= 1'b1;
        muxA_en <= 1'b0;
        dm_we <= 1'b0;
        muxWD3_en <= 1'b1;
        muxB_en <= 2'd0;
        regWriteAddSelect <= 2'b0;
        muxPC <= 2'b0;
        ALUop <= `XORSIGNAL;
      end

      `JUMP: begin
        regWrite <= 1'b0;
        muxA_en = 1'b0;
        dm_we <= 1'b0;
        muxWD3_en = 1'b0;
        muxB_en = 1'b0;
        regWriteAddSelect = 1'b0;
        muxPC <= 2'b1;
        ALUop <= `ADDSIGNAL;
      end

      `JAL: begin
        regWrite <= 1'b1;
        muxA_en <= 1'b1;
        dm_we <= 1'b0;
        muxWD3_en <= 1'b1;
        muxB_en <= 2'd2;
        regWriteAddSelect <= 2'b1;
        muxPC <= 2'b1;
        ALUop <= `ADDSIGNAL;
      end

    endcase
  end

endmodule
