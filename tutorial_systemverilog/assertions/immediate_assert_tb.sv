/**

use immediate assertion to capture an error

VCS does not seem to support it. result is the same with or without assert()
=======================================================
Solver failed when solving following set of constraints 

rand bit[7:0] addr; // rand_mode = ON 

constraint c_addr    // (from this) (constraint_mode = ON) (testbench.sv:6)
{
   (addr > 8'h5);
   (addr < 8'h3);
}
=======================================================


*/

class Packet;
    rand bit [7:0] addr;

    constraint c_addr {
        addr > 5;       // intentional mistake
        addr < 3;
    }
endclass

module tb;
    initial begin
        Packet pkt = new();

        assert(pkt.randomize());    // w/o assert, compile will fail due to conflict in constraint
                                    // with assert, if randomize() fails (return false), an assertion happens
    end

endmodule