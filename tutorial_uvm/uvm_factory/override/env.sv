// Environment contains the agent
class base_env extends uvm_env;
    `uvm_component_utils(base_env)
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    // 'm_agent' is a class handle to hold base_agent
    // type class objects
    base_agent m_agent;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Use create method to request factory to return a base_agent
        // type of class object
        m_agent = base_agent::type_id::create("m_agent", this);
        
        // Now print the type of the object pointing to by the 'm_agent' class handle
        `uvm_info("AGENT", $sformatf("Factory returned agent of type=%s, path=%s", m_agent.get_type_name(), m_agent.get_full_name()), UVM_LOW)
    endfunction                           
endclass