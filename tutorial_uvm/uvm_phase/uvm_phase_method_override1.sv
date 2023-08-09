/**
demonstrate how virtual method (UVM phase method) override affects result
- child_agent extends agent, and child_phase does not override any phase method from agent, so agent's phase methods run. see [AGENT] xxx Phase
- output format
    <full_instance_path> [<msg_id>] <msg>
    - <full_instance_path>: each instance name is from <class>::type_id::create("inst_name"), full_inst_path concatenate top-down with dot "."
    - <msg_id> and <msg>: from `uvm_info(<msg_id>, msg, level)
- "virtual" affects which implementation runs
    - if child methods override parent's virtual methods, then child's methods run
    - if not, then parent's methods run

UVM_INFO @ 0: reporter [RNTST] Running test ...
UVM_INFO testbench.sv(146) @ 0: TEST [TEST] Build Phase
UVM_INFO testbench.sv(114) @ 0: TEST.ENV [ENV] Build Phase
UVM_INFO testbench.sv(70) @ 0: TEST.ENV.CHILD_AGENT [AGENT] Build Phase             // agent build_phase()
UVM_INFO testbench.sv(13) @ 0: TEST.ENV.CHILD_AGENT.DRV [DRV] Build Phase
UVM_INFO testbench.sv(40) @ 0: TEST.ENV.CHILD_AGENT.MON [MON] Build Phase
UVM_INFO testbench.sv(18) @ 0: TEST.ENV.CHILD_AGENT.DRV [DRV] Connect Phase
UVM_INFO testbench.sv(45) @ 0: TEST.ENV.CHILD_AGENT.MON [MON] Connect Phase
UVM_INFO testbench.sv(77) @ 0: TEST.ENV.CHILD_AGENT [AGENT] Connect Phase           // agent connect_phase()
UVM_INFO testbench.sv(121) @ 0: TEST.ENV [ENV] Connect Phase
UVM_INFO testbench.sv(152) @ 0: TEST [TEST] End of Elaboration Phase
----------------------------------------------------------
Name                   Type                    Size  Value
----------------------------------------------------------
TEST                   test                    -     @336 
  ENV                  env                     -     @351 
    CHILD_AGENT        child_agent             -     @362 
      DRV              driver                  -     @383 
        rsp_port       uvm_analysis_port       -     @402 
        seq_item_port  uvm_seq_item_pull_port  -     @392 
      MON              monitor                 -     @374 
----------------------------------------------------------
UVM_INFO testbench.sv(22) @ 0: TEST.ENV.CHILD_AGENT.DRV [DRV] Run Phase
UVM_INFO testbench.sv(49) @ 0: TEST.ENV.CHILD_AGENT.MON [MON] Run Phase
UVM_INFO testbench.sv(81) @ 0: TEST.ENV.CHILD_AGENT [AGENT] Run Phase               // agent run_phase()
UVM_INFO testbench.sv(125) @ 0: TEST.ENV [ENV] Run Phase
UVM_INFO testbench.sv(157) @ 0: TEST [TEST] Run Phase
UVM_INFO testbench.sv(27) @ 0: TEST.ENV.CHILD_AGENT.DRV [DRV] Report Phase
UVM_INFO testbench.sv(54) @ 0: TEST.ENV.CHILD_AGENT.MON [MON] Report Phase
UVM_INFO testbench.sv(86) @ 0: TEST.ENV.CHILD_AGENT [AGENT] Report Phase            // agent report_phase()
UVM_INFO testbench.sv(130) @ 0: TEST.ENV [ENV] Report Phase
UVM_INFO testbench.sv(164) @ 0: TEST [TEST] Report Phase
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

// child_agent does not override phase methods
// hence agent phase methods run
class child_agent extends agent;
    `uvm_component_utils(child_agent)

    function new(input string inst, uvm_component c);
        super.new(inst,c);
    endfunction

    //virtual function void build_phase(uvm_phase phase);
    //    `uvm_info("CHILD_AGENT", "Build Phase", UVM_NONE);
    //endfunction

endclass

class env extends uvm_env;
    `uvm_component_utils(env)
    child_agent ca;
    
    function new(input string inst, uvm_component c);
        super.new(inst,c);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("ENV", "Build Phase", UVM_NONE);
        //a = agent::type_id::create("AGENT",this);
        ca = child_agent::type_id::create("CHILD_AGENT", this);
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