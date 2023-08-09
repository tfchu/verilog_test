/**

*/

// DUT
module bram(
 
  input [7:0] din,
  input [11:0] addr,
  input wr,
  input clk,
  input rst,
  output [7:0] dout
 
);

endmodule

// testbench
`include "uvm_macros.svh"
   import uvm_pkg::*;
 
class transaction extends uvm_sequence_item;
  
    rand bit[7:0] din;
    rand bit [11:0] addr;
    rand bit wr;
    rand bit clk;
    rand bit rst;
    bit [7:0] dout;
    
    `uvm_object_utils_begin(transaction)
    `uvm_field_int(din, UVM_DEFAULT)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_int(wr, UVM_DEFAULT)
    `uvm_field_int(clk, UVM_DEFAULT)
    `uvm_field_int(rst, UVM_DEFAULT)
    `uvm_field_int(dout, UVM_DEFAULT)
    `uvm_object_utils_end
    
    function new(string name = "SEQ");
        super.new(name);
    endfunction
    
endclass