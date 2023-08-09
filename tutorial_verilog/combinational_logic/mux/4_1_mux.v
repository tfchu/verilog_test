/**
       _____
a --- |     |
b --- |     |--- out
c --- |     |
d --- |_____|
sel ----|

output for both modules
# KERNEL: [0] a=0x4 b=0x1 c=0x9 d=0x3 sel=0x0 out=0x4
# KERNEL: [5] a=0x4 b=0x1 c=0x9 d=0x3 sel=0x1 out=0x1
# KERNEL: [10] a=0x4 b=0x1 c=0x9 d=0x3 sel=0x2 out=0x9
# KERNEL: [15] a=0x4 b=0x1 c=0x9 d=0x3 sel=0x3 out=0x3

**/

// use assign
module  mux_4_1_assign(
    input [3:0] a, b, c, d, 
    input [1:0] sel, 
    output [3:0] out
);
    // sel
    // 0x: a or b, x = 0 (a), 1 (b)
    // 1x: c or d, x = 0 (c), 1 (d)
    assign out = sel[1] ? (sel[0] ? d : c) : (sel[0] ? b : a);
endmodule

// use case
module  mux_4_1_case(
    input [3:0] a, b, c, d, 
    input [1:0] sel, 
    output reg [3:0] out            // must use "reg", otherwise error is thrown
);
    always @ (a or b or c or d or sel) begin
        case (sel)
            2'b00: out <= a;
            2'b01: out <= b;
            2'b10: out <= c;
            2'b11: out <= d;
        endcase
    end
endmodule

module tb_mux_4_1;

    // reg to drive input
    // wire to collect output
    reg [3:0] a, b, c, d;
    wire [3:0] out;
    reg [1:0] sel;
    integer i;

    // module instantiation
    mux_4_1_assign mux0 (.a (a), .b (b), .c (c), .d (d), .sel (sel), .out (out));       // simply replace with mux_4_1_case to test case module
                                                                                        // why is connecting wire out to reg out in case module ok? 
    initial begin
        $monitor ("[%0t] a=0x%0h b=0x%0h c=0x%0h d=0x%0h sel=0x%0h out=0x%0h", $time, a, b, c, d, sel, out);

        sel <= 0;
        a <= $random;
        b <= $random;
        c <= $random;
        d <= $random;

        for (i = 1; i < 4; i = i + 1) begin
            #5 sel <= i;
        end

        #5 $finish;
    end

endmodule