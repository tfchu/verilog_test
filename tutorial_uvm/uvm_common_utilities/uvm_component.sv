/**
[Udemy Writing UVM testbenches for Newbie] 

summary
- show that uvm_component constructor has different signature compared to uvm_object (only name)

output
Instance name: Component
*/

`include "uvm_macros.svh"
import uvm_pkg::*;

class simple extends uvm_component;

    `uvm_component_utils(simple)    // register with factory

    string data;

    function new(string name, uvm_component c);
        super.new(name, c);
        data = name;        // "this" is not required as "data" has unique name
    endfunction

    task run();
        $display("Instance name: %0s", data);
    endtask

endclass

module tb;
    simple s;

    initial begin
        s = new("Component", null);
        s.run();
    end
endmodule