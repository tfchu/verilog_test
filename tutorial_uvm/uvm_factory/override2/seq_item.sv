//------------------ eth_packet-----------------------------------
class eth_packet extends uvm_sequence_item;
   `uvm_object_utils (eth_packet)

   function new (string name = "eth_packet");
      super.new (name);
      `uvm_info (get_type_name(), "Packet created", UVM_MEDIUM)
   endfunction
endclass   

//------------------ eth_v2_packet-----------------------------------
class eth_v2_packet extends eth_packet; 
   `uvm_object_utils (eth_v2_packet)
   
   function new (string name = "eth_v2_packet");
      super.new (name);
   endfunction
endclass  