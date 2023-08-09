/**
// component override method
#### Factory Configuration (*)

Instance Overrides:

  Requested Type  Override Path   Override Type
  --------------  --------------  -------------
  component_A     uvm_test_top.*  component_B

No type overrides are registered with this factory

All types registered with the factory: 55 total
  Type Name
  ---------
  component_A
  component_B
  my_test
  snps_uvm_reg_bank_group
  snps_uvm_reg_map
(*) Types with no associated type name will be printed as <unknown>

####


UVM_INFO /apps/vcsmx/vcs/Q-2020.03-SP1-1//etc/uvm-1.2/src/base/uvm_root.svh(675) @ 0: reporter [UVMTOP] UVM testbench topology:
--------------------------------------
Name          Type         Size  Value
--------------------------------------
uvm_test_top  my_test      -     @336 
  comp_A      component_B  -     @349 
--------------------------------------

UVM_INFO testbench.sv(26) @ 0: uvm_test_top.comp_A [component_B] inside component_B
UVM_INFO /apps/vcsmx/vcs/Q-2020.03-SP1-1//etc/uvm-1.2/src/base/uvm_report_server.svh(894) @ 0: reporter [UVM/REPORT/SERVER] 


// factory override method
  Requested Type  Override Path        Override Type
  --------------  -------------------  -------------
  component_A     uvm_test_top.comp_A  component_B

*/

`include "uvm_macros.svh"
import uvm_pkg::*;

class component_A extends uvm_component;
    `uvm_component_utils(component_A)

    function new(string name = "component_A", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function display();
        `uvm_info(get_type_name(), $sformatf("inside component_A"), UVM_LOW);
    endfunction
endclass

class component_B extends component_A;
    `uvm_component_utils(component_B)

    function new(string name = "component_B", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function display();
        `uvm_info(get_type_name(), "inside component_B", UVM_LOW);
    endfunction
endclass

class my_test extends uvm_test;
    `uvm_component_utils(my_test)
    component_A comp_A;

    function new(string name = "my_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        uvm_factory factory = uvm_factory::get();
        super.build_phase(phase);

        // component override method (static)
        set_inst_override_by_type("*", component_A::get_type(), component_B::get_type());

        // factory override method (non-static)
        //factory.set_inst_override_by_type(component_A::get_type(), component_B::get_type(), {get_full_name(), ".comp_A"})

        comp_A = component_A::type_id::create("comp_A", this);

        factory.print();
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        comp_A.display();
    endtask
endclass

module tb_top;
    initial begin
        run_test("my_test");
    end
endmodule