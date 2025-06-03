/*

Testbench code for the comparator_4bit module

*/

module comparator_4bit_testbench();
    logic [3:0] a, b;
    logic in_gt, in_lt, in_eq, out_gt, out_lt, out_eq;

    comparator_4bit dut(.a, .b, .in_gt, .in_lt, .in_eq, .out_gt, .out_lt, .out_eq);

    initial begin
        $dumpfile("testbench_vcd/comparator_4bit_testbench.vcd");
        $dumpvars(0, comparator_4bit_testbench);
        for(integer i = 0; i < 15; i++) begin
            a = i; b = i - 1; in_gt = 0; in_lt = 0; in_eq = 1; #10;
            a = i; b = i + 1; in_gt = 0; in_lt = 0; in_eq = 1; #10;
            a = i; b = i; in_gt = 0; in_lt = 0; in_eq = 1; #10;
        end
    end
endmodule