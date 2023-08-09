/**
https://verificationguide.com/uvm/uvm-tlm-examples/

TLM Analysis Port Analysis Imp Port and Analysis FIFO
|__ TLM Analysis Port with multi analysis imp port

Output
UVM_INFO @ 0: reporter [RNTST] Running test basic_test...
----------------------------------------------------------
Name                  Type                     Size  Value
----------------------------------------------------------
uvm_test_top          basic_test               -     @1814
  env                 environment              -     @1881
    comp_a            component_a              -     @1913
      analysis_port   uvm_analysis_port        -     @1964
    comp_b            component_b              -     @1997
      analysis_imp_a  uvm_analysis_imp_port_a  -     @2047
      analysis_imp_b  uvm_analysis_imp_port_b  -     @2097
----------------------------------------------------------
UVM_INFO component_a.sv(29) @ 0: uvm_test_top.env.comp_a [component_a]  tranaction randomized
UVM_INFO component_a.sv(30) @ 0: uvm_test_top.env.comp_a [component_a]  Printing trans, 
 ---------------------------------
Name     Type         Size  Value
---------------------------------
trans    transaction  -     @2146
  addr   integral     4     'h3  
  wr_rd  integral     1     'h0  
  wdata  integral     8     'h33 
---------------------------------

UVM_INFO component_a.sv(32) @ 0: uvm_test_top.env.comp_a [component_a]  Before calling port write method
UVM_INFO component_b.sv(29) @ 0: uvm_test_top.env.comp_b [component_b]  Inside write_port_a method. Recived trans On Analysis Imp Port
UVM_INFO component_b.sv(30) @ 0: uvm_test_top.env.comp_b [component_b]  Printing trans, 
 ---------------------------------
Name     Type         Size  Value
---------------------------------
trans    transaction  -     @2146
  addr   integral     4     'h3  
  wr_rd  integral     1     'h0  
  wdata  integral     8     'h33 
---------------------------------

UVM_INFO component_b.sv(37) @ 0: uvm_test_top.env.comp_b [component_b]  Inside write_port_b method. Recived trans On Analysis Imp Port
UVM_INFO component_b.sv(38) @ 0: uvm_test_top.env.comp_b [component_b]  Printing trans, 
 ---------------------------------
Name     Type         Size  Value
---------------------------------
trans    transaction  -     @2146
  addr   integral     4     'h3  
  wr_rd  integral     1     'h0  
  wdata  integral     8     'h33 
---------------------------------

UVM_INFO component_a.sv(34) @ 0: uvm_test_top.env.comp_a [component_a]  After  calling port write method
UVM_INFO /xcelium20.09/tools//methodology/UVM/CDNS-1.2/sv/src/base/uvm_objection.svh(1271) @ 0: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
UVM_INFO /xcelium20.09/tools//methodology/UVM/CDNS-1.2/sv/src/base/uvm_report_server.svh(847) @ 0: reporter [UVM/REPORT/SERVER] 

*/

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "basic_test.sv"

module tlm_tb;

  //---------------------------------------
  // Calling TestCase
  //---------------------------------------
  initial begin
    run_test("basic_test");  
  end  
  
endmodule