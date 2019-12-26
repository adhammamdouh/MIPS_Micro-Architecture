module DataPath(input logic CLK, RESET,
	input logic c_MemToReg, c_PCSrc,
	input logic c_ALUSrcB, c_RegDst,
	input logic c_RegWrite, c_Jump,
	input logic [2:0] c_ALUControl,
	output logic Zero,
	output logic [31:0] PC,
	input logic [31:0] Instr,
	output logic [31:0] ALUResult, RD2,
	input logic [31:0] memReadData,
	input logic c_ALUSrcA);

	logic [4:0] WriteReg;
	logic [31:0] PCNext, PCRelativeNext, PCPlus4, PCBranch;
	logic [31:0] SignImm, SignImmShifted;
	logic [31:0] RD1;
	logic [31:0] SrcA, SrcB;
	logic [31:0] Result;
	// next PC logic
	FlipFlop #(32) pcreg(CLK, RESET, PCNext, PC);
	
	Adder pcadd1(PC, 32'b100, PCPlus4);
	ShiftLeft2 imm_sh(SignImm, SignImmShifted);
	
	Adder pcadd2(PCPlus4, SignImmShifted, PCBranch);
	
	mux2 #(32) Mux_PCBranch(PCPlus4, PCBranch, c_PCSrc, PCRelativeNext);
	mux2 #(32) Mux_PC(PCRelativeNext, {PCPlus4[31:28],
	Instr[25:0], 2'b00}, c_Jump, PCNext);
	
	// register file logic
	AccessRegisters rf(CLK, c_RegWrite, Instr[25:21], Instr[20:16],
	WriteReg, Result, RD1, RD2);
	
	mux2 #(5) Mux_WriteRegister(Instr[20:16], Instr[15:11], c_RegDst, WriteReg);
	
	mux2 #(32) Mux_Result(ALUResult, memReadData, c_MemToReg, Result);
	
	SignExtend #(16) se(Instr[15:0], SignImm);
	
	// ALU logic
	mux2 #(32) Mux_SrcA(RD1, 16, c_ALUSrcA, SrcA);
	mux2 #(32) Mux_SrcB(RD2, SignImm, c_ALUSrcB, SrcB);
	
	ALU alu(SrcA, SrcB, c_ALUControl, ALUResult, Zero);
endmodule
