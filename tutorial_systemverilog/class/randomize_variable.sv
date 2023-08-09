/**
[Udemy Writing UVM testbenches for Newbie] 
assignment
    randomize the input variables of the module below and print its values in decimal
    module mul
        (
        input [15:0] a,
        input [15:0] b,
        input ctrl,
        output [31:0] y
        );
    endmodule

 the following code is wrong, need to correct
 
idea
- define a class with rand variables
- instantiate the module and connect with the class variables
- randomize the class
- print the module variables 
*/

import uvm_pkg::*;
`include "uvm_macros.svh"

module mul
    (
    input [15:0] a,
    input [15:0] b,
    input ctrl,
    output [31:0] y
    );

endmodule

class rand_stim extends uvm_test; 
    `uvm_component_utils(rand_stim)

    rand bit [15:0] a;
    rand bit [15:0] b;
    rand bit [15:0] ctrl;

    function new(input string name="rand_stim", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    `uvm_object_utils_begin(rand_stim)
    `uvm_field_int(a, UVM_DEFAULT)
    `uvm_field_int(b, UVM_DEFAULT)
    `uvm_field_int(ctrl, UVM_DEFAULT)
    `uvm_object_utils_end
endclass

module test;
    initial begin
        randomizer r = new("rand", null);
        mul m (.a(r.a), b(r.b), ctrl(r.ctrl));

        r.randomize();
        r.print();
        
    end
endmodule


module mul
    (
    input [15:0] a,
    input [15:0] b,
    input ctrl,
    output [31:0] y
    );

    rand_stim rs; 
    assign a = rs.a;
    assign b = rs.b;
    assign ctrl = rs.ctrl;

    initial begin
        rs = new("rand_stim", null);
        rs.randomize();
        rs.print();

        $display("%0d, %0d, %0d", a, b, ctrl);
    end

endmodule