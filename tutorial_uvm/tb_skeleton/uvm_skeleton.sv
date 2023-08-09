/** 
a simple skeleton which prints all phases
**/
`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver;
    `uvm_component_utils(driver)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
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
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
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
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("AGENT", "Build Phase", UVM_NONE);
        m = monitor::type_id::create("MON", this);
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

class child_agent extends agent;
    `uvm_component_utils(child_agent)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        `uvm_info("CHILD_AGENT", "Build Phase", UVM_NONE);
    endfunction

endclass

class grand_child_agent extends child_agent;
    `uvm_component_utils(grand_child_agent)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass
 
class env extends uvm_env;
    `uvm_component_utils(env)
    grand_child_agent gca;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
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
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
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