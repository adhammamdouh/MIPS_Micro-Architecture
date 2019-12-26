module MIPS(input logic CLK, RESET,
	//buses to and from instruction memory
	output logic [31:0] PC,
	input logic [31:0] Instr,
	//buses to and from main memory
	output logic memWrite,
	output logic [31:0] memAddress, memWriteData,
	input logic [31:0] memReadData);

	//Control Unit Outputs
	logic 
		c_MemWrite,
		c_MemToReg,
		c_ALUSrcA,
		c_ALUSrcB,
		c_RegDst,
		c_RegWrite,
		c_Jump,
		c_PCSrc,
		c_MemoryByte;
	
	logic [2:0] c_ALUControl;
	
	//intermediate values
	logic Zero;
	logic[31:0] ALUResult, WriteData;
	
	//this holds the value from the memory, identical to memReadData when a whole word is read
	logic [31:0] memValue;
	
	assign memAddress = ALUResult;
	assign memWriteData = WriteData;
	assign memWrite = c_MemWrite;
	
	ControlUnit c(Instr[31:26], Instr[5:0], Zero,
	c_MemToReg, c_MemWrite, c_PCSrc,
	c_ALUSrcB, c_RegDst, c_RegWrite, c_Jump,
	c_ALUControl, c_ALUSrcA, c_MemoryByte);
	
	MemoryValSize memval(c_MemoryByte, memReadData, memValue);
	
	DataPath dp(CLK, RESET, c_MemToReg, c_PCSrc,
		c_ALUSrcB, c_RegDst, c_RegWrite, c_Jump,
		c_ALUControl,
		Zero, PC, Instr,
		ALUResult, WriteData, memValue, c_ALUSrcA);
endmodule