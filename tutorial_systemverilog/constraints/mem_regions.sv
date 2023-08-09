/**
https://www.chipverify.com/systemverilog/systemverilog-memory-partition-constraint-example
partition for programs and data

ram start_addr=0, end_addr=6143, size=6144 bytes                
# pgms=19, # data=25, # space=28                                
# pgms size=4768, # data size=1322754220, # space size=2073584085   
pgm #0 size=128 bytes                                           

ram start_addr=0, end_addr=6143, size=6144 bytes            // total ram info 
# pgms=19, # data=25, # space=28                            // nr of regions for each purpose
# pgms size=2436, # data size=2688, # space size=1020       // total size for each purpose, 2436 + 2688 + 1020 = 6144 bytes
pgm #0 size=4 bytes                                         // list of all program regions
pgm #1 size=128 bytes
pgm #2 size=128 bytes
pgm #3 size=128 bytes
pgm #4 size=64 bytes
pgm #5 size=32 bytes
pgm #6 size=128 bytes
pgm #7 size=128 bytes
pgm #8 size=128 bytes
pgm #9 size=128 bytes
pgm #10 size=512 bytes
pgm #11 size=128 bytes
pgm #12 size=128 bytes
pgm #13 size=128 bytes
pgm #14 size=128 bytes
pgm #15 size=32 bytes
pgm #16 size=128 bytes
pgm #17 size=128 bytes
pgm #18 size=128 bytes
data #0 size=64 bytes                                       // list of all data regions
data #1 size=1024 bytes
data #2 size=64 bytes
data #3 size=128 bytes
data #4 size=64 bytes
data #5 size=64 bytes
data #6 size=64 bytes
data #7 size=64 bytes
data #8 size=64 bytes
data #9 size=64 bytes
data #10 size=64 bytes
data #11 size=64 bytes
data #12 size=64 bytes
data #13 size=64 bytes
data #14 size=64 bytes
data #15 size=64 bytes
data #16 size=64 bytes
data #17 size=128 bytes
data #18 size=64 bytes
data #19 size=64 bytes
data #20 size=64 bytes
data #21 size=64 bytes
data #22 size=64 bytes
data #23 size=64 bytes
data #24 size=64 bytes
space #0 size=4 bytes                                       // list of all empty space regions
space #1 size=32 bytes
space #2 size=4 bytes
space #3 size=4 bytes
space #4 size=512 bytes
space #5 size=4 bytes
space #6 size=64 bytes
space #7 size=4 bytes
space #8 size=4 bytes
space #9 size=4 bytes
space #10 size=4 bytes
space #11 size=4 bytes
space #12 size=32 bytes
space #13 size=4 bytes
space #14 size=4 bytes
space #15 size=128 bytes
space #16 size=8 bytes
space #17 size=4 bytes
space #18 size=4 bytes
space #19 size=128 bytes
space #20 size=4 bytes
space #21 size=32 bytes
space #22 size=8 bytes
space #23 size=4 bytes
space #24 size=4 bytes
space #25 size=4 bytes
space #26 size=4 bytes
space #27 size=4 bytes

*/

typedef struct {
    int start_addr;
    int end_addr;
    int size;
} range_t;

class Space;
    rand int num_pgm;       // total program size in bytes
    rand int num_data;      // total data size in bytes
    rand int num_space;     // total empty space size in bytes

    rand int max_pgm_size;  // max total program size 
    rand int max_data_size; // max total data size 

    rand int num_max_pgm;   // max number of program regions

    rand int pgm_size[];    // size of each program region in bytes
    rand int data_size[];   // size of each data region in bytes
    rand int space_size[];  // size of each empty space region in bytes

    range_t ram;            // total RAM structure

    constraint c_num_size {
        max_pgm_size == 512;                // 512 bytes
        max_data_size == 128;               // 128 bytes
        num_max_pgm == 100;                 // up to 100 regions for program
    }

    // number of regions for each purpose
    constraint c_num {
        num_pgm inside {[1:num_max_pgm]};   // 1 ~ 100
        num_data inside {[1:50]};           // 1 ~ 50
        num_space inside {[1:50]};          // 1 ~ 50
    }

    constraint c_size {
        pgm_size.size() == num_pgm;
        data_size.size() == num_data;
        space_size.size() == num_space;
    }

    constraint c_ram {
        foreach (pgm_size[i]) {
            pgm_size[i] inside {4, 8, 32, 64, 128, 512};                // allowed program region size
            pgm_size[i] dist {[128:512]:/75, [32:64]:/20, [4:8]:/10};   // change possibility of each size
            pgm_size[i] %4 == 0;            // 4-byte align
        }
        foreach (data_size[i]) {
            data_size[i] inside {64, 128, 512, 1024};         // allowed data region size
        }
        foreach (space_size[i]) {
            space_size[i] inside {4, 8, 32, 64, 128, 512, 1024};         // allowed data region size
        }
        ram.size == pgm_size.sum() + data_size.sum() + space_size.sum();
    }

    function void display();
        $display("ram start_addr=%0d, end_addr=%0d, size=%0d bytes", ram.start_addr, ram.end_addr, ram.size);
        $display("# pgms=%0d, # data=%0d, # space=%0d", num_pgm, num_data, num_space);
        $display("# pgms size=%0d, # data size=%0d, # space size=%0d", pgm_size.sum(), data_size.sum(), space_size.sum());
        foreach (pgm_size[i])
            $display("pgm #%0d size=%0d bytes",i, pgm_size[i]);
        foreach (data_size[i])
            $display("data #%0d size=%0d bytes",i, data_size[i]);
        foreach (space_size[i])
            $display("space #%0d size=%0d bytes",i, space_size[i]);
    endfunction

endclass

module tb;
    initial begin
        Space sp = new();
        sp.ram.start_addr = 'h0;
        sp.ram.size = 6 * 1024;    // 6KB
        sp.ram.end_addr = sp.ram.start_addr + sp.ram.size - 1;
        assert(sp.randomize());     // randomize() should return true
        sp.display();
    end
endmodule