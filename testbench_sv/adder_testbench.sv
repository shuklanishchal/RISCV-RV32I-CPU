/*

Testbench code for the adder module

*/

module adder_testbench();
    logic a, b, cin, s, cout;

    adder dut(.a, .b, .cin, .s, .cout);

    initial begin
        $dumpfile("testbench_vcd/adder_testbench.vcd");
        $dumpvars(0, adder_testbench);
        a = 0; b = 0; cin = 0; #10;
        a = 0; b = 0; cin = 1; #10;
        a = 0; b = 1; cin = 0; #10;
        a = 0; b = 1; cin = 1; #10;
        a = 1; b = 0; cin = 0; #10;
        a = 1; b = 0; cin = 1; #10;
        a = 1; b = 1; cin = 0; #10;
        a = 1; b = 1; cin = 1; #10;
    end
endmodule