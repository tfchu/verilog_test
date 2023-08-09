/**
https://www.chipverify.com/uvm/tlm-get

TLM get port
- B (initiator) get() from A, A implements get

componentA
- declare m_get_imp (uvm_blocking_get_imp)
- implement get()
componentB
- declare m_get_port (uvm_blocking_get_port)
- call get() in run_phase

output
// case 1: simple get
UVM_INFO @ 0: reporter [RNTST] Running test my_test...
UVM_INFO /apps/vcsmx/vcs/S-2021.09//etc/uvm-1.2/src/base/uvm_root.svh(589) @ 0: reporter [UVMTOP] UVM testbench topology:
--------------------------------------------------
Name            Type                   Size  Value
--------------------------------------------------
uvm_test_top    my_test                -     @336 
  compA         componentA             -     @349 
    m_get_imp   uvm_blocking_get_imp   -     @367 
  compB         componentB             -     @358 
    m_get_port  uvm_blocking_get_port  -     @377 
--------------------------------------------------

UVM_INFO testbench.sv(42) @ 0: uvm_test_top.compA [COMPA] ComponentB has requested for a packet     // compA get() implementation
Packet: (Packet@397) { addr: 'hf4  data: 'h52  } 
UVM_INFO testbench.sv(68) @ 0: uvm_test_top.compB [COMPB] ComponentA just gave me the packet        // compB prints message after calling get()
Packet: (Packet@397) { addr: 'hf4  data: 'h52  } 
UVM_INFO testbench.sv(42) @ 0: uvm_test_top.compA [COMPA] ComponentB has requested for a packet     // next package, note time is always 0
Packet: (Packet@402) { addr: 'ha7  data: 'h63  } 
UVM_INFO testbench.sv(68) @ 0: uvm_test_top.compB [COMPB] ComponentA just gave me the packet
Packet: (Packet@402) { addr: 'ha7  data: 'h63  } 
UVM_INFO /apps/vcsmx/vcs/S-2021.09//etc/uvm-1.2/src/base/uvm_objection.svh(1276) @ 0: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
UVM_INFO /apps/vcsmx/vcs/S-2021.09//etc/uvm-1.2/src/base/uvm_report_server.svh(904) @ 0: reporter [UVM/REPORT/SERVER] 



// case 2: demo blocking behavior
UVM_INFO @ 0: reporter [RNTST] Running test my_test...
UVM_INFO /apps/vcsmx/vcs/S-2021.09//etc/uvm-1.2/src/base/uvm_root.svh(589) @ 0: reporter [UVMTOP] UVM testbench topology:
--------------------------------------------------
Name            Type                   Size  Value
--------------------------------------------------
uvm_test_top    my_test                -     @336 
  compA         componentA             -     @349 
    m_get_imp   uvm_blocking_get_imp   -     @367 
  compB         componentB             -     @358 
    m_get_port  uvm_blocking_get_port  -     @377 
--------------------------------------------------

UVM_INFO testbench.sv(44) @ 0: uvm_test_top.compA [COMPA] Preparing packet ...
UVM_INFO testbench.sv(46) @ 20: uvm_test_top.compA [COMPA] Preparing packet over ...            // compA spends 20 tu to prepare a packet
Packet: (Packet@397) { addr: 'hf4  data: 'h52  } 
UVM_INFO testbench.sv(72) @ 20: uvm_test_top.compB [COMPB] ComponentA just gave me the packet   // compB receives @ 20 tu
Packet: (Packet@397) { addr: 'hf4  data: 'h52  } 
UVM_INFO testbench.sv(44) @ 20: uvm_test_top.compA [COMPA] Preparing packet ...                 // compA prepares next packet @ 20 tu due to blocking
UVM_INFO testbench.sv(46) @ 40: uvm_test_top.compA [COMPA] Preparing packet over ...
Packet: (Packet@417) { addr: 'ha7  data: 'h63  } 
UVM_INFO testbench.sv(72) @ 40: uvm_test_top.compB [COMPB] ComponentA just gave me the packet
Packet: (Packet@417) { addr: 'ha7  data: 'h63  } 
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
    
    // Create an export to send data to componentB
    uvm_blocking_get_imp #(Packet, componentA) m_get_imp;
    Packet  pkt;
    
    function new (string name, uvm_component parent);
        super.new (name, parent);
    endfunction
    
    virtual function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        // Remember that m_get_imp is a class object and it will have to be 
        // created with new ()
        m_get_imp = new ("m_get_imp", this);
    endfunction
    
    // This task will output a new packet 
    virtual task get (output Packet pkt);
        // Create a new packet
        pkt = new();
        assert (pkt.randomize());
        // case 1: simple get
        // `uvm_info ("COMPA", "ComponentB has requested for a packet", UVM_LOW)
        // pkt.print (uvm_default_line_printer);

        // case 2: demo blocking behavior
        // Lets assume componentA takes some time to prepare packet
        `uvm_info("COMPA", "Preparing packet ...", UVM_LOW)
        #20;
        `uvm_info("COMPA", "Preparing packet over ...", UVM_LOW)
        pkt.print (uvm_default_line_printer);
    endtask
endclass

class componentB extends uvm_component;
    `uvm_component_utils (componentB)
    
    // Create a get_port to request for data from componentA
    uvm_blocking_get_port #(Packet) m_get_port;
    int m_num_tx = 2;
    
    function new (string name, uvm_component parent);
        super.new (name, parent);
    endfunction
    
    virtual function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        m_get_port = new ("m_get_port", this);
    endfunction
    
    virtual task run_phase (uvm_phase phase);
        Packet pkt;
        phase.raise_objection(this);
        repeat (m_num_tx) begin
            m_get_port.get (pkt);
            `uvm_info ("COMPB", "ComponentA just gave me the packet", UVM_LOW)
            pkt.print (uvm_default_line_printer);
        end
        phase.drop_objection(this);
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
    endfunction
    
    // Connection between componentA and componentB is done here
    virtual function void connect_phase (uvm_phase phase);
        compB.m_get_port.connect (compA.m_get_imp);  
    endfunction
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction
endclass

module top;
    initial begin
        run_test("my_test");
    end
endmodule