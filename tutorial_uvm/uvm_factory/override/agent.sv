// Define a base class agent
class base_agent extends uvm_agent;
    `uvm_component_utils(base_agent)
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

// Define child class that extends base agent
class child_agent extends base_agent;
    `uvm_component_utils(child_agent)
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass