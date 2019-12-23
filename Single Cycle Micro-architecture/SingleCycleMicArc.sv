module Main_Decoder
(
	input logic [5:0] opcode,
	output logic memto_reg,
	output logic mem_write,	
	output logic branch,
	output logic alu_src,
	output logic reg_dst,
	output logic reg_write,
	output logic [1:0] alu_op,
	output logic jump
);

always_comb
begin
	case(opcode)
		6'b000000 : begin
			reg_write = 1'b1; 
			reg_dst = 1'b1; 
			alu_src = 1'b0;
			branch = 1'b0;
			mem_write = 1'b0;
			memto_reg = 1'b0;
			alu_op = 2'b10; 
			jump = 1'b0; 
		end
		6'b100011 : begin
			reg_write = 1'b1;
			reg_dst = 1'b0;
			alu_src = 1'b1;
			branch = 1'b0;
			mem_write = 1'b0;
			memto_reg = 1'b1;
			alu_op = 2'b00; 
			jump = 1'b0; 
		end
		6'b101011 : begin
			reg_write = 1'b0; 
			reg_dst = 1'bx; 
			alu_src = 1'b1;
			branch = 1'b0;
			mem_write = 1'b1;
			memto_reg = 1'bx;
			alu_op = 2'b00; 
			jump = 1'b0; 
		end
		6'b000100 : begin
			reg_write = 1'b0; 
			reg_dst = 1'bx; 
			alu_src = 1'b0;
			branch = 1'b1;
			mem_write = 1'b0;
			memto_reg = 1'bx;
			alu_op = 2'b01; 
			jump = 1'b0; 
		end
		6'b001000 : begin
			reg_write = 1'b1; 
			reg_dst = 1'b0; 
			alu_src = 1'b1;
			branch = 1'b0;
			mem_write = 1'b0;
			memto_reg = 1'b0;
			alu_op = 2'b00; 
			jump = 1'b0; 
		end
		6'b000010 : begin
			reg_write = 1'b0; 
			reg_dst = 1'bx; 
			alu_src = 1'bx;
			branch = 1'bx;
			mem_write = 1'b0;
			memto_reg = 1'bx;
			alu_op = 2'bxx; 
			jump = 1'b1; 
		end
		default : begin
		end 
	endcase
end
endmodule

module ALU_Decoder
(
	input logic [5:0] funct,
	input logic [1:0] alu_op,
	output logic [2:0] alu_control
);
always_comb
begin
	if(alu_op === 2'b00) begin
		alu_control = 3'b010;
	end
	if(alu_op === 2'b01) begin
		alu_control = 3'b110;
	end
	if(alu_op === 2'b10) begin
		case(funct)
			6'b1000_00: begin
				alu_control = 3'b010;
			end
			6'b1000_10: begin
				alu_control = 3'b110;
			end
			6'b1001_00: begin
				alu_control = 3'b000;
			end
			6'b1001_01: begin
				alu_control = 3'b001;
			end
			6'b1010_10: begin
				alu_control = 3'b111;
			end
		endcase
	end
end

endmodule

module Control_Unit
(
	input logic [5:0] opcode,
	input logic [5:0] funct,
	output logic memto_reg,
	output logic mem_write,	
	output logic branch,
	output logic [2:0] alu_control,
	output logic alu_src,
	output logic reg_dst,
	output logic reg_write,
	output logic jump
);

logic [1:0] alu_op;

always_comb
begin
	Main_Decoder Main_D(opcode, memto_reg, mem_write, branch, alu_src, reg_dst, reg_write, alu_op, jump);
	ALU_Decoder ALU_D(funct, alu_op, alu_control);
end

endmodule

module ALU
(
	input logic [31:0] src_a,
	input logic [31:0] src_b,
	input logic [2:0] alu_control,
	output logic zero,
	output logic [31:0] alu_result
);

always_comb
begin
	case(alu_control)
		3'b010 : 
			alu_result = src_a + src_b;
		3'b110 : 
			alu_result = src_a - src_b;
		3'b000 :
			alu_result = src_a & src_b;
		3'b001 :
			alu_result = src_a | src_b;
		3'b111 :
			alu_result = src_a < src_b;
	endcase
	zero = (alu_result === 32'b0)? 1 : 0;
end

endmodule
