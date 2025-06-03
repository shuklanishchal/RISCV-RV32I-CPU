/*

32-bit comparator circuit (both signed and unsigned)

Inputs:
    - a: 32-bit input of the first number
    - b: 32-bit input of the second number
    - is_signed: 1-input flag if comparison should be signed or unsigned
        - 1 if signed, 0 if unsigned
Outputs:
    - out_gt: 1-bit output of if the calculated comparison is greater than
    - out_lt: 1-bit output of if the calculated comparison is less than
    - out_eq: 1-bit output of if the calculated comparison is equal to

*/

module comparator_32bit(a, b, is_signed, out_gt, out_lt, out_eq);
    input logic [31:0] a, b;
    input logic is_signed;
    output logic out_gt, out_lt, out_eq;

    logic hold_a31not, hold_b31not;
    logic [31:0] a_new, b_new;

    // Store flipped MSB to use if number is signed
    not(hold_a31not, a[31]);
    not(hold_b31not, b[31]);

    // Use flipped MSB if number is signed
    always_comb begin
        if(is_signed) begin
            a_new[31] = hold_a31not;
            b_new[31] = hold_b31not;
        end else begin
            a_new[31] = a[31];
            b_new[31] = b[31];
        end
        a_new[30:0] = a[30:0];
        b_new[30:0] = b[30:0];
    end

    logic out_gt0, out_lt0, out_eq0, out_gt1, out_lt1, out_eq1, out_gt2, out_lt2, out_eq2, out_gt3, out_lt3, out_eq3,
          out_gt4, out_lt4, out_eq4, out_gt5, out_lt5, out_eq5, out_gt6, out_lt6, out_eq6;

    // Run 4-bit comparator for each set of 4 bits in ascending order
    // Cascading comparator circuit design
    comparator_4bit comp0(.a(a_new[3:0]), .b(b_new[3:0]), .in_gt(1'b0), .in_lt(1'b0), .in_eq(1'b1), .out_gt(out_gt0), .out_lt(out_lt0), .out_eq(out_eq0));
    comparator_4bit comp1(.a(a_new[7:4]), .b(b_new[7:4]), .in_gt(out_gt0), .in_lt(out_lt0), .in_eq(out_eq0), .out_gt(out_gt1), .out_lt(out_lt1), .out_eq(out_eq1));
    comparator_4bit comp2(.a(a_new[11:8]), .b(b_new[11:8]), .in_gt(out_gt1), .in_lt(out_lt1), .in_eq(out_eq1), .out_gt(out_gt2), .out_lt(out_lt2), .out_eq(out_eq2));
    comparator_4bit comp3(.a(a_new[15:12]), .b(b_new[15:12]), .in_gt(out_gt2), .in_lt(out_lt2), .in_eq(out_eq2), .out_gt(out_gt3), .out_lt(out_lt3), .out_eq(out_eq3));
    comparator_4bit comp4(.a(a_new[19:16]), .b(b_new[19:16]), .in_gt(out_gt3), .in_lt(out_lt3), .in_eq(out_eq3), .out_gt(out_gt4), .out_lt(out_lt4), .out_eq(out_eq4));
    comparator_4bit comp5(.a(a_new[23:20]), .b(b_new[23:20]), .in_gt(out_gt4), .in_lt(out_lt4), .in_eq(out_eq4), .out_gt(out_gt5), .out_lt(out_lt5), .out_eq(out_eq5));
    comparator_4bit comp6(.a(a_new[27:24]), .b(b_new[27:24]), .in_gt(out_gt5), .in_lt(out_lt5), .in_eq(out_eq5), .out_gt(out_gt6), .out_lt(out_lt6), .out_eq(out_eq6));
    comparator_4bit comp7(.a(a_new[31:28]), .b(b_new[31:28]), .in_gt(out_gt6), .in_lt(out_lt6), .in_eq(out_eq6), .out_gt(out_gt), .out_lt(out_lt), .out_eq(out_eq));

endmodule