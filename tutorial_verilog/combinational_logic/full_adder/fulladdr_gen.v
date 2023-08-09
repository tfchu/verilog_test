/**
https://www.fpga4student.com/2017/07/n-bit-adder-design-in-verilog.html
n-bit adder with generate (half adder (bit0) - full adder (bit1) - full adder (bit2) - ...)

output
# KERNEL: [0] a='b0000 b='b0000 cout='b0 answer='b0000
# KERNEL: [10] a='b0100 b='b0001 cout='b0 answer='b0101
# KERNEL: [20] a='b1001 b='b0011 cout='b0 answer='b1100
# KERNEL: [30] a='b1101 b='b1101 cout='b1 answer='b1010
# KERNEL: [40] a='b0101 b='b0010 cout='b0 answer='b0111
# KERNEL: [50] a='b0001 b='b1101 cout='b0 answer='b1110
**/
module n_bit_adder #(parameter N = 32)
(
    input1, input2, answer, carry_out
);
    input [N-1:0] input1, input2;
    output [N-1:0] answer;
    output carry_out;      // wire carry_output if carry_out is not in port list
    wire [N-1:0] carry;

    // 1 module per bit, starting with half adder
    genvar i;
    generate 
        for(i=0;i<N;i=i+1) begin: generate_N_bit_Adder
        if(i==0) 
            half_adder f(input1[0],input2[0],answer[0],carry[0]);               // gene[0]
        else
            // carry out bit of previous module is connected to carry in bit of current module
            full_adder f(input1[i],input2[i],carry[i-1],answer[i],carry[i]);    // gene[1], gene[2], ... gene[N]
        end
        assign carry_out = carry[N-1];
    endgenerate
endmodule 

module half_adder(x,y,s,c);
    input x,y;
    output s,c;
    assign s=x^y;
    assign c=x&y;
endmodule // half adder

module full_adder(x,y,c_in,s,c_out);
    input x,y,c_in;
    output s,c_out;
    assign s = (x^y) ^ c_in;
    assign c_out = (y&c_in)| (x&y) | (x&c_in);
endmodule // full_adder

module n_bit_adder_tb;
    localparam int n = 4;       // cannot be const int n = 4
                                // https://stackoverflow.com/questions/61341531/systemverilog-not-recognizing-constant-error-range-must-be-bounded-by-constant

    reg [n-1:0] a;
    reg [n-1:0] b;
    reg cout;
    wire [n-1:0] sum;           // reg also ok
    integer i;

    n_bit_adder #(.N(n)) nba0 (.input1 (a), .input2 (b), .answer (sum), .carry_out(cout));

    initial begin 
        a <= 0;
        b <= 0;

        $monitor ("[%0t] a='b%4b b='b%4b cout='b%1b answer='b%4b", $time, a, b, cout, sum);

        for (i = 0; i < 5; i++) begin
            #10;
            a <= $random;
            b <= $random;
        end
    end
endmodule