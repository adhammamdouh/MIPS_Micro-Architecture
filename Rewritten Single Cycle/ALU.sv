module ALU(input logic[31:0] SrcA, SrcB,
			input logic[2:0] c_ALUControl,
			output logic[31:0] ALUResult,
			output logic Zero);
		
	logic[31:0] Sum, Diff;
	assign Sum = SrcA + SrcB;
	assign Diff = SrcA - SrcB;
	assign Zero = |c_ALUControl;
	always_comb
		case(c_ALUControl)
			3'b000: ALUResult <= SrcA & SrcB;
			3'b001: ALUResult <= SrcA | SrcB;
			3'b010: ALUResult <= SrcA + SrcB;
			//3'b011:
			3'b100: ALUResult <= SrcB << SrcA[4:0];  //#EDITED LINE
			//3'b101:
			3'b110: ALUResult <= SrcA - SrcB;
			3'b111: ALUResult <= {31'b0, Diff[31]};
			default: ALUResult <= 31'bx;
		endcase
endmodule