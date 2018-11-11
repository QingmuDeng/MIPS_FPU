`include "instructionDecoder.v"

module testinstructionDecoder();
  reg[5:0] opcode;
  reg[5:0] functcode;
  reg zero;
  reg passed=1;

  wire regWrite, muxA_en, dm_we, muxWD3_en;
  wire[1:0] muxB_en, regWriteAddSelect, muxPC;
  wire[2:0] ALUop;

  instructionDecoder dut(.opcode(opcode), .functcode(functcode), .regWrite(regWrite), .muxA_en(muxA_en), .dm_we(dm_we), .muxWD3_en(muxWD3_en),
          .muxB_en(muxB_en), .regWriteAddSelect(regWriteAddSelect), .muxPC(muxPC), .ALUop(ALUop), .zero(zero));

  initial begin
    $dumpfile("parser.vcd");
    $dumpvars(0, dut);
    $display("Beginning instruction parser test.");

    opcode = 6'h0; functcode = 6'h8; #100
    if(regWrite==1'd0 && dm_we==1'd0 && muxPC==2'd2) begin
      $display("  JR parse successful.");
    end else begin
      $display("  JR parse failed.");
      passed=0;
    end

    opcode = 6'h0; functcode = 6'h22; #100
    if(regWrite==1'd1 && muxA_en==1'd0 && muxB_en==1'd1 && dm_we==1'd0 && muxPC==2'd0 && muxWD3_en==1'd1 && regWriteAddSelect == 2'd2 && ALUop==`SUBSIGNAL) begin
      $display("  SUB parse successful.");
    end else begin
      $display("  SUB parse failed.");
      passed=0;
    end

    opcode = 6'h0; functcode = 6'h2a; #100
    if(regWrite==1'd1 && muxA_en==1'd0 && muxB_en==1'd1 && dm_we==1'd0 && muxPC==2'd0 && muxWD3_en==1'd1 && regWriteAddSelect == 2'd2 && ALUop==`SLTSIGNAL) begin
      $display("  SLT parse successful.");
    end else begin
      $display("  SLT parse failed.");
      passed=0;
    end

    opcode = 6'h0; functcode = 6'h20; #100
    if(regWrite==1'd1 && muxA_en==1'd0 && muxB_en==1'd1 && dm_we==1'd0 && muxPC==2'd0 && muxWD3_en==1'd1 && regWriteAddSelect == 2'd2 && ALUop==`ADDSIGNAL) begin
      $display("  ADD parse successful.");
    end else begin
      $display("  ADD parse failed.");
      passed=0;
    end

    opcode = 6'h23; #100
    if(regWrite==1'd1 && muxA_en==1'd0 && muxB_en==1'd0 && dm_we==1'd0 && muxPC==2'd0 && muxWD3_en==1'd0 && regWriteAddSelect == 2'd0 && ALUop==`ADDSIGNAL) begin
      $display("  LW parse successful.");
    end else begin
      $display("  LW parse failed.");
      passed=0;
    end

    opcode = 6'h2b;#100
    if(regWrite==1'd0 && muxA_en==1'd0 && muxB_en==1'd0 && dm_we==1'd1 && muxPC==2'd0 && ALUop==`ADDSIGNAL) begin
      $display("  SW parse successful.");
    end else begin
      $display("  SW parse failed.");
      passed=0;
    end

    opcode = 6'h4; zero = 0; #100
    if(regWrite==1'd0 && muxA_en==1'd0 && muxB_en==1'd1 && dm_we==1'd0 && muxPC==2'd0 && ALUop==`SUBSIGNAL) begin
      $display("  BEQ no branch parse successful.");
    end else begin
      $display("  BEQ no branch parse failed.");
      passed=0;
    end

    opcode = 6'h4; zero = 1; #100
    if(regWrite==1'd0 && muxA_en==1'd0 && muxB_en==1'd1 && dm_we==1'd0 && muxPC==2'd3 && ALUop==`SUBSIGNAL) begin
      $display("  BEQ do branch parse successful.");
    end else begin
      $display("  BEQ do branch parse failed.");
      passed=0;
    end

    opcode = 6'h5; zero = 0; #100
    if(regWrite==1'd0 && muxA_en==1'd0 && muxB_en==1'd1 && dm_we==1'd0 && muxPC==2'd3 && ALUop==`SUBSIGNAL) begin
      $display("  BNQ do branch parse successful.");
    end else begin
      $display("  BNQ do branch parse failed.");
      passed=0;
    end

    opcode = 6'h5; zero = 1; #100
    if(regWrite==1'd0 && muxA_en==1'd0 && muxB_en==1'd1 && dm_we==1'd0 && muxPC==2'd0 && ALUop==`SUBSIGNAL) begin
      $display("  BNQ no branch parse successful.");
    end else begin
      $display("  BNQ no branch parse failed.");
      passed=0;
    end

    opcode = 6'h9; #100
    if(regWrite==1'd1 && muxA_en==1'd0 && muxB_en==1'd0 && dm_we==1'd0 && muxPC==2'd0 && muxWD3_en==1'd1 && regWriteAddSelect == 2'd0 && ALUop==`ADDSIGNAL) begin
      $display("  ADDI parse successful.");
    end else begin
      $display("  ADDI parse failed.");
      passed=0;
    end

    opcode = 6'he; #100
    if(regWrite==1'd1 && muxA_en==1'd0 && muxB_en==1'd0 && dm_we==1'd0 && muxPC==2'd0 && muxWD3_en==1'd1 && regWriteAddSelect == 2'd0 && ALUop==`XORSIGNAL) begin
      $display("  XORI parse successful.");
    end else begin
      $display("  XORI parse failed.");
      passed=0;
    end

    opcode = 6'h2; #100
    if(regWrite==1'd0 && dm_we==1'd0 && muxPC==2'd1) begin
      $display("  J parse successful.");
    end else begin
      $display("  J parse failed.");
      passed=0;
    end

    opcode = 6'h3; #100
    if(regWrite==1'd1 && muxA_en==1'd1 && muxB_en==2'd2 && dm_we==1'd0 && muxPC==2'd1 && muxWD3_en==1'd1 && regWriteAddSelect == 2'd1 && ALUop==`ADDSIGNAL) begin
      $display("  JAL parse successful.");
    end else begin
      $display("  JAL parse failed.");
      passed=0;
    end
    $display("Instruction parser passed?: %d", passed);
  end


endmodule
