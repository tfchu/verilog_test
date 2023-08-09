/**
Create class extending uvm_object base class consisting of three data members 
(reg [3:0] a, reg [7:0] b, reg [15:0] c). Use the Random number facility of 
SV to generate a random number for b and c. Finally, print the value of all the 
data members on the Console.

note 
- if constructor argument has no default value, compile will fail (not enough arguments)
- class members need "rand" to randomize()

output
------------------------------
Name    Type      Size  Value 
------------------------------
Simple  simple    -     @336  
  a     integral  4     'h9   
  b     integral  8     'h6c  
  c     integral  16    'hf8a7
------------------------------
*/
`include "uvm_macros.svh"
import uvm_pkg::*;

class simple extends uvm_object;
    rand reg [3:0] a;
    rand reg [7:0] b;
    rand reg [15:0] c;

    function new(string inst="INST");
        super.new(inst);
    endfunction

    `uvm_object_utils_begin(simple)
    `uvm_field_int(a, UVM_DEFAULT)
    `uvm_field_int(b, UVM_DEFAULT)
    `uvm_field_int(c, UVM_DEFAULT)
    `uvm_object_utils_end

endclass

module tb;
    simple s;

    initial begin
        s = new("Simple");
        s.randomize();
        s.print();
    end
endmodule