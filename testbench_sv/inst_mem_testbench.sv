/*

Testbench code for the inst_mem module

*/

module inst_mem_testbench();
    logic [31:0] pc, instruction;

    inst_mem dut(.pc, .instruction);

    initial begin
        for(integer i = 0; i < 101; i++) begin
            pc = i;
            $display("Instruction: %b", instruction);
        end
    end
endmodule