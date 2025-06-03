/*

4-input AND gate.

Inputs:
    - a: 1-bit first input
    - b: 1-bit second input
    - c: 1-bit third input
    - d: 1-bit fourth input
Outpus:
    - out: 1-bit result

*/

module and4(out, a, b, c, d);
    input logic a, b, c, d;
    output logic out;

    logic first_3_ands;
    and3 ander(.a, .b, .c, .out(first_3_ands));
    and(out, first_3_ands, d);
endmodule