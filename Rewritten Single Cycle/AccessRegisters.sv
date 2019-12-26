module AccessRegisters(input logic CLK,
	input logic we3,
	input logic [4:0] ra1, ra2, wa3,
	input logic [31:0] wd3,
	output logic [31:0] RD1, RD2);
	
	logic [31:0] rf[31:0];
	
	// three ported register file
	// read two ports combinationally
	// write third port on rising edge of CLK
	// register 0 hardwired to 0
	// note: for pipelined processor, write third port
	// on falling edge of CLK
	
	always_ff @(posedge CLK)
		if (we3) rf[wa3] <= wd3;
	
	assign RD1 = (ra1 != 0) ? rf[ra1] : 0;
	assign RD2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule