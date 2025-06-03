/*

32-bit OR gate.

Inputs:
    - in0: 32-bit first input
    - in1: 32-bit second input
Outputs:
    - out: 32-bit result of ORing inputs

*/

module or32(in0, in1, out);
    input logic [31:0] in0, in1;
    output logic [31:0] out;

    or(out[0], in0[0], in1[0]);
    or(out[1], in0[1], in1[1]);
    or(out[2], in0[2], in1[2]);
    or(out[3], in0[3], in1[3]);
    or(out[4], in0[4], in1[4]);
    or(out[5], in0[5], in1[5]);
    or(out[6], in0[6], in1[6]);
    or(out[7], in0[7], in1[7]);
    or(out[8], in0[8], in1[8]);
    or(out[9], in0[9], in1[9]);
    or(out[10], in0[10], in1[10]);
    or(out[11], in0[11], in1[11]);
    or(out[12], in0[12], in1[12]);
    or(out[13], in0[13], in1[13]);
    or(out[14], in0[14], in1[14]);
    or(out[15], in0[15], in1[15]);
    or(out[16], in0[16], in1[16]);
    or(out[17], in0[17], in1[17]);
    or(out[18], in0[18], in1[18]);
    or(out[19], in0[19], in1[19]);
    or(out[20], in0[20], in1[20]);
    or(out[21], in0[21], in1[21]);
    or(out[22], in0[22], in1[22]);
    or(out[23], in0[23], in1[23]);
    or(out[24], in0[24], in1[24]);
    or(out[25], in0[25], in1[25]);
    or(out[26], in0[26], in1[26]);
    or(out[27], in0[27], in1[27]);
    or(out[28], in0[28], in1[28]);
    or(out[29], in0[29], in1[29]);
    or(out[30], in0[30], in1[30]);
    or(out[31], in0[31], in1[31]);
endmodule