/*

Testbench code for the alu module

*/

module alu_testbench();
    logic [31:0] rs1_val, rs2_val, rd_val;
    logic [3:0] alu_op;

    alu dut(.rs1_val, .rs2_val, .alu_op, .rd_val);

    initial begin
        $dumpfile("testbench_vcd/alu_testbench.vcd");
        $dumpvars(0, alu_testbench);
        // Test ADD
        rs1_val = 4; rs2_val = 2; alu_op = 0; #10;
        // Test SUB
        rs1_val = 4; rs2_val = 2; alu_op = 1; #10;
        // Test SLL
        rs1_val = 32'b10101010101010101010101010101010; rs2_val = 4; alu_op = 2; #10;
        // Test SLT
        rs1_val = 54; rs2_val = 34; alu_op = 3; #10;
        rs1_val = 34; rs2_val = 54; alu_op = 3; #10;
        rs1_val = -2147483648; rs2_val = 1; alu_op = 3; #10;
        // Test SLTU
        rs1_val = 54; rs2_val = 34; alu_op = 4; #10;
        rs1_val = 34; rs2_val = 54; alu_op = 4; #10;
        rs1_val = 2147483648; rs2_val = 1; alu_op = 4; #10;
        // Test XOR
        rs1_val = 382345; rs2_val = 1349508; alu_op = 5; #10;
        // Test SRL
        rs1_val = 32'b10101010101010101010101010101010; rs2_val = 4; alu_op = 6; #10;
        // Test SRA
        rs1_val = 32'b10101010101010101010101010101010; rs2_val = 4; alu_op = 7; #10;
        // Test OR
        rs1_val = 382345; rs2_val = 1349508; alu_op = 8; #10;
        // Test AND
        rs1_val = 382345; rs2_val = 1349508; alu_op = 9; #10;
        // Test Default
        rs1_val = 382345; rs2_val = 1349508; alu_op = 10; #10;
    end
endmodule