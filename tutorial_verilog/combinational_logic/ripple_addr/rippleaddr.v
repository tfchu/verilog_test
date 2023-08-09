module fulladdr(a, b, cin, sum, cout);

    input a;
    input b;
    input cin;
    output sum;
    output cout;

    assign sum=(a^b^cin);
    assign cout=((a&b)|(b&cin)|(a&cin));

    //assign {cout, sum} = a + b + cin;

endmodule

module ripplemod(a, b, cin, sum, cout);
    input [07:0] a;
    input [07:0] b;
    input cin;
    output [7:0]sum;
    output cout;
    wire[6:0] c;

    fulladdr a1(
        a[0],
        b[0],
        cin,
        sum[0],
        c[0]
    );
    fulladdr a2(a[1],b[1],c[0],sum[1],c[1]);
    fulladdr a3(a[2],b[2],c[1],sum[2],c[2]);
    fulladdr a4(a[3],b[3],c[2],sum[3],c[3]);
    fulladdr a5(a[4],b[4],c[3],sum[4],c[4]);
    fulladdr a6(a[5],b[5],c[4],sum[5],c[5]);
    fulladdr a7(a[6],b[6],c[5],sum[6],c[6]);
    fulladdr a8(a[7],b[7],c[6],sum[7],cout);
endmodule