/*

Full ALU implementation.

Inputs:
    - rs1_val: 32-bit input for the rs1 register value
    - rs2_val: 32-bit input for the rs2 register value (or immediate)
    - alu_op: 4-bit input for the ALU operation to perform
        - Defined further below in case statement
Outputs:
    - rd_val: 32-bit output for the output register value

*/

module alu(rs1_val, rs2_val, alu_op, rd_val);
    input logic [31:0] rs1_val, rs2_val;
    input logic [3:0] alu_op;
    output logic [31:0] rd_val;

    // Create registers for module outputs
    logic sub, dir, arithmetic, is_signed, out_gt, out_lt, out_eq;
    logic [31:0] adder_result, shifter_result, xor_result, or_result, and_result;

    // Bitwise operator result storage
    xor32 rsxor(.out(xor_result), .in0(rs1_val), .in1(rs2_val));
    or32 rsor(.out(or_result), .in0(rs1_val), .in1(rs2_val));
    and32 rsand(.out(and_result), .in0(rs1_val), .in1(rs2_val));

    // Initialize adder, shifter, and comparator modules
    adder_bit32 add(.in0(rs1_val), .in1(rs2_val), .sub, .out(adder_result));
    barrel_shifter shift(.in(rs1_val), .how_many(rs2_val[4:0]), .dir, .arithmetic, .out(shifter_result));
    comparator_32bit compare(.a(rs1_val), .b(rs2_val), .is_signed, .out_gt, .out_lt, .out_eq);

    // Assign values based on ALU operation performed
    always_comb begin
        case(alu_op)
            4'b0000: begin // ADD
                sub = 0; // Relevant
                dir = 0;
                arithmetic = 0;
                is_signed = 0;
                rd_val = adder_result;
            end
            4'b0001: begin // SUB
                sub = 1; // Relevant
                dir = 0;
                arithmetic = 0;
                is_signed = 0;
                rd_val = adder_result;
            end
            4'b0010: begin // SLL
                sub = 0;
                dir = 0; // Relevant
                arithmetic = 0; // Relevant
                is_signed = 0;
                rd_val = shifter_result;
            end
            4'b0011: begin // SLT, BLT
                sub = 0;
                dir = 0;
                arithmetic = 0;
                is_signed = 1; // Relevant
                rd_val = {31'b0, out_lt};
            end
            4'b0100: begin // SLTU, BLTU
                sub = 0;
                dir = 0;
                arithmetic = 0;
                is_signed = 0; // Relevant
                rd_val = {31'b0, out_lt};
            end
            4'b0101: begin // XOR
                sub = 0;
                dir = 0;
                arithmetic = 0;
                is_signed = 0;
                rd_val = xor_result;
            end
            4'b0110: begin // SRL
                sub = 0;
                dir = 1; // Relevant
                arithmetic = 0; // Relevant
                is_signed = 0;
                rd_val = shifter_result;
            end
            4'b0111: begin //SRA
                sub = 0;
                dir = 1; // Relevant
                arithmetic = 1; // Relevant
                is_signed = 0;
                rd_val = shifter_result;
            end
            4'b1000: begin //OR
                sub = 0;
                dir = 0;
                arithmetic = 0;
                is_signed = 0;
                rd_val = or_result;
            end
            4'b1001: begin //AND
                sub = 0;
                dir = 0;
                arithmetic = 0;
                is_signed = 0;
                rd_val = and_result;
            end

            // Skip 4'b1010 (used as None for alu_decoder)

            4'b1011: begin // BEQ, BNE
                sub = 0;
                dir = 0;
                arithmetic = 0;
                is_signed = 1; // Relevant
                rd_val = {31'b0, out_eq};
            end
            4'b1100: begin // BGE
                sub = 0;
                dir = 0;
                arithmetic = 0;
                is_signed = 1; // Relevant
                rd_val = {31'b0, out_gt};
            end
            4'b1100: begin // BGEU
                sub = 0;
                dir = 0;
                arithmetic = 0;
                is_signed = 0; // Relevant
                rd_val = {31'b0, out_gt};
            end
            default: begin
                sub = 0;
                dir = 0;
                arithmetic = 0;
                is_signed = 0;
                rd_val = 32'b0;
            end
        endcase
    end
endmodule