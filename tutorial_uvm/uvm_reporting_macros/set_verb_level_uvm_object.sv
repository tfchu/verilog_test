/**
[Udemy Writing UVM testbenches for Newbie] 

summary
- uvm_object does not have get/set_report_verbosity_level methods as they are provided in uvm_report_object
- so we use uvm_report_object instead, the rest is exactly the same as uvm_object

output
UVM_INFO testbench.sv(27) @ 0: reporter [INFO] Ver Level : 200
UVM_INFO testbench.sv(15) @ 0: DIS [DIS] Value of DIN : 55225

*/
`include "uvm_macros.svh"
import uvm_pkg::*;

class dis extends uvm_report_object;
    rand bit [15:0] din;
    
    `uvm_object_utils_begin(dis)
    `uvm_field_int(din, UVM_DEFAULT);
    `uvm_object_utils_end
    
    function new(string name = "DIS");
        super.new(name);
    endfunction
                
    task run();
        `uvm_info("DIS", $sformatf("Value of DIN : %0d",din),UVM_NONE);
    endtask
               
endclass
               
module tb;
    dis d1;
    integer level;
    
    initial begin
        d1 = new("DIS");
        level = d1.get_report_verbosity_level;
        `uvm_info("INFO",$sformatf("Ver Level : %0d",level),UVM_NONE);
        d1.randomize;
        d1.run;
    end
endmodule