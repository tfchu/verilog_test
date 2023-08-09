/**
note
burst vs length, e.g. burst = 3 (4-bytes), length = 1 (2 transactions), i.e. two 4-byte bursts, total of 8 bytes
so addr + (burst+1) * (length+1) < end

start  addr                                  end
|      |  4-byte | 4-byte |                  |
----------------------------------------------

[0] addr = 0x384, data = 0xe91ad7b9, burst = 4 bytes per transfer, length = 2
[1] addr = 0x4d4, data = 0x61a0985b, burst = 1 bytes per transfer, length = 6
[2] addr = 0x578, data = 0x17ad833a, burst = 3 bytes per transfer, length = 6
[3] addr = 0x4f4, data = 0xe7b4dc07, burst = 1 bytes per transfer, length = 8
[4] addr = 0x49c, data = 0xb295cbe0, burst = 4 bytes per transfer, length = 5
[5] addr = 0x32c, data = 0x323699d3, burst = 2 bytes per transfer, length = 8
[6] addr = 0x670, data = 0x4a7cc82a, burst = 4 bytes per transfer, length = 1
[7] addr = 0x4ec, data = 0xcbfb2ff3, burst = 4 bytes per transfer, length = 3
[8] addr = 0x564, data = 0x4bfe95a0, burst = 1 bytes per transfer, length = 6
[9] addr = 0x2d0, data = 0x7b5367b9, burst = 3 bytes per transfer, length = 4
*/

class BusTransaction;
    rand int m_addr;
    rand bit [31:0] m_data;     // slave start address
    rand bit [1:0] m_burst;     // 0: 1 byte, 1: 2 bytes, 2: 3 bytes, 3: 4 bytes
    rand bit [2:0] m_length;    // transactions per burst, e.g. length 8 and burst 3 (4byte) is 8 4-byte transactions

    constraint c_addr {
        m_addr %4 == 0;         // 4-byte alignment
    }

    function void display(int idx);
        $display("[%0d] addr = 0x%0h, data = 0x%0h, burst = %0d bytes per transfer, length = %0d", idx, m_addr, m_data, m_burst + 1, m_length + 1);
    endfunction
endclass

module tb;
    int slave_start;
    int slave_end;
    BusTransaction bt;

    initial begin
        slave_start = 32'h200;
        slave_end = 32'h800;
        bt = new();

        for (int i = 0; i < 10; i++) begin
            bt.randomize() with {
                m_addr >= slave_start;      // m_addr within slave address range
                m_addr < slave_end;
                (m_burst + 1) * (m_length + 1) + m_addr < slave_end;    // data cannot exceed slave_end
            };

            bt.display(i);
        end
    end
endmodule