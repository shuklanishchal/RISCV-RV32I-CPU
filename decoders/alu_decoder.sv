module alu_decoder(opcode, funct3, funct7, immediate, alu_op);
    input logic [6:0] opcode, funct7;
    input logic [2:0] funct3;
    input logic [20:0] immediate;
    output logic [3:0] alu_op;

    always_comb begin
        case(opcode)
            7'b0110011: begin
                case(funct3)
                    3'b000: begin
                        case(funct7)
                            7'b0: begin
                                alu_op = 4'b0000; // ADD
                            end
                            7'b0100000: begin
                                alu_op = 4'b0001; // SUB
                            end
                            default: begin
                                alu_op = 4'b1010; // None
                            end
                        endcase
                    end
                    3'b001: begin
                        alu_op = 4'b0010; // SLL
                    end
                    3'b010: begin
                        alu_op = 4'b0011; // SLT
                    end
                    3'b011: begin
                        alu_op = 4'b0100; // SLTU
                    end
                    3'b100: begin
                        alu_op = 4'b0101; // XOR
                    end
                    3'b101: begin
                        case(funct7)
                            7'b0: begin
                                alu_op = 4'b0110; // SRL
                            end
                            7'b0100000: begin
                                alu_op = 4'b0111; // SRA
                            end
                            default: begin
                                alu_op = 4'b1010; // None
                            end
                        endcase
                    end
                    3'b110: begin
                        alu_op = 4'b1000; // OR
                    end
                    3'b111: begin
                        alu_op = 4'b1001; // AND
                    end
                    default: begin
                        alu_op = 4'b1010; // None
                    end
                endcase
            end
            7'b0010011: begin
                case(funct3)
                    3'b000: begin
                        alu_op = 4'b0000; // ADDI
                    end
                    3'b001: begin
                        alu_op = 4'b0010; // SLLI
                    end
                    3'b010: begin
                        alu_op = 4'b0011; // SLTI
                    end
                    3'b011: begin
                        alu_op = 4'b0100; // SLTIU
                    end
                    3'b100: begin
                        alu_op = 4'b0101; // XORI
                    end
                    3'b101: begin
                        case(funct7)
                            7'b0: begin
                                alu_op = 4'b0110; // SRLI
                            end
                            7'b0100000: begin
                                alu_op = 4'b0111; // SRAI
                            end
                            default: begin
                                alu_op = 4'b1010; // None
                            end
                        endcase
                    end
                    3'b110: begin
                        alu_op = 4'b1000; // ORI
                    end
                    3'b111: begin
                        alu_op = 4'b1001; // ANDI
                    end
                    default: begin
                        alu_op = 4'b1010; // None
                    end
                endcase
            end
            7'b0110111: begin
                alu_op = 4'b0000; // LUI (can use add ALU operation in this implementation)
            end
            7'b0010111: begin
                alu_op = 4'b0000; // AUIPC (can use add ALU operation in this implementation)
            end
            7'b0000011: begin
                alu_op = 4'b0000; // Load instructions (need to add rs1 and offset value for memory address)
            end
            7'b0100011: begin
                alu_op = 4'b0000; // Store instructions (need to add rs1 and offset value for memory address)
            end
            7'b1100011: begin
                case(funct3)
                    3'b000: begin
                        alu_op = 4'b1011; // BEQ
                    end
                    3'b001: begin
                        alu_op = 4'b1011; // BNE (same as BGE ALU)
                    end
                    3'b100: begin
                        alu_op = 4'b0011; // BLT (can use SLT ALU)
                    end
                    3'b101: begin
                        alu_op = 4'b1100; // BGE
                    end
                    3'b110: begin
                        alu_op = 4'b0100; // BLTU (can use SLTU ALU)
                    end
                    3'b111: begin
                        alu_op = 4'b1100; // BGEU
                    end
                    default: begin
                        alu_op = 4'b1010; // None
                    end
                endcase
            end
            7'b1101111: begin
                alu_op = 4'b0000; // JAL (can use add ALU operation in this implementation)
            end
            7'b1100111: begin
                alu_op = 4'b0000; // JALR (can use add ALU operation in this implementation)
            end
            default: begin
                alu_op = 4'b1010; // None
            end
        endcase
    end
endmodule