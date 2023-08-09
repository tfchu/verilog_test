/**
we have memory located between 0x4000 ~ 0x5FFF. 
- lower partition (0x4000 ~ 0x4FFF) to store data
- upper partition (0x5000 ~ 0x5FFF) to store instructions

we want to randomly get a address for data

addr = 0x406e
addr = 0x42b6
addr = 0x4254
addr = 0x4bbe
addr = 0x480b

*/

class Data;
    rand bit [15:0] m_addr; // memory address
    constraint c_addr {
        m_addr inside {[16'h4000:16'h4fff]};
    }
endclass

module tb_inside;
    initial begin
        Data data = new();
        repeat (5) begin
            data.randomize();
            $display("addr = 0x%0h", data.m_addr);  // no "this"? 
        end
    end
endmodule