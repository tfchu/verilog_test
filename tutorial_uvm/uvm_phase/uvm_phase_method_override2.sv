/**
demonstrate how virtual method (UVM phase method) override affects result
similar to uvm_phase_method_override1.sv
- grand_child_agent extends child_agent, and grand_child_agent does nto override any phase methods, so child_agent's phase methods run
- child_agent extends agent, and child_phase overrides build_phase from agent, so child_agent build_phase() runs. see [CHILD_AGENT] Build Phase
- and agent's other phase methods run (connect_phase, run_phase, report_phase). see [AGENT] xxx Phase
- "virtual" affects which implementation runs
    - if child methods override parent's virtual methods, then child's methods run
    - if not, then parent's methods run

UVM_INFO @ 0: reporter [RNTST] Running test ...
UVM_INFO testbench.sv(154) @ 0: TEST [TEST] Build Phase
UVM_INFO testbench.sv(122) @ 0: TEST.ENV [ENV] Build Phase
UVM_INFO testbench.sv(99) @ 0: TEST.ENV.GRAND_CHILD_AGENT [CHILD_AGENT] Build Phase     // child_agent overrides build_phase()
UVM_INFO testbench.sv(77) @ 0: TEST.ENV.GRAND_CHILD_AGENT [AGENT] Connect Phase         // 
UVM_INFO testbench.sv(129) @ 0: TEST.ENV [ENV] Connect Phase
UVM_INFO testbench.sv(160) @ 0: TEST [TEST] End of Elaboration Phase
-----------------------------------------------------
Name                   Type               Size  Value
-----------------------------------------------------
TEST                   test               -     @336 
  ENV                  env                -     @351 
    GRAND_CHILD_AGENT  grand_child_agent  -     @362 
-----------------------------------------------------
UVM_INFO testbench.sv(81) @ 0: TEST.ENV.GRAND_CHILD_AGENT [AGENT] Run Phase
UVM_INFO testbench.sv(133) @ 0: TEST.ENV [ENV] Run Phase
UVM_INFO testbench.sv(165) @ 0: TEST [TEST] Run Phase
UVM_INFO testbench.sv(86) @ 0: TEST.ENV.GRAND_CHILD_AGENT [AGENT] Report Phase
UVM_INFO testbench.sv(138) @ 0: TEST.ENV [ENV] Report Phase
UVM_INFO testbench.sv(172) @ 0: TEST [TEST] Report Phase
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
 
// parent agent that implements all phase methods - build, connect, run, report
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

// child_agent overrides build_phase, so its build_phase runs
class child_agent extends agent;
    `uvm_component_utils(child_agent)

    function new(input string inst, uvm_component c);
        super.new(inst,c);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        `uvm_info("CHILD_AGENT", "Build Phase", UVM_NONE);
    endfunction

endclass


// grand_child_agent does not override phase method, so child_agent phase methods run
class grand_child_agent extends child_agent;
    `uvm_component_utils(grand_child_agent)

    function new(input string inst, uvm_component c);
        super.new(inst,c);
    endfunction
endclass
 
// instantiate grand_child_agent, all phase methods will run
// (1) grand_child_agent does not implement any phase methods, its parent (child_agent) phase methods run
// (2) child_agent overrides build_phase() of agent, so child_agent build_phase() runs - print [CHILD_AGENT] Build Phase
// (3) agent phase methods connect_phase(), run_phase(), report_phase() run - print [AGENT] Connect Phase, [AGENT] Run Phase, [AGENT] Report Phase
class env extends uvm_env;
    `uvm_component_utils(env)
    grand_child_agent gca;
    
    function new(input string inst, uvm_component c);
        super.new(inst,c);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("ENV", "Build Phase", UVM_NONE);
        //a = agent::type_id::create("AGENT",this);
        gca = grand_child_agent::type_id::create("GRAND_CHILD_AGENT", this);
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

module tb();
    test t;
    initial begin
        t = new("TEST", null);
        run_test();
    end 
endmodule