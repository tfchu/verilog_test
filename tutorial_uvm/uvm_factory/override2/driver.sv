//------------------ base_driver-----------------------------------

class base_driver #(type T=eth_packet) extends uvm_driver;
   `uvm_component_utils (base_driver #(T))

   T pkt;

   function new (string name, uvm_component parent);
      super.new (name, parent);
   endfunction

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
      pkt = T::type_id::create ("pkt0");
   endfunction

   virtual task run_phase (uvm_phase phase);
      super.run_phase (phase);
      `uvm_info (get_type_name(), $sformatf("Driver running ...with packet of type : %s", pkt.get_type_name()), UVM_MEDIUM)
   endtask

endclass

//----------------- eth_driver-----------------------------------

class eth_driver #(type T=eth_packet) extends base_driver #(T);
   `uvm_component_utils (eth_driver #(T))

   function new (string name, uvm_component parent);
      super.new (name, parent);
   endfunction
endclass

//----------------- spi_driver-----------------------------------

class spi_driver #(type T=eth_packet) extends base_driver #(T); 
   `uvm_component_utils (spi_driver #(T))

   function new (string name, uvm_component parent);
      super.new (name, parent);
   endfunction
endclass 