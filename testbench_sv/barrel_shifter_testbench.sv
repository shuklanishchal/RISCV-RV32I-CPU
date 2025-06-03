/*

Testbench code for the barrel_shifter module

*/


module barrel_shifter_testbench();
    logic [31:0] in, out;
    logic dir, arithmetic;
    logic [4:0] how_many;

    barrel_shifter dut(.in, .how_many, .dir, .arithmetic, .out);

    initial begin
        $dumpfile("testbench_vcd/barrel_shifter_testbench.vcd");
        $dumpvars(0, barrel_shifter_testbench);
        for(integer i = 0; i < 33; i++) begin
            in = 32'b11111111111111111111111111111111; how_many = i; dir = 1'b0; arithmetic = 1'b0; #10;
        end
        for(integer i = 0; i < 33; i++) begin
            in = 32'b11111111111111111111111111111111; how_many = i; dir = 1'b1; arithmetic = 1'b0; #10;
            in = 32'b11111111111111111111111111111111; how_many = i; dir = 1'b1; arithmetic = 1'b1; #10;
        end
    end
endmodule