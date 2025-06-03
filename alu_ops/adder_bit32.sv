/*

32-bit adder/subtractor implementation, assuming the inputs are Two's Complement numbers.

Inputs:
    - in0: 32-bit Two's Complement input for the first number
    - in1: 32-bit Two's Complement input for the second number
    - sub: 1-bit indicator of whether the operation is addition or subtraction
        - 0 if addition, 1 if subtraction
Outputs:
    - out: 32-bit Two's Complement output of the result
    - cout: 1-bit output of the carry out

*/

module adder_bit32(in0, in1, sub, out, cout);
    input logic [31:0] in0, in1;
    input logic sub;
    output logic [31:0] out;
    output logic cout;

    logic cin0, cin1, cin2, cin3, cin4, cin5, cin6, cin7, cin8, cin9, cin10, cin11, cin12, cin13, cin14, cin15, cin16,
          cin17, cin18, cin19, cin20, cin21, cin22, cin23, cin24, cin25, cin26, cin27, cin28, cin29, cin30, cin31;

    logic xor0, xor1, xor2, xor3, xor4, xor5, xor6, xor7, xor8, xor9, xor10, xor11, xor12, xor13, xor14, xor15, xor16,
          xor17, xor18, xor19, xor20, xor21, xor22, xor23, xor24, xor25, xor26, xor27, xor228, xor29, xor30, xor31;

    logic xorsub0;

    xor(xor0, in1[0], sub);
    xor(xor1, in1[1], sub);
    xor(xor2, in1[2], sub);
    xor(xor3, in1[3], sub);
    xor(xor4, in1[4], sub);
    xor(xor5, in1[5], sub);
    xor(xor6, in1[6], sub);
    xor(xor7, in1[7], sub);
    xor(xor8, in1[8], sub);
    xor(xor9, in1[9], sub);
    xor(xor10, in1[10], sub);
    xor(xor11, in1[11], sub);
    xor(xor12, in1[12], sub);
    xor(xor13, in1[13], sub);
    xor(xor14, in1[14], sub);
    xor(xor15, in1[15], sub);
    xor(xor16, in1[16], sub);
    xor(xor17, in1[17], sub);
    xor(xor18, in1[18], sub);
    xor(xor19, in1[19], sub);
    xor(xor20, in1[20], sub);
    xor(xor21, in1[21], sub);
    xor(xor22, in1[22], sub);
    xor(xor23, in1[23], sub);
    xor(xor24, in1[24], sub);
    xor(xor25, in1[25], sub);
    xor(xor26, in1[26], sub);
    xor(xor27, in1[27], sub);
    xor(xor28, in1[28], sub);
    xor(xor29, in1[29], sub);
    xor(xor30, in1[30], sub);
    xor(xor31, in1[31], sub);
    xor(xorsub0, 1'b0, sub);

    adder add0(.a(in0[0]), .b(xor0), .cin(xorsub0), .s(out[0]), .cout(cin0));
    adder add1(.a(in0[1]), .b(xor1), .cin(cin0), .s(out[1]), .cout(cin1));
    adder add2(.a(in0[2]), .b(xor2), .cin(cin1), .s(out[2]), .cout(cin2));
    adder add3(.a(in0[3]), .b(xor3), .cin(cin2), .s(out[3]), .cout(cin3));
    adder add4(.a(in0[4]), .b(xor4), .cin(cin3), .s(out[4]), .cout(cin4));
    adder add5(.a(in0[5]), .b(xor5), .cin(cin4), .s(out[5]), .cout(cin5));
    adder add6(.a(in0[6]), .b(xor6), .cin(cin5), .s(out[6]), .cout(cin6));
    adder add7(.a(in0[7]), .b(xor7), .cin(cin6), .s(out[7]), .cout(cin7));
    adder add8(.a(in0[8]), .b(xor8), .cin(cin7), .s(out[8]), .cout(cin8));
    adder add9(.a(in0[9]), .b(xor9), .cin(cin8), .s(out[9]), .cout(cin9));
    adder add10(.a(in0[10]), .b(xor10), .cin(cin9), .s(out[10]), .cout(cin10));
    adder add11(.a(in0[11]), .b(xor11), .cin(cin10), .s(out[11]), .cout(cin11));
    adder add12(.a(in0[12]), .b(xor12), .cin(cin11), .s(out[12]), .cout(cin12));
    adder add13(.a(in0[13]), .b(xor13), .cin(cin12), .s(out[13]), .cout(cin13));
    adder add14(.a(in0[14]), .b(xor14), .cin(cin13), .s(out[14]), .cout(cin14));
    adder add15(.a(in0[15]), .b(xor15), .cin(cin14), .s(out[15]), .cout(cin15));
    adder add16(.a(in0[16]), .b(xor16), .cin(cin15), .s(out[16]), .cout(cin16));
    adder add17(.a(in0[17]), .b(xor17), .cin(cin16), .s(out[17]), .cout(cin17));
    adder add18(.a(in0[18]), .b(xor18), .cin(cin17), .s(out[18]), .cout(cin18));
    adder add19(.a(in0[19]), .b(xor19), .cin(cin18), .s(out[19]), .cout(cin19));
    adder add20(.a(in0[20]), .b(xor20), .cin(cin19), .s(out[20]), .cout(cin20));
    adder add21(.a(in0[21]), .b(xor21), .cin(cin20), .s(out[21]), .cout(cin21));
    adder add22(.a(in0[22]), .b(xor22), .cin(cin21), .s(out[22]), .cout(cin22));
    adder add23(.a(in0[23]), .b(xor23), .cin(cin22), .s(out[23]), .cout(cin23));
    adder add24(.a(in0[24]), .b(xor24), .cin(cin23), .s(out[24]), .cout(cin24));
    adder add25(.a(in0[25]), .b(xor25), .cin(cin24), .s(out[25]), .cout(cin25));
    adder add26(.a(in0[26]), .b(xor26), .cin(cin25), .s(out[26]), .cout(cin26));
    adder add27(.a(in0[27]), .b(xor27), .cin(cin26), .s(out[27]), .cout(cin27));
    adder add28(.a(in0[28]), .b(xor28), .cin(cin27), .s(out[28]), .cout(cin28));
    adder add29(.a(in0[29]), .b(xor29), .cin(cin28), .s(out[29]), .cout(cin29));
    adder add30(.a(in0[30]), .b(xor30), .cin(cin29), .s(out[30]), .cout(cin30));
    adder add31(.a(in0[31]), .b(xor31), .cin(cin30), .s(out[31]), .cout(cin31));

    xor(cout, cin31, cin30);

endmodule