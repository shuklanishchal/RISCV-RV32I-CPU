/*

Testbench code for the inst_decoder module

*/

module inst_decoder_testbench();
    logic [31:0] instruction;
    logic [6:0] opcode, funct7;
    logic [2:0] funct3;
    logic [4:0] rd, rs1, rs2;
    logic use_imm;
    logic signed [20:0] immediate;

    inst_decoder dut(.instruction, .opcode, .funct3, .funct7, .rd, .rs1, .rs2, .use_imm, .immediate);

    integer fd, status;
    
    initial begin

        // Open code hex file
        fd = $fopen("testbench_sv/inst_decoder_code.hex", "r");
        if(!fd) begin
            $display("File was NOT opened successfully : %0d", fd);
        end

        // Test decoder on every line in code hex file
        for(integer i = 0; i < 605; i++) begin

            // Obtain instruction line from code hex file and print instruction in binary form
            status = $fscanf(fd, "%h", instruction); #10;
            $write("Instruction: %b \n", instruction);

            // Print instruction in assembly form to test if decoded values are correct
            case(opcode)
                7'b0110011: begin
                    case(funct3)
                        3'b000: begin
                            case(funct7)
                                7'b0: begin
                                    $write("add x%0d, x%0d, x%0d\n", rd, rs1, rs2);
                                end
                                7'b0100000: begin
                                    $write("sub x%0d, x%0d, x%0d\n", rd, rs1, rs2);
                                end
                                default: begin
                                    $write("Unrecognized R-type instruction with funct3 %b and funct7 %b\n", funct3, funct7);
                                end
                            endcase
                        end
                        3'b001: begin
                            $write("sll x%0d, x%0d, x%0d\n", rd, rs1, rs2);
                        end
                        3'b010: begin
                            $write("slt x%0d, x%0d, x%0d\n", rd, rs1, rs2);
                        end
                        3'b011: begin
                            $write("sltu x%0d, x%0d, x%0d\n", rd, rs1, rs2);
                        end
                        3'b100: begin
                            $write("xor x%0d, x%0d, x%0d\n", rd, rs1, rs2);
                        end
                        3'b101: begin
                            case(funct7)
                                7'b0: begin
                                    $write("srl x%0d, x%0d, x%0d\n", rd, rs1, rs2);
                                end
                                7'b0100000: begin
                                    $write("sra x%0d, x%0d, x%0d\n", rd, rs1, rs2);
                                end
                                default: begin
                                    $write("Unrecognized R-type instruction with funct3 %b and funct7 %b\n", funct3, funct7);
                                end
                            endcase
                        end
                        3'b110: begin
                            $write("or x%0d, x%0d, x%0d\n", rd, rs1, rs2);
                        end
                        3'b111: begin
                            $write("and x%0d, x%0d, x%0d\n", rd, rs1, rs2);
                        end
                        default: begin
                            $write("Unrecognized R-type instruction with funct3 %b\n", funct3);
                        end
                    endcase
                end
                7'b0010011: begin
                    case(funct3)
                        3'b000: begin
                            $write("addi x%0d, x%0d, %0d\n", rd, rs1, immediate);
                        end
                        3'b001: begin
                            $write("slli x%0d, x%0d, %0d\n", rd, rs1, immediate);
                        end
                        3'b010: begin
                            $write("slti x%0d, x%0d, %0d\n", rd, rs1, immediate);
                        end
                        3'b011: begin
                            $write("sltiu x%0d, x%0d, %0d\n", rd, rs1, immediate);
                        end
                        3'b100: begin
                            $write("xori x%0d, x%0d, %0d\n", rd, rs1, immediate);
                        end
                        3'b101: begin
                            case(instruction[31:25])
                                7'b0: begin
                                    $write("srli x%0d, x%0d, %0d\n", rd, rs1, immediate);
                                end
                                7'b0100000: begin
                                    $write("srai x%0d, x%0d, %0d\n", rd, rs1, immediate);
                                end
                                default: begin
                                    $write("Unrecognized I-type instruction with funct3 %b and immediate %b\n", funct3, immediate);
                                end
                            endcase
                        end
                        3'b110: begin
                            $write("ori x%0d, x%0d, %0d\n", rd, rs1, immediate);
                        end
                        3'b111: begin
                            $write("andi x%0d, x%0d, %0d\n", rd, rs1, immediate);
                        end
                        default: begin
                            $write("Unrecognized I-type Instruction with funct3 %b\n", funct3);
                        end
                    endcase
                end
                7'b0000011: begin
                    case(funct3)
                        3'b000: begin
                            $write("lb x%0d, %0d(x%0d)\n", rd, immediate, rs1);
                        end
                        3'b001: begin
                            $write("lh x%0d, %0d(x%0d)\n", rd, immediate, rs1);
                        end
                        3'b010: begin
                            $write("lw x%0d, %0d(x%0d)\n", rd, immediate, rs1);
                        end
                        3'b100: begin
                            $write("lbu x%0d, %0d(x%0d)\n", rd, immediate, rs1);
                        end
                        3'b101: begin
                            $write("lhu x%0d, %0d(x%0d)\n", rd, immediate, rs1);
                        end
                        default: begin
                            $write("Unrecognized load instruction with funct3 %b\n", funct3);
                        end
                    endcase
                end
                7'b1100111: begin
                    $write("jalr x%0d, %0d(x%0d)\n", rd, immediate, rs1);
                end
                7'b0100011: begin
                    case(funct3)
                        3'b000: begin
                            $write("sb x%0d, %0d(x%0d)\n", rs2, immediate, rs1);
                        end
                        3'b001: begin
                            $write("sh x%0d, %0d(x%0d)\n", rs2, immediate, rs1);
                        end
                        3'b010: begin
                            $write("sw x%0d, %0d(x%0d)\n", rs2, immediate, rs1);
                        end
                        default: begin
                            $write("Unrecognized store instruction with funct3 %b\n", funct3);
                        end
                    endcase
                end
                7'b1100011: begin
                    case(funct3)
                        3'b000: begin
                            $write("beq x%0d, x%0d, %0d\n", rs1, rs2, immediate);
                        end
                        3'b001: begin
                            $write("bne x%0d, x%0d, %0d\n", rs1, rs2, immediate);
                        end
                        3'b100: begin
                            $write("blt x%0d, x%0d, %0d\n", rs1, rs2, immediate);
                        end
                        3'b101: begin
                            $write("bge x%0d, x%0d, %0d\n", rs1, rs2, immediate);
                        end
                        3'b110: begin
                            $write("bltu x%0d, x%0d, %0d\n", rs1, rs2, immediate);
                        end
                        3'b111: begin
                            $write("bgeu x%0d, x%0d, %0d\n", rs1, rs2, immediate);
                        end
                        default: begin
                            $write("Unrecognized branch instruction with funct3 %b\n", funct3);
                        end
                    endcase
                end
                7'b0110111: begin
                    $write("lui x%0d, %0d\n", rd, immediate);
                end
                7'b0010111: begin
                    $write("auipc x%0d, %0d\n", rd, immediate);
                end
                7'b1101111: begin
                    $write("jal x%0d, %0d\n", rd, immediate);
                end
                7'b1110011: begin
                    case(immediate[0])
                        1'b0: begin
                            $write("ecall\n");
                        end
                        1'b1: begin
                            $write("ebreak\n");
                        end
                    endcase
                end
                default: begin
                    $write("Unknown instruction\n");
                end
            endcase

            // Print decoded instructions
            /*
            $write("Opcode: %b\n", opcode);
            $write("Funct3: %b\n", funct3);
            $write("Funct7: %b\n", funct7);
            $write("RD: %b\n", rd);
            $write("RS1: %b\n", rs1);
            $write("RS2: %b\n", rs2);
            $write("Use Immediate: %b\n", use_imm);
            $write("Immediate: %b\n", immediate);
            $write("12-bit Offset: %b\n", offset);
            $write("Branch Offset: %b\n", branch_offset);
            $write("5-bit Offset: %b\n", bit5_offset);
            */
            $write("\n");
        end
    end
    
endmodule