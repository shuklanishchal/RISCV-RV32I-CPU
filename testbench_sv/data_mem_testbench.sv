/*

Testbench code for the data_mem module

*/

module data_mem_testbench();
    logic clk, read, write;
    logic [2:0] funct3;
    logic [31:0] write_val, read_val;
    logic [7:0] addr;

    data_mem dut(.clk, .read, .funct3, .addr, .write, .write_val, .read_val);

    parameter clock_period = 100;
    initial begin
        clk <= 0;
        forever #(clock_period / 2) clk <= ~clk;
    end

    initial begin
        $dumpfile("testbench_vcd/data_mem_testbench.vcd");
        $dumpvars(0, data_mem_testbench);
        @(posedge clk);
        read <= 0; funct3 <= 3'b000; addr <= -16; write <= 1; write_val <= 453; @(posedge clk);
        write <= 0; read <= 1; @(posedge clk);
        read <= 0; funct3 <= 3'b001; addr <= 4; write <= 1; write_val <= 345; @(posedge clk);
        write <= 0; read <= 1; @(posedge clk);
        read <= 0; funct3 <= 3'b010; addr <= 0; write <= 1; write_val <= 247; @(posedge clk);
        write <= 0; read <= 1; @(posedge clk);
        addr <= 4; @(posedge clk);
        $finish;
    end
endmodule