/*

Testbench code for the comparator_32bit module

*/

module comparator_32bit_testbench();
    logic [31:0] a, b;
    logic is_signed, out_gt, out_lt, out_eq;

    comparator_32bit dut(.a, .b, .is_signed, .out_gt, .out_lt, .out_eq);

    initial begin
        $dumpfile("testbench_vcd/comparator_32bit_testbench.vcd");
        $dumpvars(0, comparator_32bit_testbench);
        for(integer i = 0; i < 257; i++) begin
            a = i; b = i - 1; is_signed = 0; #10;
            a = i; b = i + 1; is_signed = 0; #10;
            a = i; b = i; is_signed = 0; #10;
            a = i; b = i - 1; is_signed = 1; #10;
            a = i; b = i + 1; is_signed = 1; #10;
            a = i; b = i; is_signed = 1; #10;
        end
        a = 32'b11111111111111111111111111111111; b = 32'b0; is_signed = 0; #10;
        a = 32'b11111111111111111111111111111111; b = 32'b0; is_signed = 1; #10;
        a = 32'b0; b = 32'b11111111111111111111111111111111; is_signed = 0; #10;
        a = 32'b0; b = 32'b11111111111111111111111111111111; is_signed = 1; #10;
    end
endmodule