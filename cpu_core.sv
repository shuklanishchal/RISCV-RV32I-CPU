/*

Top-level module for the CPU core.

Inputs:
    - clk: 1-bit input for the clock
    - reset: 1-bit input for the reset switch

Note: all register names with stage names in front of it (ex. id_ or ex_) are meant to be used within
the always_ff block to save those values in the appropriate stage they are meant to be saved in.

*/

module cpu_core(clk, reset);
    input logic clk, reset;

    // Create register block
    logic signed [31:0] register [31:0];

    // Initialize instruction memory
    logic [31:0] pc, instruction, if_instruction;
    inst_mem inst_mem_cpu(.pc, .instruction);

    // Initialize instruction decoder
    logic [6:0] opcode, funct7, id_opcode, id_funct7;
    logic [2:0] funct3, id_funct3;
    logic [4:0] rd, rs1, rs2, id_rd, id_rs1, id_rs2;
    logic use_imm, id_use_imm;
    logic signed [20:0] immediate, id_immediate;
    inst_decoder decoder_cpu(.instruction(if_instruction), .opcode, .funct3, .funct7, .rd, .rs1, .rs2, .use_imm, .immediate);

    // Initialize ALU decoder
    logic [3:0] alu_op;
    alu_decoder alu_decoder_cpu(.opcode(id_opcode), .funct3(id_funct3), .funct7(id_funct7), .immediate(id_immediate), .alu_op);

    // Initialize ALU
    logic signed [31:0] rs1_val, rs2_val, rd_val, ex_rd_val;
    alu alu_cpu(.rs1_val, .rs2_val, .alu_op, .rd_val);

    // Initialize data memory
    logic read, write;
    logic signed [31:0] read_val, mem_read_val;
    data_mem cpu_memory(.clk, .read, .write, .funct3, .addr(ex_rd_val[8:0]), .write_val(register[id_rs2]), .read_val);

    always_comb begin
        case(id_opcode)
            7'b0010111: begin // AUIPC
                rs1_val = pc;
            end
            7'b1101111: begin // JAL
                rs1_val = pc;
            end
            default: begin
                rs1_val = register[id_rs1];
            end
        endcase
        rs2_val = use_imm ? 32'(signed'(immediate)) : register[id_rs2];
    end

    // PC incrementer
    logic [31:0] pc_next_inc;
    adder_bit32 increment_pc(.in0(pc), .in1(32'b0100), .sub(1'b0), .out(pc_next_inc));

    logic [31:0] pc_plus_imm;
    adder_bit32 increment_pc_imm(.in0(pc), .in1(id_immediate), .sub(1'b0), .out(pc_plus_imm));

    // Loop through each stage of multicycle CPU
    enum {stage_fetch, stage_decode, stage_execute, stage_memory, stage_writeback} current_stage;

    always_ff @(posedge clk) begin
        if(reset) begin
            pc <= 32'b0;
            for(integer i = 0; i < 32; i++) begin
                register[i] <= 32'b0;
            end
            current_stage <= stage_fetch;
        end else begin
            case(current_stage)
                stage_fetch: begin
                    //$write("Current Stage: Fetch\n");
                    $write("PC: %0h\n", pc);
                    if_instruction <= instruction;
                    current_stage <= stage_decode;
                end
                stage_decode: begin
                    $write("IF_instruction: %b\n\n", if_instruction);
                    //$write("Current Stage: Decode\n");
                    id_opcode <= opcode;
                    id_funct3 <= funct3;
                    id_funct7 <= funct7;
                    id_rd <= rd;
                    id_rs1 <= rs1;
                    id_rs2 <= rs2;
                    id_use_imm <= use_imm;
                    id_immediate <= immediate;
                    current_stage <= stage_execute;
                end
                stage_execute: begin
                    /*

                    // DEBUG

                    $write("ID_opcode: %b\n", id_opcode);
                    $write("ID_funct3: %b\n", id_funct3);
                    $write("ID_funct7: %b\n", id_funct7);
                    $write("ID_rd: %b\n", id_rd);
                    $write("ID_rs1: %b\n", id_rs1);
                    $write("ID_rs2: %b\n", id_rs2);
                    $write("ID_use_imm: %b\n", id_use_imm);
                    $write("ID_immediate: %b\n", id_immediate);
                    $write("Current Stage: Execute\n");
                    */
                    case(id_opcode)
                        7'b0000011: begin // Enable read on memory one cycle before memory for load operations
                            read <= 1'b1;
                            write <= 1'b0;
                            ex_rd_val <= rd_val;
                            current_stage <= stage_memory;
                        end
                        7'b0100011: begin // Prepare write values here for store instructions
                            read <= 1'b0;
                            write <= 1'b1;
                            ex_rd_val <= rd_val;
                            current_stage <= stage_memory;
                        end
                        default: begin
                            read <= 1'b0;
                            write <= 1'b0;
                            ex_rd_val <= rd_val;
                            current_stage <= stage_memory;
                        end
                    endcase
                end
                stage_memory: begin
                    /*

                    // DEBUG

                    $write("rs1_val: %b\n", rs1_val);
                    $write("rs2_val: %b\n", rs2_val);
                    $write("EX_rd_val: %b\n", ex_rd_val);
                    $write("read_val: %0d\n", read_val);
                    $write("read: %b\n", read);
                    $write("Current Stage: Memory\n");
                    */
                    case(id_opcode)
                        7'b0000011: begin // Load instruction
                            $write("Loading from memory address %0d (value %0h in hex, value %0d in decimal) to put into Register[%0d]...\n\n", ex_rd_val[8:0], read_val, read_val, id_rd);
                            mem_read_val <= read_val;
                            current_stage <= stage_writeback;
                        end
                        7'b0100011: begin // Store instruction
                            $write("Storing from Register[%0d] (value %0h in hex, value %0d in decimal) and putting into memory address %0d...\n\n", id_rs2, register[id_rs2], register[id_rs2], ex_rd_val[8:0]);
                            write <= 1'b0;
                            read <= 1'b0;
                            current_stage <= stage_writeback;
                        end
                        default: begin
                            current_stage <= stage_writeback;
                        end
                    endcase
                end
                stage_writeback: begin
                    /*

                    // DEBUG
                    
                    $write("MEM_read_val: %b\n\n", mem_read_val);
                    $write("Current Stage: Writeback\n");
                    */
                    write <= 1'b0;
                    read <= 1'b0;
                    case(id_opcode)
                        7'b0110011: begin // ALU instruction (R-type)
                            $write("Register[%0d] = %0d\n\n", id_rd, ex_rd_val);
                            if(id_rd != 5'b0) begin
                                register[id_rd] <= ex_rd_val;
                            end
                            pc <= pc_next_inc;
                            current_stage <= stage_fetch;
                        end
                        7'b0010011: begin // ALU instruction (I-type)
                            $write("Register[%0d] = %0d\n\n", id_rd, ex_rd_val);
                            if(id_rd != 5'b0) begin
                                register[id_rd] <= ex_rd_val;
                            end
                            pc <= pc_next_inc;
                            current_stage <= stage_fetch;
                        end
                        7'b0110111: begin // LUI (same as ALU instruction)
                            $write("Register[%0d] = %0d\n\n", id_rd, ex_rd_val);
                            if(id_rd != 5'b0) begin
                                register[id_rd] <= ex_rd_val;
                            end
                            pc <= pc_next_inc;
                            current_stage <= stage_fetch;
                        end
                        7'b0010111: begin // AUIPC (same as ALU instruction)
                            $write("Register[%0d] = %0d\n\n", id_rd, ex_rd_val);
                            if(id_rd != 5'b0) begin
                                register[id_rd] <= ex_rd_val;
                            end
                            pc <= pc_next_inc;
                            current_stage <= stage_fetch;
                        end
                        7'b0000011: begin // Load instruction
                            $write("Register[%0d] = %0d\n\n", id_rd, mem_read_val);
                            if(id_rd != 5'b0) begin
                                register[id_rd] <= mem_read_val;
                            end
                            pc <= pc_next_inc;
                            current_stage <= stage_fetch;
                        end
                        7'b1100011: begin // Branch instruction
                            case(ex_rd_val[0])
                                1'b0: begin
                                    $write("Branch condition not satisfied, moving to next PC.\n\n");
                                    pc <= pc_next_inc;
                                    current_stage <= stage_fetch;
                                end
                                1'b1: begin
                                    $write("Branch condition satisfied, moving to PC %0h.\n\n", pc_plus_imm);
                                    pc <= pc_plus_imm;
                                    current_stage <= stage_fetch;
                                end
                            endcase
                        end
                        7'b1101111: begin // JAL
                            $write("Jumping to PC %0h, storing %0h in Register[%0d].\n\n", ex_rd_val, pc_next_inc, id_rd);
                            if(id_rd != 5'b0) begin
                                register[id_rd] <= pc_next_inc;
                            end
                            pc <= ex_rd_val;
                            current_stage <= stage_fetch;
                        end
                        7'b1100111: begin // JALR
                            $write("Jumping to PC %0h, storing %0h in Register[%0d].\n\n", ex_rd_val, pc_next_inc, id_rd);
                            if(id_rd != 5'b0) begin
                                register[id_rd] <= pc_next_inc;
                            end
                            pc <= ex_rd_val;
                            current_stage <= stage_fetch;
                        end
                        7'b1110011: begin // System Call
                            case(id_immediate[0])
                                1'b0: begin // ECALL
                                    $write("ECALL Implementation Not Done Yet\n\n");
                                    pc <= pc_next_inc;
                                    current_stage <= stage_fetch;
                                end
                                1'b1: begin // EBREAK
                                    $write("\n\nReturned Value: %0d\n\n\n\n", register[10]);
                                    $finish;
                                end
                            endcase
                        end
                        default: begin
                            pc <= pc_next_inc;
                            current_stage <= stage_fetch;
                        end
                    endcase
                end
                default: begin
                    current_stage <= stage_fetch;
                end
            endcase
        end
    end
endmodule