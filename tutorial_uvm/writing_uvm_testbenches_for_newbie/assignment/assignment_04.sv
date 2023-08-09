/**
Create a class by extending uvm_component consisting of the three data members 
(reg [3:0] a, reg [3:0] b and reg [4:0] c), create a method that takes two 
arguments from user to update data members (a and b). 
Update data member c with the result of addition of the a and b and print all data members.

output
a = 1, b = 2, c = 3

*/

`include "uvm_macros.svh"
import uvm_pkg::*;

class simple extends uvm_component;

    `uvm_component_utils(simple)    // register with factory

    reg [3:0] a;
    reg [3:0] b;
    reg [4:0] c;

    function new(string name, uvm_component c);
        super.new(name, c);
    endfunction

    function update_a_b(reg [3:0] a, reg [3:0] b);
        this.a = a;
        this.b = b;
    endfunction

    task run();
        this.c = a + b;
        $display("a = %0d, b = %0d, c = %0d", a, b, c);
    endtask

endclass

module tb;
    simple s;

    initial begin
        s = new("Component", null);
        s.update_a_b(1, 2);
        s.run();
    end
endmodule