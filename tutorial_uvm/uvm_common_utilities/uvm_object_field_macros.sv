/**
[Udemy Writing UVM testbenches for Newbie] 

summary
- use automation macro (`uvm_field_xx) to register class members with the factory

output
----------------------------------
Name     Type          Size  Value
----------------------------------
INST     simple        -     @336 
  a      integral      4     'h9  
  b      sa(integral)  4     -    
    [0]  integral      4     'hc  
    [1]  integral      4     'h7  
    [2]  integral      4     'h3  
    [3]  integral      4     'hc  
  inst   string        4     INST 
----------------------------------
*/

`include "uvm_macros.svh"
import uvm_pkg::*;

class simple extends uvm_object;

    rand bit [3:0] a;       // scalar
    rand bit [3:0] b[4];    // scalar array
    string inst;            // string to hold class name

    // constructor, "input" to avoid Vivaldo warning but optional
    function new(input string inst = "INST");
        super.new(inst);
        this.inst = inst;
    endfunction

    `uvm_object_utils_begin(simple)
    `uvm_field_int(a, UVM_DEFAULT)
    `uvm_field_sarray_int(b, UVM_DEFAULT)
    `uvm_field_string(inst, UVM_DEFAULT)
    `uvm_object_utils_end
endclass

module tb;

    simple s;

    initial begin
        s = new("INST");    // this creates a static object, do not allow uvm factory to dynamically configure
        s.randomize();
        s.print();          // use print from the factory
    end

endmodule