`include "driver.sv"
`include "seq_item.sv"
`include "sequence.sv"
`include "env.sv"

class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  base_env m_env;
  
  virtual function void build_phase(uvm_phase phase);
  	// Get handle to the singleton factory instance
    uvm_factory factory = uvm_factory::get();
    
    super.build_phase(phase);

    // Set factory to override 'base_agent' by 'child_agent' by type
    set_type_override_by_type(base_agent::get_type(), child_agent::get_type());
    
    // Or set factory to override 'base_agent' by 'child_agent' by name
    // factory.set_type_override_by_name("base_agent", "child_agent");
    
    // Print factory configuration
    factory.print();
    
    // Now create environment 
    m_env = base_env::type_id::create("m_env", this);
  endfunction
endclass

class feature_test extends base_test;
    `uvm_component_utils (feature_test)

    function new (string name, uvm_component parent = null);
        super.new (name, parent);
    endfunction 

    virtual function void build_phase (uvm_phase phase);
        super.build_phase (phase); 

`ifdef PKT_OVERRIDE
        // Substitute all eth_packets with eth_v2_packet
        set_type_override_by_type (eth_packet::get_type(), eth_v2_packet::get_type());
`endif

// These are the three different styles to override something
`ifdef DRV_STYLE1
        // Substitute all instances of base_driver with driver2 
        set_type_override_by_type (base_driver::get_type(), spi_driver::get_type());
`elsif DRV_STYLE2
        // Substitute only eth_driver in agnt2 with spi_driver - by calling the component to be replaced method
        eth_driver::type_id::set_inst_override (spi_driver::get_type(), "m_top_env.m_agnt2.m_drv0", this);
`elsif DRV_STYLE3
        // Substitute base_driver only in agnt0 - by calling the factory method
        factory.set_inst_override_by_type (base_driver::get_type(), eth_driver::get_type(), {get_full_name(), ".m_top_env.m_agnt0.*"});
`endif

// Trying to override a sequence
`ifdef SEQ_TYPE
        // Substitute seq1 with seq2
        set_type_override_by_type (seq1::get_type(), seq3::get_type());
`elsif SEQ_INST
        // Substitute seq1 with seq2 only for agnt1
        set_inst_override_by_type ("m_top_env.m_agnt1.m_seqr0.*", seq1::get_type(), seq2::get_type());
`else
`endif
        factory.print();
    endfunction
    
    // Enter test code for feature here
endclass