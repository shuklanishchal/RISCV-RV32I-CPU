/*

3-input AND gate.

Inputs:
    - a: 1-bit first input
    - b: 1-bit second input
    - c: 1-bit third input
Outpus:
    - out: 1-bit result

*/

module and3(out, a, b, c);
    input logic a, b, c;
    output logic out;

    logic a_and_b;
    and(a_and_b, a, b);
    and(out, a_and_b, c);
endmodule