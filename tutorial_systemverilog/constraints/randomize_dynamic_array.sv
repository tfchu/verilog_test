/**
// randomized to 6-element array
d_array[0] = 0x0
d_array[1] = 0x1
d_array[2] = 0x2
d_array[3] = 0x3
d_array[4] = 0x4
d_array[5] = 0x5

*/

class Packet;
    rand bit [3:0] d_array[];

    constraint c_array {        
        d_array.size() > 5;     // dynamic array size is 6, 7, 8, or 9
        d_array.size() < 10;
    }

    constraint c_val {
        foreach (d_array[i])
            d_array[i] == i;    // value must equal to the index
    }

    function void display();
        foreach (d_array[i])
            $display("d_array[%0d] = 0x%0h", i, d_array[i]);
    endfunction
endclass

module tb_d_array;
    Packet pkt;

    initial begin
        pkt = new();
        pkt.randomize();
        pkt.display();
    end
endmodule