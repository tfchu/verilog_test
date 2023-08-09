/**
https://verificationguide.com/uvm/uvm-tlm-examples/

TLM Analysis Port Analysis Imp Port and Analysis FIFO
|__ TLM Analysis Port Analysis Imp port

*/

//------------------------------------------
// Including UVM Macros, Pkg and base_test
//------------------------------------------
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