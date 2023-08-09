// override by type/name
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

// instance override by type/name
class base_test1 extends uvm_test;
	`uvm_component_utils(base_test)
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
	
	base_env m_env;
	uvm_table_printer printer;
	
	virtual function void build_phase(uvm_phase phase);
		// Get handle to the singleton factory instance
		uvm_factory factory = uvm_factory::get();
		
		super.build_phase(phase);

		// Set factory to override all instances under m_env of type 'base_agent' by 'child_agent'
		set_inst_override_by_type("m_env.*", base_agent::get_type(), child_agent::get_type());
		
		// Or set factory to override all instances under 'm_env' called 'base_agent' by 'child_agent' by name
		// factory.set_inst_override_by_name("base_agent", "child_agent", {get_full_name(), ".m_env.*"});
		
		// Print factory configuration
		factory.print();
		
		// Now create environment 
		m_env = base_env::type_id::create("m_env", this);

		// used to print topology
		printer = new();
		printer.knobs.depth=3;
	endfunction

	virtual function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		`uvm_info(get_type_name(), $sformatf("Printing the test topology :\n%s", this.sprint(printer)), UVM_LOW)
	endfunction
endclass