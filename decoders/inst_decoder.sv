/*

Instruction decoder that obtains opcode, funct3, funct7, register, and immediate values.

Inputs:
    - instruction: 32-bit input for the instruction to decode
Outputs:
    - opcode: 7-bit output for the decoded opcode
    - funct3: 3-bit output for the decoded funct3
    - funct7: 7-bit output for the decoded funct7
    - rd: 5-bit output for the decoded destination register
    - rs1: 5-bit output for the decoded first source register
    - rs2: 5-bit output for the decoded second source register
    - use_imm: 1-bit flag for if an immediate is used in this instruction
        - 1 if used, 0 if not
    - immediate: 21-bit output for the decoded sign-extended immediate
    - operation: 3-bit output for which kind of operation is taking place.
        - 000: alu, 001: load, 010: jump, 011: store, 100: branch, 101: auipc, 110: unrecognized

*/

module inst_decoder(instruction, opcode, funct3, funct7, rd, rs1, rs2, use_imm, immediate);
    input logic [31:0] instruction;
    output logic [6:0] opcode, funct7;
    output logic [2:0] funct3;
    output logic [4:0] rd, rs1, rs2;
    output logic use_imm;
    output logic [20:0] immediate;

    
    assign opcode = instruction[6:0];

    // Decode based on opcode
    always_comb begin
        case(opcode)
            7'b0110011: begin // R-type instruction (add, sub, etc.)
                funct3 = instruction[14:12];
                funct7 = instruction[31:25];
                rd = instruction[11:7];
                rs1 = instruction[19:15];
                rs2 = instruction[24:20];
                use_imm = 1'b0;
                immediate = 21'b0;
            end
            7'b0010011: begin // I-type instruction (addi, slti, etc.)
                funct3 = instruction[14:12];
                funct7 = instruction[31:25]; // For SRLI and SRAI purposes
                rd = instruction[11:7];
                rs1 = instruction[19:15];
                rs2 = 5'b0;
                use_imm = 1'b1;
                case(instruction[31:25])
                    7'b0: begin
                        immediate = {16'b0, instruction[24:20]};
                    end
                    7'b0100000: begin
                        immediate = {16'b0, instruction[24:20]};
                    end
                    default: begin
                        immediate = 21'(signed'(instruction[31:20]));
                    end
                endcase
            end
            7'b0000011: begin // Load instructions (lb, lh, etc)
                funct3 = instruction[14:12];
                funct7 = 7'b0;
                rd = instruction[11:7];
                rs1 = instruction[19:15];
                rs2 = 5'b0;
                use_imm = 1'b1;
                immediate = 21'(signed'(instruction[31:20]));
            end
            7'b1100111: begin // JALR
                funct3 = 3'b000;
                funct7 = 7'b0;
                rd = instruction[11:7];
                rs1 = instruction[19:15];
                rs2 = 5'b0;
                use_imm = 1'b1;
                immediate = 21'(signed'(instruction[31:20]));
            end
            7'b0100011: begin // S-type (store) instructions (sb, sh, etc.)
                funct3 = instruction[14:12];
                funct7 = 7'b0;
                rd = 5'b0;
                rs1 = instruction[19:15];
                rs2 = instruction[24:20];
                use_imm = 1'b1;
                immediate = 21'(signed'({instruction[31:25], instruction[11:7]}));
            end
            7'b1100011: begin // SB-type (branch) instructions (beq, bne, etc.)
                funct3 = instruction[14:12];
                funct7 = 7'b0;
                rd = 5'b0;
                rs1 = instruction[19:15];
                rs2 = instruction[24:20];
                use_imm = 1'b0; // Even though there is an immediate, set to 1'b0 to not trigger rs2_val for ALU to be immediate
                immediate = 21'(signed'({instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}));
            end
            7'b0110111: begin // LUI (U-type instruction)
                funct3 = 3'b0;
                funct7 = 7'b0;
                rd = instruction[11:7];
                rs1 = 5'b0;
                rs2 = 5'b0;
                use_imm = 1'b1;
                immediate = {instruction[31:12], 12'b0};
            end
            7'b0010111: begin // AUIPC (U-type instruction)
                funct3 = 3'b0;
                funct7 = 7'b0;
                rd = instruction[11:7];
                rs1 = 5'b0;
                rs2 = 5'b0;
                use_imm = 1'b1;
                immediate = {instruction[31:12], 12'b0};
            end
            7'b1101111: begin // JAL (UJ-type instruction)
                funct3 = 3'b0;
                funct7 = 7'b0;
                rd = instruction[11:7];
                rs1 = 5'b0;
                rs2 = 5'b0;
                use_imm = 1'b1;
                immediate = {instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            end
            7'b1110011: begin // System Calls
                funct3 = 3'b0;
                funct7 = 7'b0;
                rd = 5'b0;
                rs1 = 5'b0;
                rs2 = 5'b0;
                use_imm = 1'b1;
                immediate = 21'(signed'(instruction[31:20]));
            end
            default: begin // Unrecognized opcode
                funct3 = 3'b0;
                funct7 = 7'b0;
                rd = 5'b0;
                rs1 = 5'b0;
                rs2 = 5'b0;
                use_imm = 1'b0;
                immediate = 21'b0;
            end
        endcase
    end

endmodule