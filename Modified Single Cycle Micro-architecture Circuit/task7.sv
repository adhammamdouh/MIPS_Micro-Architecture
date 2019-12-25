module mips(input logic clk, reset,
	output logic [31:0] pc,
	input logic [31:0] instr,
	output logic memwrite,
	output logic [31:0] aluout, writedata,
	input logic [31:0] readdata,
	output logic readWriteType,chooseExtend); //Added By Belal
	
	logic memtoreg, alusrc, regdst,
	regwrite, jump, pcsrc, zero;
	logic [2:0] alucontrol;
	
	controller c(instr[31:26], instr[5:0], zero,
	memtoreg, memwrite, pcsrc,
	alusrc, regdst, regwrite, jump,
	alucontrol,
	readWriteType,chooseExtend); //Added By Belal
	
	datapath dp(clk, reset, memtoreg, pcsrc,
	alusrc, regdst, regwrite, jump,
	alucontrol,
	zero, pc, instr,
	aluout, writedata, readdata,
	chooseExtend); //Added By Belal
	
endmodule
module controller(input logic [5:0] op, funct,
	input logic zero,
	output logic memtoreg, memwrite,
	output logic pcsrc, alusrc,
	output logic regdst, regwrite,
	output logic jump,
	output logic [2:0] alucontrol,
	output logic readWriteType,chooseExtend); //Added By Belal
	
	logic [1:0] aluop;
	logic branch;
	maindec md(op, memtoreg, memwrite, branch,
	alusrc, regdst, regwrite, jump, aluop,
	readWriteType,chooseExtend); //Added By Belal
	
	aludec ad(funct, aluop, alucontrol);
	assign pcsrc = branch & zero;
endmodule

module maindec(input logic [5:0] op,
output logic memtoreg, memwrite,
output logic branch, alusrc,
output logic regdst, regwrite,
output logic jump,
output logic [1:0] aluop,
output logic readWriteType,chooseExtend); //Added By Belal

	logic [11:0] controls;
	assign {regwrite, regdst, alusrc, branch, memwrite,
	memtoreg, jump, aluop,readWriteType,chooseExtend} = controls; //Added By Belal
	always_comb
	case(op)
	6'b000000: controls <= 11'b11000001000; // RTYPE
	6'b100011: controls <= 11'b10100100000; // LW
	6'b101011: controls <= 11'b00101000000; // SW
	6'b000100: controls <= 11'b00010000100; // BEQ
	6'b001000: controls <= 11'b10100000000; // ADDI
	6'b000010: controls <= 11'b00000010000; // J
	6'b100000: controls <= 11'b10100100011; // LB Added By Belal as LW but readWriteType,chooseExtend  1
	default: controls <= 11'bxxxxxxxxx; // illegal op
	endcase
endmodule

module aludec(input logic [5:0] funct,
	input logic [1:0] aluop,
	output logic [2:0] alucontrol);
	always_comb
	case(aluop)
	2'b00: alucontrol <= 3'b010; // add (for lw/sw/addi)
	2'b01: alucontrol <= 3'b110; // sub (for beq)
	default: case(funct) // R-type instructions
		6'b100000: alucontrol <= 3'b010; // add
		6'b100010: alucontrol <= 3'b110; // sub
		6'b100100: alucontrol <= 3'b000; // and
		6'b100101: alucontrol <= 3'b001; // or
		6'b101010: alucontrol <= 3'b111; // slt
		default: alucontrol <= 3'bxxx; // ???
		endcase
	endcase
endmodule

module datapath(input logic clk, reset,
input logic memtoreg, pcsrc,
input logic alusrc, regdst,
input logic regwrite, jump,
input logic [2:0] alucontrol,
output logic zero,
output logic [31:0] pc,
input logic [31:0] instr,
output logic [31:0] aluout, writedata,
input logic [31:0] readdata,
input logic chooseExtend);//Added By Belal
	
	logic [4:0] writereg;
	logic [31:0] pcnext, pcnextbr, pcplus4, pcbranch;
	logic [31:0] signimm, signimmsh;
	logic [31:0] srca, srcb;
	logic [31:0] result;
	// next PC logic
	flopr #(32) pcreg(clk, reset, pcnext, pc);
	adder pcadd1(pc, 32'b100, pcplus4);
	sl2 immsh(signimm, signimmsh);
	adder pcadd2(pcplus4, signimmsh, pcbranch);
	mux2 #(32) pcbrmux(pcplus4, pcbranch, pcsrc, pcnextbr);
	mux2 #(32) pcmux(pcnextbr, {pcplus4[31:28],
	instr[25:0], 2'b00}, jump, pcnext);
	// register file logic
	regfile rf(clk, regwrite, instr[25:21], instr[20:16],
	writereg, result, srca, writedata);
	mux2 #(5) wrmux(instr[20:16], instr[15:11],
	regdst, writereg);
	
	//Added by belal
	logic [31:0] byteRead;
	logic [31:0] readDataResult;
	signext se(readdata[0:7], byteRead);
	
	mux2 #(32) readDataMUX(readdata,byteRead,chooseExtend,readDataResult)
	mux2 #(32) resmux(aluout, readDataResult, memtoreg, result);
	
	
	signext se(instr[15:0], signimm);
	// ALU logic
	mux2 #(32) srcbmux(writedata, signimm, alusrc, srcb);
	alu alu(srca, srcb, alucontrol, aluout, zero);
endmodule
