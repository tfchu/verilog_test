/**
signed int (default)
size of a = 16, of b = 32, of c = 64            // get size, this may print before or next print?
time = 0, a = 0, b = 0, c = 0                   // defaults, this prints even without first initial block
time = 1, a = 32767, b = 2147483647, c = 9223372036854775807    // set value
time = 2, a = -32768, b = -2147483648, c = -9223372036854775808 // goes to negative

if using unsigned int: 
shortint unsigned a;    // max 'hFFFF (65535)
int unsigned b;         // max 'hFFFF_FFFF 
longint unsigned c;     // max 'hFFFF_FFFF_FFFF_FFFF

+= 1 makes all to round back to 0

*/

module tb;

    shortint a;
    int b;
    longint c;

    initial begin
        $display("size of a = %0d, of b = %0d, of c = %0d", $bits(a), $bits(b), $bits(c));  // get size
        #1 a = 'h7FFF;
        b = 'h7FFF_FFFF;
        c = 'h7FFF_FFFF_FFFF_FFFF;

        #1 a += 1;
        b += 1;
        c += 1;
    end  

    initial
    $monitor("time = %g, a = %0d, b = %0d, c = %0d", $time, a, b, c); // triggered whenever any value changes

endmodule