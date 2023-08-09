`include "transaction.sv"
`include "component_a.sv"
`include "component_b.sv"

class environment extends uvm_env;
  
  //---------------------------------------
  // Components Instantiation
  //---------------------------------------
  component_a comp_a;
  component_b comp_b;
  
  `uvm_component_utils(environment)
  
  //--------------------------------------- 
  // Constructor
  //---------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //---------------------------------------
  // build_phase - Create the components
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    comp_a = component_a::type_id::create("comp_a", this);
    comp_b = component_b::type_id::create("comp_b", this);
  endfunction : build_phase
  
  //---------------------------------------
  // Connect_phase 
  //---------------------------------------
  function void connect_phase(uvm_phase phase);
    comp_a.analysis_port.connect(comp_b.analysis_imp);
  endfunction : connect_phase
endclass : environment