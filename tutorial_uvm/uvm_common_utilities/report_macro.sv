/** 
source: [Udemy Writing UVM testbenches for Newbie]

output
UVM_INFO testbench.sv(19) @ 0: display [DISPLAY] This is a table 
 +--------------------------------------------------------------------
 +Name               Type                                  Size  Value
 +--------------------------------------------------------------------
 +element_container  uvm_report_message_element_container  -     @346 
 +  a                integral                              16    46873
 +--------------------------------------------------------------------
 +
*/
`include "uvm_macros.svh"
import uvm_pkg::*;

class display extends uvm_test; // uvm_component
    `uvm_component_utils(display)

    rand bit [15:0] a;

    // name: of the class
    // p: the class' parent, null if this class is the top component
    function new(input string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run();
        `uvm_info_begin("DISPLAY", "This is a table ", UVM_NONE)
        `uvm_message_add_int(a, UVM_DEC)
        `uvm_info_end
    endtask

endclass

module tb;
    display d1;

    initial begin
        d1 = new("display", null);
        d1.randomize();
        d1.run();
    end

endmodule