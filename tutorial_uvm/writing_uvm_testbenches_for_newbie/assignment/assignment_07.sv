/**
Create transaction class extending uvm_sequence_item for the RTL module 
mentioned in the Instruction tab also print the value of the data members 
inside the class after randomization.

module dff
(
    input [3:0] mode,
    input rst,
    input clk,
    input din,
    output dout,
    output dbar
);
endmodule

output
- if not defining field macro
TRANS: (transaction@357) @357

- if defining field macro
TRANS: (transaction@357) { mode: 'h5  rst: 'h1  clk: 'h1  din: 'h0  dout: 'h0  dbar: 'h0  } 

note
- `uvm_object_utils and `uvm_field_xxx are either or, use only 1 of these macros to register with factory (NOT both)
*/

`include "uvm_macros.svh"
import uvm_pkg::*;

module dff
(
    input [3:0] mode,
    input rst,
    input clk,
    input din,
    output dout,
    output dbar
);
endmodule

class transaction extends uvm_sequence_item;
    //`uvm_object_utils(transaction)

    rand bit [3:0] mode;
    rand bit rst;
    rand bit clk;
    rand bit din;
    bit dout;           // output has no rand as it is generated from DUT
    bit dbar;

    function new(string name="TRANS");
        super.new(name);
    endfunction

    `uvm_object_utils_begin(transaction)
    `uvm_field_int(mode, UVM_DEFAULT)
    `uvm_field_int(rst, UVM_DEFAULT)
    `uvm_field_int(clk, UVM_DEFAULT)
    `uvm_field_int(din, UVM_DEFAULT)
    `uvm_field_int(dout, UVM_DEFAULT)
    `uvm_field_int(dbar, UVM_DEFAULT)
    `uvm_object_utils_end

endclass

class test extends uvm_test;
    `uvm_component_utils(test)
    
    function new(string name = "TEST", uvm_component p = null);
        super.new(name, p);
    endfunction
    
    virtual task run();
        transaction trans = new();
        trans.randomize();
        trans.print(uvm_default_line_printer);  // print() from uvm_object
    endtask
endclass  

module tb;
    test t;
    
    initial begin
        t = new();
        run_test();
    end
endmodule