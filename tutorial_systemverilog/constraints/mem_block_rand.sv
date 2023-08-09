/**
randomly select a memory block with constraints
start                          end
|          |  block    |       |
--------------------------------

RAM start = 0x0         // RAM start
RAM end = 0x7ff         // RAM end, 0x7ff - 0 + 1 = 2048 = 2KiB
Block start = 0x15c     // 4-byte align
Block end = 0x35b       // 0x35b - 0x15c + 1 = 512 bytes
Block size = 0x200      // 512 bytes

*/

class MemoryBlock;

    bit [31:0] m_ram_start;          // RAM start address
    bit [31:0] m_ram_end;            // RAM end address

    rand bit [31:0] m_start_addr;   // block start address (pointer to)
    rand bit [31:0] m_end_addr;     // block end address
    rand int m_block_size;          // block size

    constraint c_addr {
        m_start_addr >= m_ram_start;    // block start after RAM start
        m_start_addr < m_ram_end;       // block start before RAM end
        m_start_addr %4 == 0;           // 4-byte align
        m_end_addr == m_start_addr + m_block_size - 1;  // block end
    }

    constraint c_clk_size {
        m_block_size inside {64, 128, 512}; // block size either 64B, 128B, 512B
    }

    function void display();
        $display("RAM start = 0x%0h", m_ram_start);
        $display("RAM end = 0x%0h", m_ram_end);
        $display("Block start = 0x%0h", m_start_addr);
        $display("Block end = 0x%0h", m_end_addr);
        $display("Block size = 0x%0h", m_block_size);
    endfunction
endclass

module tb;
    initial begin
        MemoryBlock mb = new;
        mb.m_ram_start = 32'h0;
        mb.m_ram_end = 32'h7FF;     // 2K
        mb.randomize();
        mb.display();
    end
endmodule
