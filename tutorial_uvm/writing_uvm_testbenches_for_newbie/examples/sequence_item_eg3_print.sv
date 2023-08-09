/**
summary
- use print() provided in uvm_object
- set 'uvm_default_line_printer' flag to print in 1 line

document
- https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.1c/html/files/base/uvm_object-svh.html

output
UVM_INFO @ 0: reporter [RNTST] Running test ...
TRANS: (transaction@357) { data: 'hd5  addr: 'h727  dout: 'h9  } 
UVM_INFO /apps/vcsmx/vcs/S-2021.09//etc/uvm-1.2/src/base/uvm_report_server.svh(904) @ 0: reporter [UVM/REPORT/SERVER] 

*/

`include "uvm_macros.svh"
import uvm_pkg::*;
 
// uvm_object -> uvm_sequence_item -> transaction
class transaction extends uvm_sequence_item;
    rand bit [7:0] data;
    rand bit [11:0] addr;
    rand bit [3:0] dout;
    
    `uvm_object_utils_begin(transaction)
    `uvm_field_int(data,UVM_DEFAULT)
    `uvm_field_int(addr,UVM_DEFAULT)
    `uvm_field_int(dout,UVM_DEFAULT)
    `uvm_object_utils_end
    
    function new(string name = "TRANS");
        super.new(name);
    endfunction
endclass
 
// uvm_component -> uvm_test
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
 
///////////////////////////////////////////////

module tb;
    test t;
    
    initial begin
        t = new();
        run_test();
    end
endmodule