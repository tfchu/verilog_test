/**

use bit (1-bit)
queue = '{'h1, 'h0, 'h1, 'h1, 'h0, 'h0, 'h1} 

use bit [3:0]
queue = '{'h9, 'hc, 'h7, 'h3, 'hc, 'h4, 'h9} 

*/

class Packet;
    rand bit [3:0] s_array [7];
endclass

module tb;
    Packet pkt;

    initial begin
        pkt = new();
        pkt.randomize();
        $display("queue = %p", pkt.s_array);
    end
endmodule