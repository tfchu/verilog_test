/**
[Udemy Writing UVM testbenches for Newbie] 

summary
- demo using factory <class>::type_id::create(<constructor args>) to create new object

note
- 

output
UVM_INFO @ 0: reporter [RNTST] Running test ...
----------------------------------
Name     Type          Size  Value
----------------------------------
Inst     simple        -     @349 
  a      integral      4     'h0  
  b      sa(integral)  4     -    
    [0]  integral      4     'h5  
    [1]  integral      4     'h4  
    [2]  integral      4     'hb  
    [3]  integral      4     'h2  
  inst   string        4     Inst 
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

    // automation macros to register class members to the factory
    `uvm_object_utils_begin(simple)
    `uvm_field_int(a, UVM_DEFAULT)
    `uvm_field_sarray_int(b, UVM_DEFAULT)
    `uvm_field_string(inst, UVM_DEFAULT)
    `uvm_object_utils_end

endclass

class test extends uvm_test;

    `uvm_component_utils(test)

    /*
    uvm_test inherits uvm_component, need 2 arguments
    */
    function new(string name, uvm_component c);
        super.new(name, c);
    endfunction

    /*
    arg name has to be "phase" otherwise warning is shown
    type_id::create is the factory way to create an object
    */
    function void build_phase(uvm_phase phase);
        simple s = simple::type_id::create("Inst");
        s.randomize();
        s.print();
    endfunction

endclass

module tb;

    test t;

    initial begin
        // 3 ways to start the test
        // (1) instantiate the class that extends uvm_test, then run_test()
        t  = new("Test", null);
        run_test();     // start the test
        // (2) run_test(<test class name>)
        //run_test("test");
        // (3) specify uvm_test=test in command line options, then call run_test()
    end

endmodule