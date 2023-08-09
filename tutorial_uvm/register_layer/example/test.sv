`include "env.sv"
`include "sequence.sv"

class base_test extends uvm_test;
   `uvm_component_utils (base_test)

   my_env         m_env;
   reset_seq      m_reset_seq;
   uvm_status_e   status;

   function new (string name = "base_test", uvm_component parent);
      super.new (name, parent);
   endfunction

   // Build the testbench environment, and reset sequence
   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
      m_env = my_env::type_id::create ("m_env", this);
      m_reset_seq = reset_seq::type_id::create ("m_reset_seq", this);
   endfunction
 
   // In the reset phase, apply reset
   virtual task reset_phase (uvm_phase phase);
      super.reset_phase (phase);
      phase.raise_objection (this);
      m_reset_seq.start (m_env.m_agent.m_seqr);
      phase.drop_objection (this);
   endtask
endclass

class reg_rw_test extends base_test;
   `uvm_component_utils (reg_rw_test)
   function new (string name="reg_rw_test", uvm_component parent);
      super.new (name, parent);
   endfunction

   // Note that main_phase comes after reset_phase, and is performed when
   // DUT is out of reset. "reset_phase" is already defined in base_test
   // and is always called when this test is started
   virtual task main_phase(uvm_phase phase);
      ral_sys_traffic   m_ral_model;
      uvm_status_e      status;
      int               rdata;

      phase.raise_objection(this);

      m_env.m_reg_env.set_report_verbosity_level (UVM_HIGH);
      
      // Get register model from config_db
      uvm_config_db#(ral_sys_traffic)::get(null, "uvm_test_top", "m_ral_model", m_ral_model);
      
      // Write 0xcafe_feed to the timer[1] register, and read it back
      m_ral_model.cfg.timer[1].write (status, 32'hcafe_feed);
      m_ral_model.cfg.timer[1].read (status, rdata);
      
      // Set 0xface as the desired value for timer[1] register
      m_ral_model.cfg.timer[1].set(32'hface);
      `uvm_info(get_type_name(), $sformatf("desired=0x%0h mirrored=0x%0h", m_ral_model.cfg.timer[1].get(), m_ral_model.cfg.timer[1].get_mirrored_value()), UVM_MEDIUM)
      
      // Predict that current value of timer[1] is 0xcafe_feed and check it is true
      m_ral_model.cfg.timer[1].predict(32'hcafe_feed);
      m_ral_model.cfg.timer[1].mirror(status, UVM_CHECK);
      
      // Set desired value of the field "bl_yellow" in register ctrl to 1
      // Then start bus transactions by calling "update" to update DUT with 
      // desired value
      m_ral_model.cfg.ctrl.bl_yellow.set(1);
      m_ral_model.cfg.update(status);

	  // Attempt to write into a RO register "stat" with some value
      m_ral_model.cfg.stat.write(status, 32'h12345678);
      phase.drop_objection(this);
   endtask

  // Before end of simulation, allow some time for unfinished transactions to
  // be over
  virtual task shutdown_phase(uvm_phase phase);
    super.shutdown_phase(phase);
    phase.raise_objection(this);
    #100ns;
    phase.drop_objection(this);
  endtask
endclass

class reg_backdoor_test extends base_test;
    `uvm_component_utils (reg_backdoor_test)
    function new (string name="reg_backdoor_test", uvm_component parent);
        super.new (name, parent);
    endfunction

    virtual task main_phase(uvm_phase phase);
        ral_sys_traffic   m_ral_model;
        uvm_status_e      status;
        int               rdata;

        phase.raise_objection(this);

        m_env.m_reg_env.set_report_verbosity_level (UVM_HIGH);
        uvm_config_db#(ral_sys_traffic)::get(null, "uvm_test_top", "m_ral_model", m_ral_model);

        // Perform a normal frontdoor access -> write some data first and then read it back
        m_ral_model.cfg.timer[1].write(status, 32'h1234_5678);
        m_ral_model.cfg.timer[1].read(status, rdata);
        `uvm_info(get_type_name(), $sformatf("desired=0x%0h mirrored=0x%0h", m_ral_model.cfg.timer[1].get(), m_ral_model.cfg.timer[1].get_mirrored_value()), UVM_MEDIUM)
        
        // Perform a backdoor access for write and then do a frontdoor read 
        m_ral_model.cfg.timer[1].write(status, 32'ha5a5_a5a5, UVM_BACKDOOR);
        m_ral_model.cfg.timer[1].read(status, rdata);
        `uvm_info(get_type_name(), $sformatf("desired=0x%0h mirrored=0x%0h", m_ral_model.cfg.timer[1].get(), m_ral_model.cfg.timer[1].get_mirrored_value()), UVM_MEDIUM)

        // Perform a frontdoor write and then do a backdoor read
        m_ral_model.cfg.timer[1].write(status, 32'hface_face);
        // Wait for a time unit so that backdoor access reads update value
        #1;  
        m_ral_model.cfg.timer[1].read(status, rdata, UVM_BACKDOOR);
        `uvm_info(get_type_name(), $sformatf("desired=0x%0h mirrored=0x%0h", m_ral_model.cfg.timer[1].get(), m_ral_model.cfg.timer[1].get_mirrored_value()), UVM_MEDIUM)

        phase.drop_objection(this);
    endtask

    virtual task shutdown_phase(uvm_phase phase);
        super.shutdown_phase(phase);
        phase.raise_objection(this);
        #100ns;
        phase.drop_objection(this);
    endtask
endclass
