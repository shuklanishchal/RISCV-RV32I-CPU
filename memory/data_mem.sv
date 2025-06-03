/*

Data memory implementation in byte-addressable format.

Inputs:
    - clk: 1-bit input for the clock
    - read: 1-bit flag for if value needs to be read from memory
        - 1 if yes, 0 if no
    - write: 1-bit flag for if value needs to be written to memory
        - 1 if yes, 0 if no
    - funct3: the funct3 of the RISC-V instruction
        - Helps determine if byte, halfword, or word needs to be read/written
    - addr: 8-bit input for the memory address to write to/read from
        - Real RISC-V processor will have a 32-bit address, but SystemVerilog and Icarus Verilog cannot support that much
    - write_val: 32-bit input for the value to be written
        - Will only be written if write is set to 1

Outputs:
    - read-val: 32-bit output for the value read from the memory address
        - Will only be read if read is set to 1, otherwise set to 0
*/

module data_mem(clk, read, write, funct3, addr, write_val, read_val);
    input logic clk, read, write;
    input logic [2:0] funct3;
    input logic [8:0] addr;
    input logic [31:0] write_val;
    output logic [31:0] read_val;

    // Obtain addresses for the other 3 bytes that the memory needs to access for full word read
    logic [31:0] addr_1, addr_2, addr_3;

    assign addr_1 = {addr[8:2], 2'b01};
    assign addr_2 = {addr[8:2], 2'b10};
    assign addr_3 = {addr[8:2], 2'b11};

    logic [7:0] data_memory [511:0];

    // Initialize all data memory to zero
    initial begin
        for(integer i = 0; i < 512; i++) begin
            data_memory[i] = 8'b0;
        end
    end

    // Handle memory read operation (unclocked)
    always_comb begin
        if(read) begin
            case(funct3)
                3'b000: begin // LB
                    read_val = 32'(signed'(data_memory[addr]));
                end
                3'b001: begin // LH
                    read_val = 32'(signed'({data_memory[addr_1], data_memory[addr]}));
                end
                3'b010: begin // LW
                    read_val = {data_memory[addr_3], data_memory[addr_2], data_memory[addr_1], data_memory[addr]};
                end
                3'b100: begin // LBU
                    read_val = {24'b0, data_memory[addr]};
                end
                3'b101: begin // LHU
                    read_val = {16'b0, data_memory[addr_1], data_memory[addr]};
                end
                default: begin
                    read_val = 32'b0;
                end
            endcase
        end else begin
            read_val = 32'b0;
        end
    end

    // Handle memory write operation (clocked)
    always_ff @(posedge clk) begin
        if(write) begin
            case(funct3)
                3'b000: begin // SB
                    data_memory[addr] <= write_val[7:0];
                end
                3'b001: begin // SH
                    data_memory[addr] <= write_val[7:0];
                    data_memory[addr_1] <= write_val[15:8];
                end
                3'b010: begin // SW
                    data_memory[addr] <= write_val[7:0];
                    data_memory[addr_1] <= write_val[15:8];
                    data_memory[addr_2] <= write_val[23:16];
                    data_memory[addr_3] <= write_val[31:24];
                end
                default: begin
                    data_memory[addr] <= 8'b0;
                end
            endcase
        end
    end


endmodule