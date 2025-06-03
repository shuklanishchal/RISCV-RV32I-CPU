/*

One-bit full adder implementation in SystemVerilog.

Inputs:
    - a: 1-bit input for the first number
    - b: 1-bit input for the second number
    - cin: 1-bit input for the carry in
Outputs:
    - s: 1-bit output for the addition result
    - cout: 1-bit output for the carry out

*/

module adder(a, b, cin, s, cout);
    input logic a, b, cin;
    output logic s, cout;

    logic xorab;
    xor(xorab, a, b);

    xor(s, xorab, cin);
    
    logic and0, and1;
    and(and0, xorab, cin);
    and(and1, a, b);
    or(cout, and0, and1);
endmodule