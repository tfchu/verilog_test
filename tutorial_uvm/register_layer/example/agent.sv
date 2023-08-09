`include "driver.sv"
`include "monitor.sv"

// The agent puts together the driver, sequencer and monitor
class my_agent extends uvm_agent;
   `uvm_component_utils (my_agent)
   function new (string name="my_agent", uvm_component parent);
      super.new (name, parent);
   endfunction

   my_driver                  m_drvr;
   my_monitor                 m_mon;
   uvm_sequencer #(bus_pkt)   m_seqr; 

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
      m_drvr = my_driver::type_id::create ("m_drvr", this);
      m_seqr = uvm_sequencer#(bus_pkt)::type_id::create ("m_seqr", this);
      m_mon = my_monitor::type_id::create ("m_mon", this);
   endfunction

   virtual function void connect_phase (uvm_phase phase);
      super.connect_phase (phase);
      m_drvr.seq_item_port.connect (m_seqr.seq_item_export);
   endfunction
endclass