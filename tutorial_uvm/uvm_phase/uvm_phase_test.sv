/**
test how UVM phases work under inheritance
reuse tutorial_uvm/eda_playground_hello_world/
simply expand the test class
also added enter/exit for other components besides test

run test on "grand_child_test", and all phases in parent classes automatically run

UVM_INFO @ 0: reporter [RNTST] Running test grand_child_test...
UVM_WARNING my_testbench_pkg.svh(117) @ 0: uvm_test_top [] enter child build_phase
UVM_WARNING my_testbench_pkg.svh(90) @ 0: uvm_test_top [] enter parent build_phase
UVM_WARNING my_testbench_pkg.svh(92) @ 0: uvm_test_top [] exit parent build_phase
UVM_WARNING my_testbench_pkg.svh(119) @ 0: uvm_test_top [] exit child build_phase
UVM_WARNING my_testbench_pkg.svh(73) @ 0: uvm_test_top.env [] enter my_env build_phase
UVM_WARNING my_testbench_pkg.svh(75) @ 0: uvm_test_top.env [] exit my_env build_phase
UVM_WARNING my_testbench_pkg.svh(29) @ 0: uvm_test_top.env.agent [] enter my_agent build_phase
UVM_WARNING my_testbench_pkg.svh(33) @ 0: uvm_test_top.env.agent [] exit my_agent build_phase
UVM_WARNING my_testbench_pkg.svh(39) @ 0: uvm_test_top.env.agent [] enter my_agent connect_phase
UVM_WARNING my_testbench_pkg.svh(41) @ 0: uvm_test_top.env.agent [] exit my_agent connect_phase
UVM_WARNING my_testbench_pkg.svh(96) @ 0: uvm_test_top [] enter parent connect_phase
UVM_WARNING my_testbench_pkg.svh(97) @ 0: uvm_test_top [] exit parent connect_phase
UVM_WARNING my_testbench_pkg.svh(123) @ 0: uvm_test_top [] enter child end_of_elaboration_phase
UVM_WARNING my_testbench_pkg.svh(124) @ 0: uvm_test_top [] exit child end_of_elaboration_phase
UVM_WARNING my_testbench_pkg.svh(46) @ 0: uvm_test_top.env.agent [] enter my_agent run_phase
UVM_WARNING my_testbench_pkg.svh(128) @ 0: uvm_test_top [] enter child run_phase
UVM_WARNING my_testbench_pkg.svh(102) @ 0: uvm_test_top [] enter parent run_phase
UVM_WARNING my_testbench_pkg.svh(104) @ 10: uvm_test_top [] exit parent run_phase
UVM_INFO design.sv(21) @ 15: reporter [DUT] Received cmd=1, addr=0xd7, data=0x32
UVM_WARNING my_testbench_pkg.svh(132) @ 20: uvm_test_top [] exit child run_phase
UVM_INFO design.sv(21) @ 25: reporter [DUT] Received cmd=0, addr=0x69, data=0x75
UVM_INFO design.sv(21) @ 35: reporter [DUT] Received cmd=1, addr=0xeb, data=0x61
UVM_INFO design.sv(21) @ 45: reporter [DUT] Received cmd=1, addr=0xba, data=0xe6
UVM_INFO design.sv(21) @ 55: reporter [DUT] Received cmd=0, addr=0x6f, data=0x54
UVM_INFO design.sv(21) @ 65: reporter [DUT] Received cmd=1, addr=0xb8, data=0x6c
UVM_INFO design.sv(21) @ 75: reporter [DUT] Received cmd=0, addr=0xef, data=0x24
UVM_INFO design.sv(21) @ 85: reporter [DUT] Received cmd=0, addr=0xa1, data=0xcc
UVM_WARNING my_testbench_pkg.svh(56) @ 85: uvm_test_top.env.agent [] exit my_agent run_phase
*/

class my_test extends uvm_test;
    `uvm_component_utils(my_test)

    my_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        `uvm_warning("", "enter parent build_phase")
        env = my_env::type_id::create("env", this);       // create the environment
        `uvm_warning("", "exit parent build_phase")
    endfunction

    function void connect_phase(uvm_phase phase);
        `uvm_warning("", "enter parent connect_phase")
        `uvm_warning("", "exit parent connect_phase")
    endfunction

    // where simulation happens, here we simply print "Hello World!" @ 10 tu
    virtual task run_phase(uvm_phase phase);
        `uvm_warning("", "enter parent run_phase")
        #10;
        `uvm_warning("", "exit parent run_phase")
    endtask

endclass

class child_test extends my_test;
    `uvm_component_utils(child_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        `uvm_warning("", "enter child build_phase")
        super.build_phase(phase);
        `uvm_warning("", "exit child build_phase")
    endfunction
        
    function void end_of_elaboration_phase(uvm_phase phase);
        `uvm_warning("", "enter child end_of_elaboration_phase")
        `uvm_warning("", "exit child end_of_elaboration_phase")
    endfunction
    
    task run_phase(uvm_phase phase);
        `uvm_warning("", "enter child run_phase")
        super.run_phase(phase);
        #10;
        `uvm_warning("", "exit child run_phase")
    endtask
endclass
      
class grand_child_test extends child_test;
    `uvm_component_utils(grand_child_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass