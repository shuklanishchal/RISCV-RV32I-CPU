/*

4-input OR gate.

Inputs:
    - a: 1-bit first input
    - b: 1-bit second input
    - c: 1-bit third input
    - d: 1-bit fourth input
Outpus:
    - out: 1-bit result

*/

module or4(out, a, b, c, d);
    input logic a, b, c, d;
    output logic out;

    logic or_a_b, or_c_d;
    or(or_a_b, a, b);
    or(or_c_d, c, d);
    or(out, or_a_b, or_c_d);
endmodule