/**

use // override by type/name

#### Factory Configuration (*)								// from factory.print();

No instance overrides are registered with this factory

Type Overrides:

  Requested Type  Override Type
  --------------  -------------
  base_agent      child_agent

All types registered with the factory: 56 total
  Type Name
  ---------
  base_agent
  base_env
  base_test
  child_agent
  snps_uvm_reg_bank_group
  snps_uvm_reg_map
(*) Types with no associated type name will be printed as <unknown>

####


UVM_INFO env.sv(36) @ 0: uvm_test_top.m_env [AGENT] Factory returned agent of type=child_agent, path=uvm_test_top.m_env.m_agent
UVM_INFO testbench.sv(38) @ 0: uvm_test_top [base_test] Printing the test topology :				// from this.sprint(printer)
--------------------------------------
Name          Type         Size  Value
--------------------------------------
uvm_test_top  base_test    -     @336 
  m_env       base_env     -     @351 
    m_agent   child_agent  -     @360 
--------------------------------------

UVM_INFO /apps/vcsmx/vcs/Q-2020.03-SP1-1//etc/uvm-1.2/src/base/uvm_report_server.svh(894) @ 0: reporter [UVM/REPORT/SERVER] 
*/

module tb;
    import uvm_pkg::*;
    
    initial begin
        run_test("base_test");
    end
endmodule