module ControlUnit(input logic [5:0] op, funct,
	input logic Zero,
	output logic c_MemToReg, c_MemWrite,
	output logic c_PCSrc, c_ALUSrcB,
	output logic c_RegDst, c_RegWrite,
	output logic c_Jump,
	output logic [2:0] c_ALUControl,
	output logic c_ALUSrcA, c_MemoryByte);
	
	logic [1:0] ALUOp;
	logic c_Branch;
	MainDecoder md(op, c_MemToReg, c_MemWrite, c_Branch,
	c_ALUSrcB, c_RegDst, c_RegWrite, c_Jump, ALUOp, c_ALUSrcA, c_MemoryByte);
	ALUDecoder ad(funct, ALUOp, c_ALUControl);
	assign c_PCSrc = c_Branch & Zero;
endmodule

module MainDecoder(input logic [5:0] op,
	output logic c_MemToReg, c_MemWrite,
	output logic c_Branch, c_ALUSrcB,
	output logic c_RegDst, c_RegWrite,
	output logic c_Jump,
	output logic [1:0] ALUOp,
	output logic c_ALUSrcA,
	output logic c_MemoryByte);

	logic [8:0] controls;
	
	assign {c_RegWrite, c_RegDst, c_ALUSrcB, c_Branch, c_MemWrite,
	c_MemToReg, c_Jump, ALUOp, c_ALUSrcA, c_MemoryByte} = controls;
	
	always_comb
			case(op)
			6'b000000: controls <= 11'b11000001000; // RTYPE
			6'b100011: controls <= 11'b10100100000; // LW
			6'b101011: controls <= 11'b00101000000; // SW
			6'b000100: controls <= 11'b00010000100; // BEQ
			6'b001000: controls <= 11'b10100000000; // ADDI
			6'b000010: controls <= 11'b00000010000; // J
			6'b001111: controls <= 11'b11000001110; // LUI
			6'b100000: controls <= 11'b10100100001; // LB
			default  : controls <= 11'bxxxxxxxxxxx; // illegal op
	endcase
endmodule

module ALUDecoder(input logic [5:0] funct,
	input logic [1:0] ALUOp,
	output logic [2:0] c_ALUControl);
	always_comb
	case(ALUOp)
	2'b00: c_ALUControl <= 3'b010; // Sum (for lw/sw/addi)
	2'b01: c_ALUControl <= 3'b110; // Diff (for beq)
	2'b11: c_ALUControl <= 3'b100; // sllv (for lui)
	default: case(funct) // R-type instructions
		6'b100000: c_ALUControl <= 3'b010; // Sum
		6'b100010: c_ALUControl <= 3'b110; // Diff
		6'b100100: c_ALUControl <= 3'b000; // and
		6'b100101: c_ALUControl <= 3'b001; // or
		6'b101010: c_ALUControl <= 3'b111; // slt
		6'b000100: c_ALUControl <= 3'b100; // sllv
		default: c_ALUControl <= 3'bxxx; // ???
		endcase
	endcase
endmodule
