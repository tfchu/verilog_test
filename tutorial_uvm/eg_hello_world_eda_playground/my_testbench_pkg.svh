/**

using package is a good practice to separate different part of the environment

*/

package my_testbench_pkg;
  import uvm_pkg::*;
  
  // The UVM sequence, transaction item, and driver are in these files:
  `include "my_sequence.svh"
  `include "my_driver.svh"
  
  // The agent contains sequencer, driver, and monitor (not included)
  // the sequencer runs the sequence, and then sends transactions to the driver
  // then driver drives the sequence on the bus via the virtual I/F 
  class my_agent extends uvm_agent;
    `uvm_component_utils(my_agent)
    
    my_driver driver;
    uvm_sequencer#(my_transaction) sequencer;       // our sequencer is simply a UVM default sequencer parameterized with "my_transaction"
    
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    
    // instantiate driver and sequencer as UVM hierarchy requires this
    function void build_phase(uvm_phase phase);
      driver = my_driver ::type_id::create("driver", this);
      sequencer =
        uvm_sequencer#(my_transaction)::type_id::create("sequencer", this);
    endfunction    
    
    // In UVM connect phase, we connect the sequencer to the driver.
    // thru this connection, "my_transaction" instances will be sent from the sequencer to the driver
    function void connect_phase(uvm_phase phase);
      driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
    
    // create a sequence, then start it on a sequencer
    task run_phase(uvm_phase phase);
      // We raise objection to keep the test from completing!!
      // the test completes when all components drop the objection
      // in this case, my_agent is the last to drop so test runs until all sequences are sent
      phase.raise_objection(this);
      begin
        my_sequence seq;
        seq = my_sequence::type_id::create("seq");
        seq.start(sequencer);                       // "sequence" uses the connection between "sequencer" and "driver" to send trasactions 
      end
      // We drop objection to allow the test to complete
      phase.drop_objection(this);
    endtask

  endclass
  
  // "my_env" simply contains the agent "my_agent", so we simply instantiates "my_agent"
  // in real case, we may have multiple agents, and multiple higher-level sequencers that control these agents
  class my_env extends uvm_env;
    `uvm_component_utils(my_env)
    
    my_agent agent;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      agent = my_agent::type_id::create("agent", this);
    endfunction

  endclass
  
  // "my_test" simply contains the environment "my_env", so we simply instantiates "my_env"
  class my_test extends uvm_test;
    `uvm_component_utils(my_test)
    
    my_env env;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      // the syntax to create UVM components in UVM
      // it is written this way to make the tb flexible so we can override the actual types of agent (or others) that gets created
      env = my_env::type_id::create("env", this);       // create the environment
    endfunction
    
    // where simulation happens, here we simply print "Hello World!" @ 10 tu
    task run_phase(uvm_phase phase);
      // We raise objection to keep the test from completing
      phase.raise_objection(this);
      #10;
      `uvm_warning("", "Hello World!")
      // We drop objection to allow the test to complete
      phase.drop_objection(this);
    endtask

  endclass

  // class child_test extends my_test;
  //   `uvm_component_utils(child_test)

  //   function new(string name, uvm_component parent);
  //     super.new(name, parent);
  //   endfunction

  //   function void build_phase(uvm_phase phase);
  //     super.build_phase(phase);
  //   endfunction

  // endclass
  
endpackage