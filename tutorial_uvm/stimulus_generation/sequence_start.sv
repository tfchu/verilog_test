/**

UVM_INFO @ 0: reporter [RNTST] Running test base_test...
UVM_INFO testbench.sv(34) @ 0: uvm_test_top.ms@@bs [BASE_SEQ] Optional code can be placed here in pre_body()
UVM_INFO testbench.sv(40) @ 0: uvm_test_top.ms@@bs [BASE_SEQ] Starting body of bs
UVM_INFO /apps/vcsmx/vcs/Q-2020.03-SP1-1//etc/uvm-1.2/src/base/uvm_report_server.svh(894) @ 0: reporter [UVM/REPORT/SERVER] 

*/
class my_data extends uvm_sequence_item;
  
  	`uvm_object_utils (my_data)

    function new (string name = "my_data");
        super.new (name);
    endfunction
  
endclass

class my_sequencer extends uvm_sequencer #(my_data);

    `uvm_component_utils (my_sequencer)

    function new (string name, uvm_component parent);
        super.new (name, parent);
    endfunction

endclass

// user-defined sequence, with a data object type "my_data"
class base_sequence extends uvm_sequence #(my_data);
    `uvm_object_utils (base_sequence)               // register our sequence with the factory
    `uvm_declare_p_sequencer (my_sequencer)         // set default sequencer to "my_sequencer"
    // `uvm_declare_p_sequencer (uvm_sequencer #(my_data))     // also ok to use default sequencer

    my_data  data_obj;
    int unsigned      n_times = 1;

    function new (string name = "base_sequence");
        super.new (name);
    endfunction

    // optional task to run before body()
    virtual task pre_body ();
        `uvm_info ("BASE_SEQ", $sformatf ("Optional code can be placed here in pre_body()"), UVM_MEDIUM)
        if (starting_phase != null)
            starting_phase.raise_objection (this);
    endtask

    // this is the main stimulus, containing code to drive the stimulus to the driver
    // always raise a flag to let tb know that the sequence is active. 
    // and lower the flag when the sequence is finished so tb can exit gracefully
    // data object (my_data) is randomized and sent to the driver via "start_item" and "finish_item"
    virtual task body ();
        `uvm_info ("BASE_SEQ", $sformatf ("Starting body of %s", this.get_name()), UVM_MEDIUM)
        data_obj = my_data::type_id::create ("data_obj");

        repeat (n_times) begin
            start_item (data_obj);
            assert (data_obj.randomize ());
            finish_item (data_obj);
        end
        `uvm_info (get_type_name (), $sformatf ("Sequence %s is over", this.get_name()), UVM_MEDIUM)
    endtask
    
    // optional task to run after body()
    virtual task post_body ();
        `uvm_info ("BASE_SEQ", $sformatf ("Optional code can be placed here in post_body()"), UVM_MEDIUM)
        if (starting_phase != null) 
            starting_phase.drop_objection (this);
    endtask
endclass

class base_test extends uvm_test;
	`uvm_component_utils(base_test)

    my_sequencer ms;            // sequencer object required for start

    function new(string name = "base_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    // create sequencer object
    function void build_phase(uvm_phase phase);
        ms = my_sequencer::type_id::create("ms");
    endfunction
  
    // set default sequence to "base_sequence"
	function void start_of_simulation_phase (uvm_phase phase);
    	super.start_of_simulation_phase (phase);
        uvm_config_db#(uvm_object_wrapper)::set(this,"m_top_env.m_seqr0.main_phase", "default_sequence", base_sequence::type_id::get());
	endfunction

    // acutally run the base_sequence
    virtual task run_phase (uvm_phase phase);
        base_sequence bs = base_sequence::type_id::create("bs", this);
        bs.start(ms, null, , 1);
    endtask 
endclass

module tb;
    initial begin
        run_test("base_test");
    end
endmodule