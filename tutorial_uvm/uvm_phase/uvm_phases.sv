/**
[Udemy Writing UVM testbenches for Newbie] 

summary
- demo uvm phases in uvm_component

note
- build phase: top-down
- connect phase: bottom-up
- run phase: bottom-up (VCS), top-down (Aldec)
- report phase: bottom-up

output (VCS)
UVM_INFO @ 0: reporter [RNTST] Running test ...
UVM_INFO testbench.sv(135) @ 0: TEST [TEST] Build Phase
UVM_INFO testbench.sv(104) @ 0: TEST.ENV [ENV] Build Phase
UVM_INFO testbench.sv(73) @ 0: TEST.ENV.AGENT [AGENT] Build Phase
UVM_INFO testbench.sv(16) @ 0: TEST.ENV.AGENT.DRV [DRV] Build Phase
UVM_INFO testbench.sv(43) @ 0: TEST.ENV.AGENT.MON [MON] Build Phase
UVM_INFO testbench.sv(21) @ 0: TEST.ENV.AGENT.DRV [DRV] Connect Phase
UVM_INFO testbench.sv(48) @ 0: TEST.ENV.AGENT.MON [MON] Connect Phase
UVM_INFO testbench.sv(80) @ 0: TEST.ENV.AGENT [AGENT] Connect Phase
UVM_INFO testbench.sv(110) @ 0: TEST.ENV [ENV] Connect Phase
UVM_INFO testbench.sv(141) @ 0: TEST [TEST] End of Elaboration Phase
----------------------------------------------------------
Name                   Type                    Size  Value
----------------------------------------------------------
TEST                   test                    -     @336 
  ENV                  env                     -     @351 
    AGENT              agent                   -     @362 
      DRV              driver                  -     @383 
        rsp_port       uvm_analysis_port       -     @402 
        seq_item_port  uvm_seq_item_pull_port  -     @392 
      MON              monitor                 -     @374 
----------------------------------------------------------
UVM_INFO testbench.sv(25) @ 0: TEST.ENV.AGENT.DRV [DRV] Run Phase
UVM_INFO testbench.sv(52) @ 0: TEST.ENV.AGENT.MON [MON] Run Phase
UVM_INFO testbench.sv(84) @ 0: TEST.ENV.AGENT [AGENT] Run Phase
UVM_INFO testbench.sv(114) @ 0: TEST.ENV [ENV] Run Phase
UVM_INFO testbench.sv(146) @ 0: TEST [TEST] Run Phase
UVM_INFO testbench.sv(30) @ 0: TEST.ENV.AGENT.DRV [DRV] Report Phase
UVM_INFO testbench.sv(57) @ 0: TEST.ENV.AGENT.MON [MON] Report Phase
UVM_INFO testbench.sv(89) @ 0: TEST.ENV.AGENT [AGENT] Report Phase
UVM_INFO testbench.sv(119) @ 0: TEST.ENV [ENV] Report Phase
UVM_INFO testbench.sv(153) @ 0: TEST [TEST] Report Phase


output (Aldec)
# KERNEL: UVM_INFO @ 0: reporter [RNTST] Running test ...
# KERNEL: UVM_INFO /home/runner/testbench.sv(134) @ 0: TEST [TEST] Build Phase
# KERNEL: UVM_INFO /home/runner/testbench.sv(103) @ 0: TEST.ENV [ENV] Build Phase
# KERNEL: UVM_INFO /home/runner/testbench.sv(72) @ 0: TEST.ENV.AGENT [AGENT] Build Phase
# KERNEL: UVM_INFO /home/runner/testbench.sv(15) @ 0: TEST.ENV.AGENT.DRV [DRV] Build Phase
# KERNEL: UVM_INFO /home/runner/testbench.sv(42) @ 0: TEST.ENV.AGENT.MON [MON] Build Phase
# KERNEL: UVM_INFO /home/runner/testbench.sv(20) @ 0: TEST.ENV.AGENT.DRV [DRV] Connect Phase
# KERNEL: UVM_INFO /home/runner/testbench.sv(47) @ 0: TEST.ENV.AGENT.MON [MON] Connect Phase
# KERNEL: UVM_INFO /home/runner/testbench.sv(79) @ 0: TEST.ENV.AGENT [AGENT] Connect Phase
# KERNEL: UVM_INFO /home/runner/testbench.sv(109) @ 0: TEST.ENV [ENV] Connect Phase
# KERNEL: UVM_INFO /home/runner/testbench.sv(140) @ 0: TEST [TEST] End of Elaboration Phase
# KERNEL: ----------------------------------------------------------
# KERNEL: Name                   Type                    Size  Value
# KERNEL: ----------------------------------------------------------
# KERNEL: TEST                   test                    -     @335 
# KERNEL:   ENV                  env                     -     @350 
# KERNEL:     AGENT              agent                   -     @361 
# KERNEL:       DRV              driver                  -     @382 
# KERNEL:         rsp_port       uvm_analysis_port       -     @401 
# KERNEL:         seq_item_port  uvm_seq_item_pull_port  -     @391 
# KERNEL:       MON              monitor                 -     @373 
# KERNEL: ----------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/testbench.sv(145) @ 0: TEST [TEST] Run Phase
# KERNEL: UVM_INFO /home/runner/testbench.sv(113) @ 0: TEST.ENV [ENV] Run Phase
# KERNEL: UVM_INFO /home/runner/testbench.sv(83) @ 0: TEST.ENV.AGENT [AGENT] Run Phase
# KERNEL: UVM_INFO /home/runner/testbench.sv(51) @ 0: TEST.ENV.AGENT.MON [MON] Run Phase
# KERNEL: UVM_INFO /home/runner/testbench.sv(24) @ 0: TEST.ENV.AGENT.DRV [DRV] Run Phase
# KERNEL: UVM_INFO /home/runner/testbench.sv(29) @ 0: TEST.ENV.AGENT.DRV [DRV] Report Phase
# KERNEL: UVM_INFO /home/runner/testbench.sv(56) @ 0: TEST.ENV.AGENT.MON [MON] Report Phase
# KERNEL: UVM_INFO /home/runner/testbench.sv(88) @ 0: TEST.ENV.AGENT [AGENT] Report Phase
# KERNEL: UVM_INFO /home/runner/testbench.sv(118) @ 0: TEST.ENV [ENV] Report Phase
# KERNEL: UVM_INFO /home/runner/testbench.sv(152) @ 0: TEST [TEST] Report Phase
*/

