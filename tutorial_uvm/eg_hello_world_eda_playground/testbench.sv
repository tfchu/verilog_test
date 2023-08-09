/**

# KERNEL: UVM_INFO @ 0: reporter [RNTST] Running test my_test...
# KERNEL: UVM_WARNING /home/runner/my_testbench_pkg.svh(76) @ 10: uvm_test_top [] Hello World!
# KERNEL: UVM_INFO /home/runner/design.sv(22) @ 15: reporter [DUT] Received cmd=1, addr=0xbc, data=0x43
# KERNEL: UVM_INFO /home/runner/design.sv(22) @ 25: reporter [DUT] Received cmd=0, addr=0xf3, data=0x78
# KERNEL: UVM_INFO /home/runner/design.sv(22) @ 35: reporter [DUT] Received cmd=0, addr=0x60, data=0xe1
# KERNEL: UVM_INFO /home/runner/design.sv(22) @ 45: reporter [DUT] Received cmd=1, addr=0x03, data=0x7e
# KERNEL: UVM_INFO /home/runner/design.sv(22) @ 55: reporter [DUT] Received cmd=1, addr=0xdd, data=0x50
# KERNEL: UVM_INFO /home/runner/design.sv(22) @ 65: reporter [DUT] Received cmd=0, addr=0xee, data=0x57
# KERNEL: UVM_INFO /home/runner/design.sv(22) @ 75: reporter [DUT] Received cmd=0, addr=0x35, data=0x92
# KERNEL: UVM_INFO /home/runner/design.sv(22) @ 85: reporter [DUT] Received cmd=1, addr=0xb2, data=0x01
# KERNEL: UVM_INFO /home/build/vlib1/vlib/uvm-1.2/src/base/uvm_objection.svh(1271) @ 85: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
# KERNEL: UVM_INFO /home/build/vlib1/vlib/uvm-1.2/src/base/uvm_report_server.svh(869) @ 85: reporter [UVM/REPORT/SERVER] 

*/
/*******************************************
This is a basic UVM "Hello World" testbench.

Explanation of this testbench on YouTube:
https://www.youtube.com/watch?v=Qn6SvG-Kya0
*******************************************/

`include "uvm_macros.svh"
`include "my_testbench_pkg.svh"

// The top module that contains the DUT and interface.
// This module starts the test.
module top;
  import uvm_pkg::*;
  import my_testbench_pkg::*;
  
  // Instantiate the interface
  dut_if dut_if1();
  
  // Instantiate the DUT and connect it to the interface
  dut dut1(.dif(dut_if1));
  
  // Clock generator
  initial begin
    dut_if1.clock = 0;
    forever #5 dut_if1.clock = ~dut_if1.clock;
  end
  
  initial begin
    // Place the interface into the UVM configuration database
    // tchu: put virtual I/F in UVM config DB so it can be later retrieved by another UVM class
    uvm_config_db#(virtual dut_if)::set(null, "*", "dut_vif", dut_if1);
    // Start the test
    run_test("my_test");
  end
  
  // Dump waves
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, top);
  end
  
endmodule
