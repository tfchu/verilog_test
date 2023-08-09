/**
0, a=0, b=0x0
0, a=1, b=0xf
0, a=1, b=0xa
0, a=1, b=0x4
*/

module tb;
    bit a;          // 1-bit
    bit[3:0] b;     // 4-bit
    logic[3:0] x;   // 4-bit

    initial begin
        // initial values are 0
        $display("%g, a=%0b, b=0x%0h", $time, a, b);

        // new values
        a = 1;
        b = 4'hF;
        $display("%g, a=%0b, b=0x%0h", $time, a, b);

        // truncated
        b = 16'h481a;   // only 1st 4 bits are stored
        $display("%g, a=%0b, b=0x%0h", $time, a, b);

        // x and z
        b = 4'b01zx;    // x, z to 0
        $display("%g, a=%0b, b=0x%0h", $time, a, b);
    end

endmodule