`include "uvm_macros.svh"
import uvm_pkg::*;
 
class driver extends uvm_driver;
    `uvm_component_utils(driver)
    
    function new(input string inst, uvm_component c);
        super.new(inst,c);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("DRV", "Build Phase", UVM_NONE);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("DRV", "Connect Phase", UVM_NONE);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        `uvm_info("DRV", "Run Phase", UVM_NONE);
    endtask
    
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("DRV", "Report Phase", UVM_NONE);
    endfunction
endclass

class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)
    
    function new(input string inst, uvm_component c);
        super.new(inst,c);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("MON", "Build Phase", UVM_NONE);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("MON", "Connect Phase", UVM_NONE);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        `uvm_info("MON", "Run Phase", UVM_NONE);
    endtask
    
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("MON", "Report Phase", UVM_NONE);
    endfunction
endclass
 
class agent extends uvm_agent;
    `uvm_component_utils(agent)
    
    monitor m;
    driver d;
    
    function new(input string inst, uvm_component c);
        super.new(inst,c);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("AGENT", "Build Phase", UVM_NONE);
        m = monitor::type_id::create("MON",this);
        d = driver::type_id::create("DRV", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("AGENT", "Connect Phase", UVM_NONE);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        `uvm_info("AGENT", "Run Phase", UVM_NONE);
    endtask
    
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("AGENT", "Report Phase", UVM_NONE);
    endfunction
 
endclass
 
class env extends uvm_env;
    `uvm_component_utils(env)
    agent a;
    
    function new(input string inst, uvm_component c);
        super.new(inst,c);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("ENV", "Build Phase", UVM_NONE);
        a = agent::type_id::create("AGENT",this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("ENV", "Connect Phase", UVM_NONE);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        `uvm_info("ENV", "Run Phase", UVM_NONE);
    endtask
    
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("ENV", "Report Phase", UVM_NONE);
    endfunction
endclass
 
 
class test extends uvm_test;
    `uvm_component_utils(test)
    
    env e;
    
    function new(input string inst, uvm_component c);
        super.new(inst,c);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TEST", "Build Phase", UVM_NONE);
        e = env::type_id::create("ENV",this);
    endfunction
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info("TEST", "End of Elaboration Phase", UVM_NONE);
        print();
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        `uvm_info("TEST", "Run Phase", UVM_NONE);
        #100;
        global_stop_request();
    endtask

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("TEST", "Report Phase", UVM_NONE);
    endfunction
endclass

module tb2();
    test t;
    initial begin
        t = new("TEST", null);
        run_test();
    end 
endmodule