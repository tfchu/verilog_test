/**
Create a class extending UVM_COMPONENT consisting of a method to print the string "SUCCESS" 
using UVM_INFO utility with verbosity (UVM_DEBUG).

note
- using function void run(); causes compiling issue, possibly attemping to existing run() function of parent classes

output
UVM_INFO testbench.sv(17) @ 0: Inst [simple] s: SUCCESS

*/
`include "uvm_macros.svh"
import uvm_pkg::*;

class simple extends uvm_component;

    `uvm_component_utils(simple)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    string s = "SUCCESS";

    task run();
        `uvm_info("simple", $sformatf("s: %0s", s), UVM_DEBUG)
    endtask

endclass

module tb;

    simple s;

    initial begin
        s = new("Inst", null);
        s.set_report_verbosity_level(UVM_DEBUG);
        s.run();
    end

endmodule