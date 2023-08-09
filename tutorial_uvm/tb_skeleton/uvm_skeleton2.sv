/**
more complex case which includes all components, e.g. if, transaction, sequence, ...
**/
interface my_if (input bit clk);
    logic [2:0] addr;
    logic [1:0] data;
    // optional, ok to use
    // clocking drvr_cb @(posedge clk);
    //     default output #1;
    //     output addr, data;
    // endclocking : drvr_cb
endinterface

class my_transaction extends uvm_sequence_item;
    rand bit [2:0] addr;
    rand bit [1:0] data;

    function new(string name = "");
        super.new(name);
    endfunction

    `uvm_object_utils_begin(my_transaction)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end
endclass : my_transaction

//typedef class my_sequencer;

class my_sequence extends uvm_sequence#(my_transaction);

    `uvm_object_utils(my_sequence)
    // `uvm_declare_p_sequencer(my_sequencer)

    my_transaction trans;

    function new(string name = "");
        super.new(name);
    endfunction

    task body();
        // m_sequencer and p_sequencer test
        // uvm_test_top.env.agnt.seqr@@seq [uvm_test_top.env.agnt.seqr.seq] uvm_test_top.env.agnt.seqr
        // `uvm_info(get_full_name(), m_sequencer.get_full_name(), UVM_LOW)    // ok
        // `uvm_info(get_full_name(), m_sequencer.test, UVM_LOW)               // error as m_sequencer is uvm_sequencer_base, which has no test property
        // `uvm_info(get_full_name(), p_sequencer.get_full_name(), UVM_LOW)    // ok with `uvm_declare_p_sequencer
        // `uvm_info(get_full_name(), p_sequencer.test, UVM_LOW)               // ok with `uvm_declare_p_sequencer
        repeat(10) begin
            trans = my_transaction::type_id::create("trans");
            start_item(trans);
            assert(trans.randomize());
            finish_item(trans);
        end
    endtask : body
endclass : my_sequence

class my_driver extends uvm_driver#(my_transaction);
    `uvm_component_utils(my_driver)

    virtual my_if vif;
    
    function new(input string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //`uvm_info("DRV", "Build Phase", UVM_NONE);
        if (!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif)) begin
            `uvm_error(get_full_name(), "cannot get vif")
        end
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        //`uvm_info("DRV", "Run Phase", UVM_NONE);
        forever begin
            my_transaction trans;
            @(posedge vif.clk);
            seq_item_port.get_next_item(trans);
            `uvm_info(get_full_name(), $sformatf("trans.addr=%d", trans.addr), UVM_LOW)
            `uvm_info(get_full_name(), $sformatf("trans.data=%d", trans.data), UVM_LOW)
            vif.addr <= trans.addr;
            vif.data <= trans.data;
            // also ok
            // vif.drvr_cb.addr <= trans.addr;
            // vif.drvr_cb.data <= trans.data;
            seq_item_port.item_done();
        end
    endtask
endclass : my_driver

class my_monitor extends uvm_monitor;
    `uvm_component_utils(my_monitor)

    virtual my_if vif;
    uvm_analysis_port#(my_transaction) ap;
    my_transaction trans;
    
    function new(input string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //`uvm_info("MON", "Build Phase", UVM_NONE);
        ap = new("ap", this);
        if (!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif)) begin
            `uvm_error(get_full_name(), "cannot get vif")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        //`uvm_info("MON", "Run Phase", UVM_NONE);
        forever begin
            @(posedge vif.clk);
            trans = my_transaction::type_id::create("tran");
            trans.addr = vif.addr;
            trans.data = vif.data;
            ap.write(trans);
        end
    endtask
endclass : my_monitor

class my_subscriber extends uvm_subscriber#(my_transaction);
    `uvm_component_utils(my_subscriber)

    function new(input string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void write(my_transaction trans);
        `uvm_info(get_full_name(), $sformatf("trans.addr=%d", trans.addr), UVM_LOW)
        `uvm_info(get_full_name(), $sformatf("trans.data=%d", trans.data), UVM_LOW)
    endfunction : write
    
endclass : my_subscriber

// class my_sequencer extends uvm_sequencer#(my_transaction);
//     `uvm_component_utils(my_sequencer)
//     string test = "test";

//     function new(input string name, uvm_component parent);
//         super.new(name, parent);
//     endfunction
// endclass

class my_agent extends uvm_agent;
    `uvm_component_utils(my_agent)
    
    uvm_sequencer#(my_transaction) seqr;
    //my_sequencer seqr;
    my_monitor mon;
    my_driver drvr;
    uvm_analysis_export#(my_transaction) ap;

    function new(input string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //`uvm_info("AGENT", "Build Phase", UVM_NONE);
        seqr = uvm_sequencer#(my_transaction)::type_id::create("seqr", this);
        //seqr = my_sequencer::type_id::create("seqr", this);
        mon = my_monitor::type_id::create("mon", this);
        drvr = my_driver::type_id::create("drvr", this);
        ap = new("ap", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        //`uvm_info("AGENT", "Connect Phase", UVM_NONE);
        drvr.seq_item_port.connect(seqr.seq_item_export);
        mon.ap.connect(ap);
    endfunction
endclass : my_agent
 
class my_env extends uvm_env;
    `uvm_component_utils(my_env)
    my_agent agnt;
    my_subscriber sbsc;
    
    function new(input string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //`uvm_info("ENV", "Build Phase", UVM_NONE);
        agnt = my_agent::type_id::create("agnt", this);
        sbsc = my_subscriber::type_id::create("sbsc", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        //`uvm_info("ENV", "Connect Phase", UVM_NONE);
        agnt.ap.connect(sbsc.analysis_export);
    endfunction
endclass : my_env
 
class my_test extends uvm_test;
    `uvm_component_utils(my_test)
    
    my_env env;
    my_sequence seq;
    
    function new(input string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //`uvm_info("TEST", "Build Phase", UVM_NONE);
        env = my_env::type_id::create("env",this);
        // auto-start: not work
        //uvm_config_db#(uvm_object_wrapper)::set(this, "env.agnt.seqr.main_phase", "default_sequence", my_sequence::type_id::get());
    endfunction
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        //`uvm_info("TEST", "End of Elaboration Phase", UVM_NONE);
        //print();
        uvm_top.print_topology();   // same as print()?
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        //`uvm_info("TEST", "Run Phase", UVM_NONE);
        seq = my_sequence::type_id::create("seq");
        assert(seq.randomize());
        seq.start(env.agnt.seqr);
        #100;
        //global_stop_request();
        phase.drop_objection(this);
    endtask
endclass : my_test

// optional DUT
module my_dut(my_if vif);
    always @(posedge vif.clk) begin
        $display("[dut] @ %t: addr=%d", $time, vif.addr);
        $display("[dut] @ %t: data=%d", $time, vif.data);
    end
endmodule : my_dut

module tb();
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    bit clk;
    my_if vif(clk);
    my_dut dut(vif);        // tb without dut can still run

    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd"); $dumpvars;
    end

    initial begin
        uvm_config_db#(virtual my_if)::set(uvm_root::get(), "*", "vif", vif);
        run_test("my_test");
    end 
endmodule