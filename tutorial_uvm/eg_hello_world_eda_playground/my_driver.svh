/**

adding the `uvm_info, print as follows. note Hello World! is after 1st drive

# KERNEL: UVM_INFO /home/runner/my_driver.svh(33) @ 6: uvm_test_top.env.agent.driver [DRIVER] starting driving req cmd=1, addr=0xbc data=0x43
# KERNEL: UVM_WARNING /home/runner/my_testbench_pkg.svh(76) @ 10: uvm_test_top [] Hello World!
# KERNEL: UVM_INFO /home/runner/design.sv(22) @ 15: reporter [DUT] Received cmd=1, addr=0xbc, data=0x43
# KERNEL: UVM_INFO /home/runner/my_driver.svh(33) @ 15: uvm_test_top.env.agent.driver [DRIVER] starting driving req cmd=0, addr=0xf3 data=0x78
# KERNEL: UVM_INFO /home/runner/design.sv(22) @ 25: reporter [DUT] Received cmd=0, addr=0xf3, data=0x78
# KERNEL: UVM_INFO /home/runner/my_driver.svh(33) @ 25: uvm_test_top.env.agent.driver [DRIVER] starting driving req cmd=0, addr=0x60 data=0xe1
# KERNEL: UVM_INFO /home/runner/design.sv(22) @ 35: reporter [DUT] Received cmd=0, addr=0x60, data=0xe1

*/

// driver does the actual wiggle the I/F pins to drive the DUT
class my_driver extends uvm_driver #(my_transaction);

  `uvm_component_utils(my_driver)

  virtual dut_if dut_vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // we need to get the virtual I/F which is set in the tb
  // so we can use it in run_phase
  function void build_phase(uvm_phase phase);
    // Get interface reference from config database
    if(!uvm_config_db#(virtual dut_if)::get(this, "", "dut_vif", dut_vif)) begin
      `uvm_error("", "uvm_config_db::get failed")
    end
  endfunction 

  // toggle reset, then 
  task run_phase(uvm_phase phase);
    // First toggle reset
    dut_vif.reset = 1;          // set high
    @(posedge dut_vif.clock);   // after clk posedge
    #1;                         // wait 1 tu
    dut_vif.reset = 0;          // set low
    
    // Now drive normal traffic
    forever begin                       // the whole begin end happens 8 times as we say repeat(8) in my_sequence
      seq_item_port.get_next_item(req); // look for the next request from the sequencer

      // Wiggle pins of DUT
      dut_vif.cmd  = req.cmd;           // put the request on the virtual I/F (bus)
      dut_vif.addr = req.addr;
      dut_vif.data = req.data;
      // `uvm_info("DRIVER", $sformatf("starting driving req cmd=%0b, addr=0x%2h data=0x%2h", req.cmd, req.addr, req.data), UVM_MEDIUM)
      @(posedge dut_vif.clock);         // wait for clk posedge

      seq_item_port.item_done();        // then we say this request is done
    end
  endtask

endclass: my_driver
