/*

4-bit comparator circuit implementation.

Inputs:
    - a: 4-bit input of the first number
    - b: 4-bit input of the second number
    - in_gt: 1-bit input of if the previous comparison was greater than
    - in_lt: 1-bit input of if the previous comparison was less than
    - in_eq: 1-bit input of if the previous comparison was equal to
Outputs:
    - out_gt: 1-bit output of if the calculated comparison is greater than
    - out_lt: 1-bit output of if the calculated comparison is less than
    - out_eq: 1-bit output of if the calculated comparison is equal to

*/

module comparator_4bit(a, b, in_gt, in_lt, in_eq,
                       out_gt, out_lt, out_eq);
    input logic [3:0] a, b;
    input logic in_gt, in_lt, in_eq;
    output logic out_gt, out_lt, out_eq;

    logic nota0, nota1, nota2, nota3;
    not(nota0, a[0]);
    not(nota1, a[1]);
    not(nota2, a[2]);
    not(nota3, a[3]);

    logic notb0, notb1, notb2, notb3;
    not(notb0, b[0]);
    not(notb1, b[1]);
    not(notb2, b[2]);
    not(notb3, b[3]);

    logic and0a, and0b, and1a, and1b, and2a, and2b, and3a, and3b;
    and(and0a, a[0], notb0);
    and(and0b, b[0], nota0);
    and(and1a, a[1], notb1);
    and(and1b, b[1], nota1);
    and(and2a, a[2], notb2);
    and(and2b, b[2], nota2);
    and(and3a, a[3], notb3);
    and(and3b, b[3], nota3);

    logic nor0, nor1, nor2, nor3;
    nor(nor0, and0a, and0b);
    nor(nor1, and1a, and1b);
    nor(nor2, and2a, and2b);
    nor(nor3, and3a, and3b);

    logic and4bit0, and4bit1, and3bit2, and3bit3, and2bit4, and2bit5;
    and4 ander0(and4bit0, and0a, nor1, nor2, nor3);
    and4 ander1(and4bit1, and0b, nor1, nor2, nor3);
    and3 ander2(and3bit2, and1a, nor2, nor3);
    and3 ander3(and3bit3, and1b, nor2, nor3);
    and(and2bit4, and2a, nor3);
    and(and2bit5, and2b, nor3);

    logic curr_gt, curr_lt;
    or4 orer0(curr_gt, and4bit0, and3bit2, and2bit4, and3a);
    or4 orer1(curr_lt, and4bit1, and3bit3, and2bit5, and3b);

    logic curr_eq;
    and4 ander4(curr_eq, nor0, nor1, nor2, nor3);

    logic immand0, immand1;
    and(immand0, curr_eq, in_gt);
    and(immand1, curr_eq, in_lt);

    or(out_gt, immand0, curr_gt);
    or(out_lt, immand1, curr_lt);
    and(out_eq, curr_eq, in_eq);
endmodule
