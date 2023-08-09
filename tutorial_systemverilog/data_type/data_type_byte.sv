/**
size of s_b = 8, of u_b = 8     // get size, same
[0 ns], s_b = 0, u_b = 0        // initial default (always print)
[1 ns], s_b = 127, u_b = 127    // set to 'h7F
[2 ns], s_b = -128, u_b = 128   // both += 1. signed become negative, unsigned +1
[3 ns], s_b = -128, u_b = 255   // u_b = 'hFF
[4 ns], s_b = -128, u_b = 0     // u_b += 1;
*/

module tb;

    byte s_b;
    byte unsigned u_b;

    initial begin
        $display("size of s_b = %0d, of u_b = %0d", $bits(s_b), $bits(u_b));  // get size

        #1 s_b = 'h7F;
        u_b = 'h7F;

        #1 s_b += 1;
        u_b += 1;

        #1 u_b = 'hFF;

        #1 u_b += 1;
    end  

    initial
    $monitor("[%0t ns], s_b = %0d, u_b = %0d", $time, s_b, u_b); // triggered whenever any value changes

endmodule