# MIPS_Micro-Architecture

## Task 1 (1 marks) ##
1. Review MIPS Single Cycle Micro-architecture described in "Digital Design and Computer Architecture" by Harris and Harris.
2. Write the Verilog code given in the book, fix any errors, get it to work and test and simulate it.

## Task 2 (4 marks) ##
1. Each team member will add to this design one more instruction by:
    i. Studying how the instruction is executed and what extra hardware is need for that. Some instructions might be already executable with existing hardware but need specific control signals. 
    ii. Changing the Single Cycle MIPS design of the book to add the necessary hardware. Some instructions may need changes in the ALU design as well.
    iii. Modifying the Single Cycle MIPS Verilog code to include the new hardware.
    iv. Testing the new design and doing a simulation to show that the new instructions work.
2. Team of three will do three instructions and teams of four will do four instructions.
3. Each team member will do an instruction (or pseudo instruction) according to the following and update the design to include it. See Appendix B in the book for instruction description.

### Tasks ###

0 | 1 | 2 | 3 | 4
--- | --- | --- | --- | ---
bltz rs, label | jal label | slti rt, rs, imm | ori rt, rs, imm | lui rt, imm

5 | 6 | 7 | 8 | 9
--- | --- | --- | --- | ---
lb rt, imm(rs) | jr rs | sb rt, imm(rs) s | sll rd, rt, shamt | rt, rs
