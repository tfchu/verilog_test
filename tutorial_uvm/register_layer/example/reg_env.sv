`include "reg_model.sv"

class reg2apb_adapter extends uvm_reg_adapter;
   `uvm_object_utils (reg2apb_adapter)

   function new (string name = "reg2apb_adapter");
      super.new (name);
   endfunction

   virtual function uvm_sequence_item reg2bus (const ref uvm_reg_bus_op rw);
      bus_pkt pkt = bus_pkt::type_id::create ("pkt");
      pkt.write = (rw.kind == UVM_WRITE) ? 1: 0;
      pkt.addr  = rw.addr;
      pkt.data  = rw.data;
      `uvm_info ("adapter", $sformatf ("reg2bus addr=0x%0h data=0x%0h kind=%s", pkt.addr, pkt.data, rw.kind.name), UVM_DEBUG) 
      return pkt; 
   endfunction

   virtual function void bus2reg (uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
      bus_pkt pkt;
      if (! $cast (pkt, bus_item)) begin
         `uvm_fatal ("reg2apb_adapter", "Failed to cast bus_item to pkt")
      end
   
      rw.kind = pkt.write ? UVM_WRITE : UVM_READ;
      rw.addr = pkt.addr;
      rw.data = pkt.data;
      `uvm_info ("adapter", $sformatf("bus2reg : addr=0x%0h data=0x%0h kind=%s status=%s", rw.addr, rw.data, rw.kind.name(), rw.status.name()), UVM_DEBUG)
   endfunction
endclass

// Register environment class puts together the model, adapter and the predictor
class reg_env extends uvm_env;
   `uvm_component_utils (reg_env)
   function new (string name="reg_env", uvm_component parent);
      super.new (name, parent);
   endfunction

   ral_sys_traffic                m_ral_model;         // Register Model
   reg2apb_adapter                m_reg2apb;           // Convert Reg Tx <-> Bus-type packets
   uvm_reg_predictor #(bus_pkt)   m_apb2reg_predictor; // Map APB tx to register in model
   my_agent                       m_agent;             // Agent to drive/monitor transactions

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
      m_ral_model          = ral_sys_traffic::type_id::create ("m_ral_model", this);
      m_reg2apb            = reg2apb_adapter :: type_id :: create ("m_reg2apb");
      m_apb2reg_predictor  = uvm_reg_predictor #(bus_pkt) :: type_id :: create ("m_apb2reg_predictor", this);

      m_ral_model.build ();
      m_ral_model.lock_model ();
      uvm_config_db #(ral_sys_traffic)::set (null, "uvm_test_top", "m_ral_model", m_ral_model);
   endfunction

   virtual function void connect_phase (uvm_phase phase);
      super.connect_phase (phase);
      m_apb2reg_predictor.map       = m_ral_model.default_map;
      m_apb2reg_predictor.adapter   = m_reg2apb;
   endfunction   
endclass