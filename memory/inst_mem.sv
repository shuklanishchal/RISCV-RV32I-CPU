/*

Instruction memory initializer. Takes in hexadecimal instructions from code.hex file and
puts instructions in memory after every 4 spaces.

Inputs:
    - pc: 32-bit input of which program counter to access instruction from
Outputs:
    - instruction: 32-bit instruction output from program counter

*/

module inst_mem(pc, instruction);
    input logic [31:0] pc;
    output logic [31:0] instruction;

    integer fd, status, count;

    // Initialize instruction memory
    logic [31:0] instruction_memory [1073741823:0];

    initial begin

        // Open hex file containing instructions in hexadecimal format
        fd = $fopen("memory/code.hex", "r");
        if(!fd) begin
            $display("File was NOT opened successfully : %0d", fd);
        end

        // Put instruction after every 4 spaces (corresponding to program counter)
        count = 0;
        while(!$feof(fd)) begin
            status = $fscanf(fd, "%h", instruction_memory[count]);
            count = count + 4;
        end

        $fclose(fd);
    end

    assign instruction = instruction_memory[pc];

endmodule