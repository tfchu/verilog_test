class component_b extends uvm_component;
  
  transaction trans;
  uvm_analysis_imp#(transaction,component_b) analysis_imp;  

  `uvm_component_utils(component_b)
  
  //--------------------------------------- 
  // Constructor
  //---------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
    analysis_imp = new("analysis_imp", this);
  endfunction : new
  
  //---------------------------------------
  // Analysis Imp port write method
  //---------------------------------------
  virtual function void write(transaction trans);
    `uvm_info(get_type_name(),$sformatf(" Inside write method. Recived trans On Analysis Imp Port"),UVM_LOW)
    `uvm_info(get_type_name(),$sformatf(" Printing trans, \n %s",trans.sprint()),UVM_LOW)
  endfunction

endclass : component_b