`include "agent.sv"

class my_env extends uvm_env ;
   `uvm_component_utils (my_env)

   my_agent       m_agnt0; 
   my_agent       m_agnt1; 
   my_agent_v2    m_agnt2;

   function new (string name, uvm_component parent);
      super.new (name, parent);
   endfunction : new

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
      m_agnt0 = my_agent::type_id::create ("m_agnt0", this);
      m_agnt1 = my_agent::type_id::create ("m_agnt1", this);
      m_agnt2 = my_agent_v2::type_id::create ("m_agnt2", this);
   endfunction : build_phase
endclass : my_env