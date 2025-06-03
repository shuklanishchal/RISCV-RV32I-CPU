/*

Barrel shifter implemenetation (no rotation).

Inputs:
    - in: 32-bit input for what needs to be shifted
    - how_many: 5-bit input for how many places to shift by
    - dir: 1-bit boolean specifying which direction to shift
        - 0 if left, 1 if right
    - arithmetic: 1-bit boolean specifying if using arithmetic or logical shift
        - 0 if logical, 1 if arithmetic
Outputs:
    - out: 32-bit result of the shifting operation

*/

module barrel_shifter(in, how_many, dir, arithmetic, out);
    input logic [31:0] in;
    input logic [4:0] how_many;
    input logic dir;
    input logic arithmetic;
    output logic [31:0] out;

    logic [31:0] s0, s1, s2, s3;
    always_comb begin
        if(dir) begin
            if(arithmetic) begin
                s0 = how_many[0] ? 32'(signed'(in[31:1])) : in;
                s1 = how_many[1] ? 32'(signed'(s0[31:2])) : s0;
                s2 = how_many[2] ? 32'(signed'(s1[31:4])) : s1;
                s3 = how_many[3] ? 32'(signed'(s2[31:8])) : s2;
                out = how_many[4] ? 32'(signed'(s3[31:16])) : s3;
            end else begin
                s0 = how_many[0] ? {1'b0, in[31:1]} : in;
                s1 = how_many[1] ? {2'b0, s0[31:2]} : s0;
                s2 = how_many[2] ? {4'b0, s1[31:4]} : s1;
                s3 = how_many[3] ? {8'b0, s2[31:8]} : s2;
                out = how_many[4] ? {16'b0, s3[31:16]} : s3;
            end
        end else begin
            s0 = how_many[0] ? {in[30:0], 1'b0} : in;
            s1 = how_many[1] ? {s0[29:0], 2'b0} : s0;
            s2 = how_many[2] ? {s1[27:0], 4'b0} : s1;
            s3 = how_many[3] ? {s2[23:0], 8'b0} : s2;
            out = how_many[4] ? {s3[15:0], 16'b0} : s3;
        end
    end
endmodule
