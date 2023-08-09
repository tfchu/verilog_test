// Declare a sequence_item for the APB transaction 
class bus_pkt extends uvm_sequence_item;
   rand bit [31:0]  addr;
   rand bit [31:0]  data;
   rand bit         write;

   `uvm_object_utils_begin (bus_pkt)
      `uvm_field_int (addr, UVM_ALL_ON)
      `uvm_field_int (data, UVM_ALL_ON)
      `uvm_field_int (write, UVM_ALL_ON)
   `uvm_object_utils_end

   function new (string name = "bus_pkt");
      super.new (name);
   endfunction
   
   constraint c_addr { addr inside {0, 4, 8};}
endclass