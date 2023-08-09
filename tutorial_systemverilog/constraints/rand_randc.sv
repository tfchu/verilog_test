/**
rand: random
[0] Packet data = 0x3 // -- cycle 0 start
[1] Packet data = 0x6
[2] Packet data = 0x1
[3] Packet data = 0x1 // not all values are picked in a cycle
[4] Packet data = 0x5
[5] Packet data = 0x7
[6] Packet data = 0x0
[7] Packet data = 0x2 // -- cycle 0 end
[8] Packet data = 0x5
[9] Packet data = 0x2

randc: random-cyclic
[0] Packet_c data = 0x0 // -- cycle 0 start
[1] Packet_c data = 0x6
[2] Packet_c data = 0x7
[3] Packet_c data = 0x2
[4] Packet_c data = 0x4 // all values (0 ~ 7) are picked once in a cycle
[5] Packet_c data = 0x3
[6] Packet_c data = 0x1
[7] Packet_c data = 0x5 // -- cycle 0 end
[8] Packet_c data = 0x3
[9] Packet_c data = 0x7
*/

class Packet;
    rand bit [2:0] data;        // random
endclass

class Packet_c;
    randc bit [2:0] data;       // random-cyclic
endclass

module tb;
    initial begin
        Packet pkt = new();
        for (int i = 0; i < 10; i++) begin
            pkt.randomize();
            $display("[%0d] Packet data = 0x%0h", i, pkt.data);
        end
    end

    initial begin
        Packet_c pkt = new();
        for (int i = 0; i < 10; i++) begin
            pkt.randomize();
            $display("[%0d] Packet_c data = 0x%0h", i, pkt.data);
        end
    end
endmodule