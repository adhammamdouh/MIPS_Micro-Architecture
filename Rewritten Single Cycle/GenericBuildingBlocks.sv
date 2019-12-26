module MemoryValSize(input logic c_MemoryByte,
input logic[31:0] memReadData,
output logic[31:0] memValue);
	//if (c_MemoryByte) memValue = Sign extended memReadData[0:7]
	//else memValue = memReadData
	
	logic[31:0] byteRead;
	SignExtend #(8) se(memReadData[7:0], byteRead);
	
	mux2 #(32) memout(memReadData, byteRead, c_MemoryByte, memValue);
endmodule

module Adder(input logic [31:0] a, b,
			output logic [31:0] y);
			
	assign y = a + b;
endmodule

module ShiftLeft2(input logic [31:0] a,
		output logic [31:0] y);
		// shift left by 2
	
	assign y = {a[29:0], 2'b00};
endmodule


module SignExtend #(parameter WIDTH = 16)(input logic [WIDTH-1:0] a,
		output logic [31:0] y);

	assign y = {{31{a[15]}}, a}[31:0];
endmodule

module FlipFlop #(parameter WIDTH = 8)
			(input logic CLK, RESET,
			input logic [WIDTH-1:0] d,
			output logic [WIDTH-1:0] q);
	
	always_ff @(posedge CLK, posedge RESET)
		if (RESET) q <= 0;
		else q <= d;
endmodule

module mux2 #(parameter WIDTH = 8)
		(input logic [WIDTH-1:0] d0, d1,
		input logic s,
		output logic [WIDTH-1:0] y);
	
	assign y = s ? d1 : d0;
endmodule