/**

use bit (1-bit)
queue = '{'h9, 'hc, 'h7, 'h3} 

*/

class Packet;
    rand bit [3:0] queue [$];   // $ for queue, and use push/pop to manipulate the queue

    constraint c_array {
        queue.size() == 4;
    }
endclass

module tb;
    Packet pkt;

    initial begin
        pkt = new();
        pkt.randomize();
        $display("queue = %p", pkt.queue);
    end
endmodule