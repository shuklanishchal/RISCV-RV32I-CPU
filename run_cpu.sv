module run_cpu();
    logic clk, reset;

    cpu_core dut(.clk, .reset);

    parameter clock_period = 100;
    initial begin
        clk <= 0;
        forever #(clock_period / 2) clk <= ~clk;
    end

    initial begin
        reset <= 1; @(posedge clk);
        reset <= 0; @(posedge clk);
        forever @(posedge clk);
    end
endmodule