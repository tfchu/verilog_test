/**
[Udemy Writing UVM testbenches for Newbie] 

summary
- use uvm_component's set_report_verbosity_level() to change default `uvm_info verbosity level (UVM_MEDIUM) to UVM_HIGH
- so that UVM_HIGH also prints
- use uvm_component's get_report_verbosity_level() to get current verbosity level

note
- set/get_report_verbosity_level is provided in uvm_report_object class
- hierarchy
    uvm_object -> uvm_report_object -> uvm_component (so it get the methods)
- uvm_object, however, does not have these methods. use uvm_report_object instead! 
    - use uvm_report_object just like uvm_object, e.g. use automation macros like `uvm_field_xxx to register class members

output
UVM_INFO testbench.sv(27) @ 0: reporter [INFO] Verbosity level: 200
UVM_INFO testbench.sv(30) @ 0: reporter [INFO] Verbosity level: 300
UVM_INFO testbench.sv(16) @ 0: DIS [DIS] value of din : 28044

*/
`include "uvm_macros.svh"
import uvm_pkg::*;

// simply display something
class dis extends uvm_component;
    `uvm_component_utils(dis);
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    rand bit [15:0]din;

    task run();
        `uvm_info("DIS", $sformatf("value of din : %0d", din), UVM_HIGH)
    endtask
endclass

module tb;
    dis dl;
    integer level;

    initial begin
        dl = new("DIS", null);
        level = dl.get_report_verbosity_level();
        `uvm_info("INFO", $sformatf("Verbosity level: %0d", level), UVM_LOW)
        dl.set_report_verbosity_level(UVM_HIGH);
        level = dl.get_report_verbosity_level();
        `uvm_info("INFO", $sformatf("Verbosity level: %0d", level), UVM_LOW)
        dl.randomize;
        dl.run;
    end
endmodule