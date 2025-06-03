/*

32-bit XOR gate.

Inputs:
    - in0: 32-bit first input
    - in1: 32-bit second input
Outputs:
    - out: 32-bit result of XORing inputs

*/

module xor32(in0, in1, out);
    input logic [31:0] in0, in1;
    output logic [31:0] out;

    xor(out[0], in0[0], in1[0]);
    xor(out[1], in0[1], in1[1]);
    xor(out[2], in0[2], in1[2]);
    xor(out[3], in0[3], in1[3]);
    xor(out[4], in0[4], in1[4]);
    xor(out[5], in0[5], in1[5]);
    xor(out[6], in0[6], in1[6]);
    xor(out[7], in0[7], in1[7]);
    xor(out[8], in0[8], in1[8]);
    xor(out[9], in0[9], in1[9]);
    xor(out[10], in0[10], in1[10]);
    xor(out[11], in0[11], in1[11]);
    xor(out[12], in0[12], in1[12]);
    xor(out[13], in0[13], in1[13]);
    xor(out[14], in0[14], in1[14]);
    xor(out[15], in0[15], in1[15]);
    xor(out[16], in0[16], in1[16]);
    xor(out[17], in0[17], in1[17]);
    xor(out[18], in0[18], in1[18]);
    xor(out[19], in0[19], in1[19]);
    xor(out[20], in0[20], in1[20]);
    xor(out[21], in0[21], in1[21]);
    xor(out[22], in0[22], in1[22]);
    xor(out[23], in0[23], in1[23]);
    xor(out[24], in0[24], in1[24]);
    xor(out[25], in0[25], in1[25]);
    xor(out[26], in0[26], in1[26]);
    xor(out[27], in0[27], in1[27]);
    xor(out[28], in0[28], in1[28]);
    xor(out[29], in0[29], in1[29]);
    xor(out[30], in0[30], in1[30]);
    xor(out[31], in0[31], in1[31]);
endmodule