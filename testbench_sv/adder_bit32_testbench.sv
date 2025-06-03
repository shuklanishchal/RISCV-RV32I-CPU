/*

Testbench code for the adder_bit32 module

*/

module adder_bit32_testbench();
    logic [31:0] in0, in1, out;
    logic sub, cout;

    adder_bit32 dut(.in0, .in1, .sub, .out, .cout);

    initial begin
        $dumpfile("testbench_vcd/adder_bit32_testbench.vcd");
        $dumpvars(0, adder_bit32_testbench);
        in0 = 6; in1 = 5; sub = 1; #10;
        in0 = 543; in1 = 675; sub = 0; #10;
        in0 = 543; in1 = 675; sub = 1; #10;
        in0 = 675; in1 = 543; sub = 1; #10;
        in0 = -32; in1 = 45; sub = 0; #10;
        in0 = -32; in1 = 45; sub = 1; #10;
        in0 = 1; in1 = -1; sub = 0; #10;
        in0 = 1; in1 = -1; sub = 1; #10;
        in0 = 32'b11111111111111111111111111111111; in1 = 1; sub = 0; #10;
    end
endmodule