/**

*/

// DUT 
module addr(
    input [3:0] a,
    input [3:0] b,
    output [4:0] sum
);
  
endmodule

// testbench
`include "uvm_macros.svh"
 import uvm_pkg::*;

class transaction extends uvm_sequence_item;
  
    rand bit [3:0] a;
    rand bit [3:0] b;
    bit [4:0] sum;
    
    `uvm_object_utils_begin(transaction)
    `uvm_field_int(a,UVM_DEFAULT)
    `uvm_field_int(b,UVM_DEFAULT)
    `uvm_field_int(sum,UVM_DEFAULT)
    `uvm_object_utils_end
    
    function new(string name = "SEQ");
        super.new(name);
    endfunction
  
endclass