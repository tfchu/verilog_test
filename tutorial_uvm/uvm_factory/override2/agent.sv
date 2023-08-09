//----------------- my_agent -------------------------------------------
class my_agent extends uvm_agent;
   `uvm_component_utils (my_agent)

   base_driver    m_drv0;
   my_sequencer   m_seqr0;

   function new (string name, uvm_component parent);
      super.new (name, parent);
   endfunction

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
      m_drv0 = base_driver::type_id::create ("m_drv0", this);
      m_seqr0 = my_sequencer::type_id::create ("m_seqr0", this);
   endfunction

   virtual function void connect_phase (uvm_phase phase);
      super.connect_phase (phase);
      m_drv0.seq_item_port.connect (m_seqr0.seq_item_export);
   endfunction
endclass

//----------------- my_agent_v2 -------------------------------------------
class my_agent_v2 extends uvm_agent;
   `uvm_component_utils (my_agent_v2)

   eth_driver     m_drv0;
   my_sequencer   m_seqr0;

   function new (string name, uvm_component parent);
      super.new (name, parent);
   endfunction

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
      m_drv0 = eth_driver::type_id::create ("m_drv0", this);
      m_seqr0 = my_sequencer::type_id::create ("m_seqr0", this);
   endfunction

   virtual function void connect_phase (uvm_phase phase);
      super.connect_phase (phase);
      m_drv0.seq_item_port.connect (m_seqr0.seq_item_export);
   endfunction
endclass
