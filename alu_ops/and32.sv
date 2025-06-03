/*

32-bit AND gate.

Inputs:
    - in0: 32-bit first input
    - in1: 32-bit second input
Outputs:
    - out: 32-bit result of ANDing inputs

*/

module and32(in0, in1, out);
    input logic [31:0] in0, in1;
    output logic [31:0] out;

    and(out[0], in0[0], in1[0]);
    and(out[1], in0[1], in1[1]);
    and(out[2], in0[2], in1[2]);
    and(out[3], in0[3], in1[3]);
    and(out[4], in0[4], in1[4]);
    and(out[5], in0[5], in1[5]);
    and(out[6], in0[6], in1[6]);
    and(out[7], in0[7], in1[7]);
    and(out[8], in0[8], in1[8]);
    and(out[9], in0[9], in1[9]);
    and(out[10], in0[10], in1[10]);
    and(out[11], in0[11], in1[11]);
    and(out[12], in0[12], in1[12]);
    and(out[13], in0[13], in1[13]);
    and(out[14], in0[14], in1[14]);
    and(out[15], in0[15], in1[15]);
    and(out[16], in0[16], in1[16]);
    and(out[17], in0[17], in1[17]);
    and(out[18], in0[18], in1[18]);
    and(out[19], in0[19], in1[19]);
    and(out[20], in0[20], in1[20]);
    and(out[21], in0[21], in1[21]);
    and(out[22], in0[22], in1[22]);
    and(out[23], in0[23], in1[23]);
    and(out[24], in0[24], in1[24]);
    and(out[25], in0[25], in1[25]);
    and(out[26], in0[26], in1[26]);
    and(out[27], in0[27], in1[27]);
    and(out[28], in0[28], in1[28]);
    and(out[29], in0[29], in1[29]);
    and(out[30], in0[30], in1[30]);
    and(out[31], in0[31], in1[31]);
endmodule