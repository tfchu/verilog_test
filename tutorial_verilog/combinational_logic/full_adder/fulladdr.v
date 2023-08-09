/**
full adder
- 3 inputs, a and b to add, cin the the carry from a previous stage (if existed)
- 2 outputs, sum is the sum of a, b, cin, cout is the carry if existed

4   4   1      1     4
a + b + cin = {cout, sum}

output
# KERNEL: [0] a='b0000 b='b0000 cin='b0 cout='b0 sum='b0000
# KERNEL: [10] a='b0100 b='b0001 cin='b1 cout='b0 sum='b0110        // a + b + cin: 0100b + 0001b + 1b = 0_0110b (cout = 0b, sum = 0110b)
# KERNEL: [20] a='b0011 b='b1101 cin='b1 cout='b1 sum='b0001        // a + b + cin = 0011b + 1101b + 1b = 1_0001b (cout = 1b, sum = 0001b)
# KERNEL: [30] a='b0101 b='b0010 cin='b1 cout='b0 sum='b1000
# KERNEL: [40] a='b1101 b='b0110 cin='b1 cout='b1 sum='b0100
# KERNEL: [50] a='b1101 b='b1100 cin='b1 cout='b1 sum='b1010

**/

module fulladdr(a, b, cin, sum, cout);

    input [3:0] a;      // cannot be unpacked: input a [3:0]
    input [3:0] b;      // cannot be unpacked: input b [3:0]
    input cin;
    output [3:0] sum;
    output cout;

    //assign sum=(a^b^cin);
    //assign cout=((a&b)|(b&cin)|(a&cin));

    assign {cout, sum} = a + b + cin;

    // always @(a or b or cin) begin
    //     {cout, sum} = a + b + cin;
    // end

endmodule

module fulladdr_tb;
    reg [3:0] a;
    reg [3:0] b;
    reg cin, cout;
    wire [3:0] sum;
    integer i;

    fulladdr fa0 (.a (a), .b (b), .cin (cin), .cout (cout), .sum (sum));

    initial begin 
        a <= 0;
        b <= 0;
        cin <= 0;

      $monitor ("[%0t] a='b%4b b='b%4b cin='b%1b cout='b%1b sum='b%4b", $time, a, b, cin, cout, sum);

        for (i = 0; i < 5; i++) begin
            #10;
            a <= $random;
            b <= $random;
            cin <= $random;
        end
    end
endmodule