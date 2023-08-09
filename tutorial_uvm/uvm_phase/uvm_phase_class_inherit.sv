/**
[Udemy Writing UVM testbenches for Newbie] 

description
- similar to uvm_phase.sv, add parent class of env and see if parent class's phases run

result
- case 1: parent's corresponding phases run only when child class calls super()
- case 2: all instantiated classes follows UVM phase rules

# case 1: agent is only instantiated in class env (not parent ENV, or class env_p)
UVM_INFO @ 0: reporter [RNTST] Running test ...
UVM_INFO testbench.sv(246) @ 0: TEST [TEST] Build Phase
UVM_INFO testbench.sv(186) @ 0: TEST.ENV [ENV_P] Build Phase <-- runs due to super() from ENV
UVM_INFO testbench.sv(215) @ 0: TEST.ENV [ENV] Build Phase
UVM_INFO testbench.sv(154) @ 0: TEST.ENV.AGENT [AGENT] Build Phase
UVM_INFO testbench.sv(97) @ 0: TEST.ENV.AGENT.DRV [DRV] Build Phase
UVM_INFO testbench.sv(124) @ 0: TEST.ENV.AGENT.MON [MON] Build Phase
UVM_INFO testbench.sv(102) @ 0: TEST.ENV.AGENT.DRV [DRV] Connect Phase
UVM_INFO testbench.sv(129) @ 0: TEST.ENV.AGENT.MON [MON] Connect Phase
UVM_INFO testbench.sv(161) @ 0: TEST.ENV.AGENT [AGENT] Connect Phase
UVM_INFO testbench.sv(192) @ 0: TEST.ENV [ENV_P] Connect Phase
UVM_INFO testbench.sv(221) @ 0: TEST.ENV [ENV] Connect Phase
UVM_INFO testbench.sv(252) @ 0: TEST [TEST] End of Elaboration Phase
----------------------------------------------------------
Name                   Type                    Size  Value
----------------------------------------------------------
TEST                   test                    -     @336 
  ENV                  env                     -     @351 
    AGENT              agent                   -     @364 
      DRV              driver                  -     @385 
        rsp_port       uvm_analysis_port       -     @404 
        seq_item_port  uvm_seq_item_pull_port  -     @394 
      MON              monitor                 -     @376 
----------------------------------------------------------
UVM_INFO testbench.sv(106) @ 0: TEST.ENV.AGENT.DRV [DRV] Run Phase
UVM_INFO testbench.sv(133) @ 0: TEST.ENV.AGENT.MON [MON] Run Phase
UVM_INFO testbench.sv(165) @ 0: TEST.ENV.AGENT [AGENT] Run Phase
UVM_INFO testbench.sv(225) @ 0: TEST.ENV [ENV] Run Phase
UVM_INFO testbench.sv(257) @ 0: TEST [TEST] Run Phase
UVM_INFO testbench.sv(111) @ 0: TEST.ENV.AGENT.DRV [DRV] Report Phase
UVM_INFO testbench.sv(138) @ 0: TEST.ENV.AGENT.MON [MON] Report Phase
UVM_INFO testbench.sv(170) @ 0: TEST.ENV.AGENT [AGENT] Report Phase
UVM_INFO testbench.sv(201) @ 0: TEST.ENV [ENV_P] Report Phase
UVM_INFO testbench.sv(230) @ 0: TEST.ENV [ENV] Report Phase
UVM_INFO testbench.sv(264) @ 0: TEST [TEST] Report Phase
UVM_INFO /apps/vcsmx/vcs/S-2021.09//etc/uvm-1.2/src/base/uvm_report_server.svh(904) @ 0: reporter [UVM/REPORT/SERVER] 

# case 2: both class env, and class env_p (parent env) instantiate agent ("AGENT" in env, "AGENT_ENV_P" in env_p)
UVM_INFO @ 0: reporter [RNTST] Running test ...
UVM_INFO testbench.sv(246) @ 0: TEST [TEST] Build Phase
UVM_INFO testbench.sv(186) @ 0: TEST.ENV [ENV_P] Build Phase
UVM_INFO testbench.sv(215) @ 0: TEST.ENV [ENV] Build Phase
UVM_INFO testbench.sv(154) @ 0: TEST.ENV.AGENT [AGENT] Build Phase              // ENV -> AGENT
UVM_INFO testbench.sv(97) @ 0: TEST.ENV.AGENT.DRV [DRV] Build Phase             // ENV -> AGENT -> DRV
UVM_INFO testbench.sv(124) @ 0: TEST.ENV.AGENT.MON [MON] Build Phase            // ENV -> AGENT -> MON
UVM_INFO testbench.sv(154) @ 0: TEST.ENV.AGENT_ENV_P [AGENT] Build Phase        // ENV_P -> AGENT_ENV_P due to ENV calls super()
UVM_INFO testbench.sv(97) @ 0: TEST.ENV.AGENT_ENV_P.DRV [DRV] Build Phase       // ENV_P -> AGENT_ENV_P -> DRV
UVM_INFO testbench.sv(124) @ 0: TEST.ENV.AGENT_ENV_P.MON [MON] Build Phase      // ENV_P -> AGENT_ENV_P -> MON
UVM_INFO testbench.sv(102) @ 0: TEST.ENV.AGENT.DRV [DRV] Connect Phase          // ENV -> AGENT -> DRV
UVM_INFO testbench.sv(129) @ 0: TEST.ENV.AGENT.MON [MON] Connect Phase          // ENV -> AGENT -> MON
UVM_INFO testbench.sv(161) @ 0: TEST.ENV.AGENT [AGENT] Connect Phase            // ENV -> AGENT
UVM_INFO testbench.sv(102) @ 0: TEST.ENV.AGENT_ENV_P.DRV [DRV] Connect Phase    // ENV_P -> AGENT_ENV_P -> DRV
UVM_INFO testbench.sv(129) @ 0: TEST.ENV.AGENT_ENV_P.MON [MON] Connect Phase    // ENV_P -> AGENT_ENV_P -> MON
UVM_INFO testbench.sv(161) @ 0: TEST.ENV.AGENT_ENV_P [AGENT] Connect Phase      // ENV_P -> AGENT_ENV_P
UVM_INFO testbench.sv(192) @ 0: TEST.ENV [ENV_P] Connect Phase                  // ENV_P
UVM_INFO testbench.sv(221) @ 0: TEST.ENV [ENV] Connect Phase                    // ENV
UVM_INFO testbench.sv(252) @ 0: TEST [TEST] End of Elaboration Phase
----------------------------------------------------------
Name                   Type                    Size  Value
----------------------------------------------------------
TEST                   test                    -     @336 
  ENV                  env                     -     @351 
    AGENT              agent                   -     @373 
      DRV              driver                  -     @394 
        rsp_port       uvm_analysis_port       -     @413 
        seq_item_port  uvm_seq_item_pull_port  -     @403 
      MON              monitor                 -     @385 
    AGENT_ENV_P        agent                   -     @362 
      DRV              driver                  -     @439 
        rsp_port       uvm_analysis_port       -     @458 
        seq_item_port  uvm_seq_item_pull_port  -     @448 
      MON              monitor                 -     @430 
----------------------------------------------------------
UVM_INFO testbench.sv(106) @ 0: TEST.ENV.AGENT.DRV [DRV] Run Phase
UVM_INFO testbench.sv(133) @ 0: TEST.ENV.AGENT.MON [MON] Run Phase
UVM_INFO testbench.sv(165) @ 0: TEST.ENV.AGENT [AGENT] Run Phase
UVM_INFO testbench.sv(106) @ 0: TEST.ENV.AGENT_ENV_P.DRV [DRV] Run Phase
UVM_INFO testbench.sv(133) @ 0: TEST.ENV.AGENT_ENV_P.MON [MON] Run Phase
UVM_INFO testbench.sv(165) @ 0: TEST.ENV.AGENT_ENV_P [AGENT] Run Phase
UVM_INFO testbench.sv(225) @ 0: TEST.ENV [ENV] Run Phase
UVM_INFO testbench.sv(257) @ 0: TEST [TEST] Run Phase
UVM_INFO testbench.sv(111) @ 0: TEST.ENV.AGENT.DRV [DRV] Report Phase
UVM_INFO testbench.sv(138) @ 0: TEST.ENV.AGENT.MON [MON] Report Phase
UVM_INFO testbench.sv(170) @ 0: TEST.ENV.AGENT [AGENT] Report Phase
UVM_INFO testbench.sv(111) @ 0: TEST.ENV.AGENT_ENV_P.DRV [DRV] Report Phase
UVM_INFO testbench.sv(138) @ 0: TEST.ENV.AGENT_ENV_P.MON [MON] Report Phase
UVM_INFO testbench.sv(170) @ 0: TEST.ENV.AGENT_ENV_P [AGENT] Report Phase
UVM_INFO testbench.sv(201) @ 0: TEST.ENV [ENV_P] Report Phase
UVM_INFO testbench.sv(230) @ 0: TEST.ENV [ENV] Report Phase
UVM_INFO testbench.sv(264) @ 0: TEST [TEST] Report Phase
UVM_INFO /apps/vcsmx/vcs/S-2021.09//etc/uvm-1.2/src/base/uvm_report_server.svh(904) @ 0: reporter [UVM/REPORT/SERVER] 
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
 
// env parent
class env_p extends uvm_env;
    `uvm_component_utils(env_p)
    agent a;
    
    function new(input string inst, uvm_component c);
        super.new(inst,c);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("ENV_P", "Build Phase", UVM_NONE);
        a = agent::type_id::create("AGENT",this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("ENV_P", "Connect Phase", UVM_NONE);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        `uvm_info("ENV_P", "Run Phase", UVM_NONE);
    endtask
    
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("ENV_P", "Report Phase", UVM_NONE);
    endfunction
endclass

class env extends env_p;
    `uvm_component_utils(env)
    agent a;
    
    function new(input string inst, uvm_component c);
        super.new(inst,c);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //`uvm_info("ENV", "Build Phase", UVM_NONE);
        //a = agent::type_id::create("AGENT",this);
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