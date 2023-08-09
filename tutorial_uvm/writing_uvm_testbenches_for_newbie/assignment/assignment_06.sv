/**
Create a class extending UVM_OBJECT consisting of a method to print 
the string "DOUBLE SUCCESS" using UVM_INFO utility with verbosity (UVM_DEBUG).

note
- since get/set_report_verbosity_level is from uvm_report_object (which extends uvm_object), we use that to set verbosity level

output
UVM_INFO testbench.sv(29) @ 0: reporter [INFO] Ver Level : 200
UVM_INFO testbench.sv(18) @ 0: DIS [DEBUG] Value of str : DOUBLE SUCCESS

*/

`include "uvm_macros.svh"
import uvm_pkg::*;

class dis extends uvm_report_object;
    string str = "DOUBLE SUCCESS";
  
    `uvm_object_utils_begin(dis)
    `uvm_field_string(str, UVM_DEFAULT);
    `uvm_object_utils_end
  
    function new(string name = "DIS");
        super.new(name);
    endfunction
               
    task run();
        `uvm_info("DEBUG", $sformatf("Value of str : %0s", str),UVM_DEBUG);
    endtask  
endclass
               
module tb;
    dis d1;
    integer level;
    
    initial begin
        d1 = new("DIS");
        level = d1.get_report_verbosity_level;
        `uvm_info("INFO",$sformatf("Ver Level : %0d", level), UVM_NONE);
        d1.set_report_verbosity_level(UVM_DEBUG);
        d1.run;
    end
endmodule