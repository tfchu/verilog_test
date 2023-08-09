`include "test.sv"

module test_top;
    import uvm_pkg::*;


    bus_if traffic();
    
    // Instantiate the DUT and connect it to the interface
    dut dut1(.dif(dut_if1));
    
    // Clock generator
    initial begin
        dut_if1.clock = 0;
        forever #5 dut_if1.clock = ~dut_if1.clock;
    end

    initial begin
        run_test(reg_rw_test);
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, top);
    end
endmodule