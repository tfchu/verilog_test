/**
https://www.chipverify.com/uvm/uvm-tlm-nonblocking-get-port

TLM nonblocking get port

output
// case 1: try_get
UVM_INFO @ 0: reporter [RNTST] Running test my_test...
UVM_INFO /apps/vcsmx/vcs/S-2021.09//etc/uvm-1.2/src/base/uvm_root.svh(589) @ 0: reporter [UVMTOP] UVM testbench topology:
-----------------------------------------------------
Name            Type                      Size  Value
-----------------------------------------------------
uvm_test_top    my_test                   -     @336 
  compA         componentA                -     @349 
    m_get_imp   uvm_nonblocking_get_imp   -     @367 
  compB         componentB                -     @358 
    m_get_port  uvm_nonblocking_get_port  -     @377 
-----------------------------------------------------

UVM_INFO testbench.sv(76) @ 0: uvm_test_top.compA [COMPA] ComponentB has requested for a packet
Packet: (Packet@397) { addr: 'hf4  data: 'h52  } 
UVM_INFO testbench.sv(42) @ 0: uvm_test_top.compB [COMPB] ComponentA just gave me the packet
Packet: (Packet@397) { addr: 'hf4  data: 'h52  } 
UVM_INFO testbench.sv(76) @ 0: uvm_test_top.compA [COMPA] ComponentB has requested for a packet
Packet: (Packet@402) { addr: 'ha7  data: 'h63  } 
UVM_INFO testbench.sv(42) @ 0: uvm_test_top.compB [COMPB] ComponentA just gave me the packet
Packet: (Packet@402) { addr: 'ha7  data: 'h63  } 


// case 2: can_get
UVM_INFO @ 0: reporter [RNTST] Running test my_test...
UVM_INFO /apps/vcsmx/vcs/S-2021.09//etc/uvm-1.2/src/base/uvm_root.svh(589) @ 0: reporter [UVMTOP] UVM testbench topology:
-----------------------------------------------------
Name            Type                      Size  Value
-----------------------------------------------------
uvm_test_top    my_test                   -     @336 
  compA         componentA                -     @349 
    m_get_imp   uvm_nonblocking_get_imp   -     @367 
  compB         componentB                -     @358 
    m_get_port  uvm_nonblocking_get_port  -     @377 
-----------------------------------------------------

UVM_INFO testbench.sv(44) @ 10: uvm_test_top.compB [COMPB] See if can_get() is ready
UVM_INFO testbench.sv(44) @ 20: uvm_test_top.compB [COMPB] See if can_get() is ready
UVM_INFO testbench.sv(44) @ 30: uvm_test_top.compB [COMPB] See if can_get() is ready
UVM_INFO testbench.sv(46) @ 30: uvm_test_top.compB [COMPB] COMPA ready, get packet now
UVM_INFO testbench.sv(71) @ 30: uvm_test_top.compA [COMPA] ComponentB has requested for a packet
Packet: (Packet@418) { addr: 'h6f  data: 'he9  } 
Packet: (Packet@418) { addr: 'h6f  data: 'he9  } 
UVM_INFO testbench.sv(46) @ 30: uvm_test_top.compB [COMPB] COMPA ready, get packet now
UVM_INFO testbench.sv(71) @ 30: uvm_test_top.compA [COMPA] ComponentB has requested for a packet
Packet: (Packet@423) { addr: 'hf4  data: 'h11  } 
Packet: (Packet@423) { addr: 'hf4  data: 'h11  } 


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

class componentB extends uvm_component;
    `uvm_component_utils (componentB)
    
    // Create a get_port to request for data from componentA
    uvm_nonblocking_get_port #(Packet) m_get_port;
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
        
        // Try to get a transaction which does not consume simulation time
        // as try_get() is a function
        repeat (m_num_tx) begin
            // case 1: try_get
            if (m_get_port.try_get(pkt))
                `uvm_info ("COMPB", "ComponentA just gave me the packet", UVM_LOW)
            else
                `uvm_info ("COMPB", "ComponentA did not give packet", UVM_LOW)
                pkt.print (uvm_default_line_printer);

            // case 2: can_get
            // while (!m_get_port.can_get()) begin
            //     #10 `uvm_info("COMPB", $sformatf("See if can_get() is ready"), UVM_LOW)
            // end
            // `uvm_info("COMPB", $sformatf("COMPA ready, get packet now"), UVM_LOW)
            // m_get_port.try_get(pkt);
            // pkt.print (uvm_default_line_printer);
        end
        phase.drop_objection(this);
    endtask
endclass

class componentA extends uvm_component;
    `uvm_component_utils (componentA)
    
    uvm_nonblocking_get_imp #(Packet, componentA) m_get_imp;
    
    function new (string name, uvm_component parent);
        super.new (name, parent);
    endfunction
    
    virtual function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        m_get_imp = new ("m_get_imp", this);
    endfunction
    
    virtual function bit try_get (output Packet pkt);
        pkt = new();
        assert (pkt.randomize());
        `uvm_info ("COMPA", "ComponentB has requested for a packet", UVM_LOW)
        pkt.print (uvm_default_line_printer);
        return 1;
    endfunction
    
    virtual function bit can_get();
        // case 2: can_get()
        // bit ready;
        // std::randomize(ready) with { ready dist {0:/70, 1:/30}; };
        // return ready;
    endfunction
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