/**
UVM_INFO @ 0: reporter [RNTST] Running test my_test...
UVM_INFO /apps/vcsmx/vcs/Q-2020.03-SP1-1//etc/uvm-1.2/src/base/uvm_root.svh(675) @ 0: reporter [UVMTOP] UVM testbench topology:
--------------------------------------------------
Name            Type                   Size  Value
--------------------------------------------------
uvm_test_top    my_test                -     @336 
  compA         componentA             -     @349 
    m_put_port  uvm_blocking_put_port  -     @367 
  compB         componentB             -     @358 
    m_put_imp   uvm_blocking_put_imp   -     @377 
--------------------------------------------------

UVM_INFO @ 0: reporter [RNTST] Running test my_test...
UVM_INFO testbench.sv(48) @ 0: uvm_test_top.compA [COMPA] Packet sent to CompB
pkt: (Packet@395) { addr: 'h85  data: 'hf1  } 
UVM_INFO testbench.sv(75) @ 0: uvm_test_top.compB [COMPB] Packet received from CompA
pkt: (Packet@395) { addr: 'h85  data: 'hf1  } 
UVM_INFO testbench.sv(48) @ 0: uvm_test_top.compA [COMPA] Packet sent to CompB
pkt: (Packet@400) { addr: 'h72  data: 'hf4  } 
UVM_INFO testbench.sv(75) @ 0: uvm_test_top.compB [COMPB] Packet received from CompA
pkt: (Packet@400) { addr: 'h72  data: 'hf4  } 
UVM_INFO /apps/vcsmx/vcs/Q-2020.03-SP1-1//etc/uvm-1.2/src/base/uvm_objection.svh(1276) @ 0: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
UVM_INFO /apps/vcsmx/vcs/Q-2020.03-SP1-1//etc/uvm-1.2/src/base/uvm_report_server.svh(894) @ 0: reporter [UVM/REPORT/SERVER] 
// task put() no delay (above)


// task put() with #20 delay (below)
UVM_INFO testbench.sv(48) @ 0: uvm_test_top.compA [COMPA] Packet sent to CompB              // CompA sends the packet to CompB
pkt: (Packet@397) { addr: 'h85  data: 'hf1  } 
UVM_INFO testbench.sv(75) @ 0: uvm_test_top.compB [COMPB] Processing packet                 // at the same time, CompB receives the packet and processes it
UVM_INFO testbench.sv(77) @ 20: uvm_test_top.compB [COMPB] Processing packet finished.      // CompB spends 20 tu to process it
pkt: (Packet@397) { addr: 'h85  data: 'hf1  }                                               // CompB prints the packet
UVM_INFO testbench.sv(48) @ 20: uvm_test_top.compA [COMPA] Packet sent to CompB             // CompA sends next packet, now time @20 due to blocking put port
pkt: (Packet@417) { addr: 'h72  data: 'hf4  } 
UVM_INFO testbench.sv(75) @ 20: uvm_test_top.compB [COMPB] Processing packet
UVM_INFO testbench.sv(77) @ 40: uvm_test_top.compB [COMPB] Processing packet finished.
pkt: (Packet@417) { addr: 'h72  data: 'hf4  } 
UVM_INFO /apps/vcsmx/vcs/Q-2020.03-SP1-1//etc/uvm-1.2/src/base/uvm_objection.svh(1276) @ 40: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
UVM_INFO /apps/vcsmx/vcs/Q-2020.03-SP1-1//etc/uvm-1.2/src/base/uvm_report_server.svh(894) @ 40: reporter [UVM/REPORT/SERVER] 
*/

// Create a class data object that can be sent from one 
// component to another
class Packet extends uvm_object;
    rand bit[7:0] addr;
    rand bit[7:0] data;
    
    `uvm_object_utils_begin(Packet)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end
    
    function new(string name = "Packet");
        super.new(name);
    endfunction
endclass

class componentA extends uvm_component;
    `uvm_component_utils (componentA)
    
    // Create a blocking TLM put port which can send an object of type 'Packet'
    uvm_blocking_put_port #(Packet) m_put_port;
    int m_num_tx;
    
    function new (string name = "componentA", uvm_component parent= null);
        super.new (name, parent);
    endfunction

    // Remember that TLM put_port is a class object and it will have to be created with new ()
    virtual function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        m_put_port = new ("m_put_port", this);
    endfunction
    
    // Create a packet, randomize it and send it through the port
    // Note that put() is a method defined by the receiving component
    // Repeat these steps N times to send N packets
    virtual task run_phase (uvm_phase phase);
        phase.raise_objection(this);
        repeat (m_num_tx) begin
            Packet pkt = Packet::type_id::create ("pkt");
            assert(pkt.randomize ()); 
        
            // Print the packet to be displayed in log
            `uvm_info ("COMPA", "Packet sent to CompB", UVM_LOW)
            pkt.print (uvm_default_line_printer);
        
            // Call the TLM put() method of put_port class and pass packet as argument
            m_put_port.put (pkt);
        end
        phase.drop_objection(this);
    endtask   
endclass

class componentB extends uvm_component;
    `uvm_component_utils (componentB)
    
    // Declare a put implementation port to accept transactions
    uvm_blocking_put_imp #(Packet, componentB) m_put_imp;

    function new (string name = "componentB", uvm_component parent = null);
        super.new (name, parent);
    endfunction
    
    virtual function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        m_put_imp = new ("m_put_imp", this);
    endfunction
    

    // Implementation of the 'put()' method in this case simply prints it.
    // virtual task put (Packet pkt);
    //     `uvm_info ("COMPB", "Packet received from CompA", UVM_LOW)
    //     pkt.print(uvm_default_line_printer);
    // endtask

    // add a #20 delay to show blocking effect
    virtual task put (Packet pkt);
        `uvm_info ("COMPB", $sformatf("Processing packet"), UVM_LOW)
        #20;
        `uvm_info ("COMPB", $sformatf("Processing packet finished."), UVM_LOW)
        pkt.print(uvm_default_line_printer);
    endtask


endclass

class my_test extends uvm_test;
    `uvm_component_utils (my_test)
    
    componentA compA;
    componentB compB;
    
    function new (string name = "my_test", uvm_component parent = null);
        super.new (name, parent);
    endfunction
    
    // Create objects of both components, set number of transfers
    virtual function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        compA = componentA::type_id::create ("compA", this);
        compB = componentB::type_id::create ("compB", this);
        compA.m_num_tx = 2;
    endfunction
    
    virtual function void end_of_elaboration_phase (uvm_phase phase);
         // By now, the environment is all set up, just print the topology for debug
         uvm_top.print_topology ();
    endfunction

    // Connection between componentA and componentB is done here
    // Note that the "put_port" is connected to its implementation "put_imp"
    virtual function void connect_phase (uvm_phase phase);
        compA.m_put_port.connect (compB.m_put_imp);  
    endfunction
endclass

module top;
    initial begin
        run_test("my_test");
    end
endmodule