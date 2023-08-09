/**
Create transaction class extending uvm_sequence_item for the RTL module 
mentioned in the Instruction tab also print the value of the data members 
inside the class after randomization.

module counter
(
    input [3:0] mode,
    input rst,
    input clk,
    input [15:0] loaddata,
    input loadin,
    output [15 : 0] dout
);
endmodule

output
TRANS: (transaction@357) { mode: 'h5  rst: 'h1  clk: 'h1  loaddata: 'h2584  loadin: 'h1  dout: 'h0  }

*/

`include "uvm_macros.svh"
import uvm_pkg::*;

module counter
(
    input [3:0] mode,
    input rst,
    input clk,
    input [15:0] loaddata,
    input loadin,
    output [15 : 0] dout
);
endmodule

class transaction extends uvm_sequence_item;
    //`uvm_object_utils(transaction)

    rand bit [3:0] mode;
    rand bit rst;
    rand bit clk;
    rand bit [15:0] loaddata;
    rand bit loadin;
    bit [15:0] dout;        // output has no rand as it is generated from DUT

    function new(string name="TRANS");
        super.new(name);
    endfunction

    `uvm_object_utils_begin(transaction)
    `uvm_field_int(mode, UVM_DEFAULT)
    `uvm_field_int(rst, UVM_DEFAULT)
    `uvm_field_int(clk, UVM_DEFAULT)
    `uvm_field_int(loaddata, UVM_DEFAULT)
    `uvm_field_int(loadin, UVM_DEFAULT)
    `uvm_field_int(dout, UVM_DEFAULT)
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