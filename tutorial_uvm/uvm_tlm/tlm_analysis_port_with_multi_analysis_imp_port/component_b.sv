`uvm_analysis_imp_decl(_port_a)
`uvm_analysis_imp_decl(_port_b)

class component_b extends uvm_component;
  
  transaction trans;
  uvm_analysis_imp_port_a #(transaction,component_b) analysis_imp_a;  
  uvm_analysis_imp_port_b #(transaction,component_b) analysis_imp_b; 
  
  `uvm_component_utils(component_b)
  
  //--------------------------------------- 
  // Constructor
  //---------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
    analysis_imp_a = new("analysis_imp_a", this);
    analysis_imp_b = new("analysis_imp_b", this);
  endfunction : new
  
  //---------------------------------------
  // Analysis port write method
  //---------------------------------------
  virtual function void write_port_a(transaction trans);
    `uvm_info(get_type_name(),$sformatf(" Inside write_port_a method. Recived trans On Analysis Imp Port"),UVM_LOW)
    `uvm_info(get_type_name(),$sformatf(" Printing trans, \n %s",trans.sprint()),UVM_LOW)
  endfunction 
  
  //---------------------------------------
  // Analysis port write method
  //---------------------------------------
  virtual function void write_port_b(transaction trans);
    `uvm_info(get_type_name(),$sformatf(" Inside write_port_b method. Recived trans On Analysis Imp Port"),UVM_LOW)
    `uvm_info(get_type_name(),$sformatf(" Printing trans, \n %s",trans.sprint()),UVM_LOW)
  endfunction 
  
endclass : component_b