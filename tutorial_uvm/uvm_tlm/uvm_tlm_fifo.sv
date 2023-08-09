/**
https://www.chipverify.com/uvm/uvm-tlm-fifo

output
UVM_INFO @ 0: reporter [RNTST] Running test my_test...
UVM_INFO testbench.sv(44) @ 50: uvm_test_top.compA [COMPA] Packet sent to CompB                 # compA put() after 50tu, +1 (FIFO 1)
pkt: (Packet@444) { addr: 'h85  data: 'hf1  } 
UVM_INFO testbench.sv(76) @ 100: uvm_test_top.compB [COMPB] ComponentA just gave me the packet  # compB get() after 100tu, -1 (FIFO 0)
pkt: (Packet@444) { addr: 'h85  data: 'hf1  } 
UVM_INFO testbench.sv(44) @ 100: uvm_test_top.compA [COMPA] Packet sent to CompB                # compA put() after 50tu, +1 (FIFO 1)
pkt: (Packet@460) { addr: 'h72  data: 'hf4  } 
UVM_INFO testbench.sv(44) @ 150: uvm_test_top.compA [COMPA] Packet sent to CompB                # compA put() after 50tu, +1 (FIFO 2)
pkt: (Packet@465) { addr: 'hf0  data: 'h9d  } 
UVM_INFO testbench.sv(122) @ 150: uvm_test_top [UVM_TLM_FIFO] Fifo is now FULL !                # FIFO full (depth = 2), check every #10
UVM_INFO testbench.sv(122) @ 160: uvm_test_top [UVM_TLM_FIFO] Fifo is now FULL !                # FIFO full (depth = 2), check every #10
UVM_INFO testbench.sv(122) @ 170: uvm_test_top [UVM_TLM_FIFO] Fifo is now FULL !                # ...
UVM_INFO testbench.sv(122) @ 180: uvm_test_top [UVM_TLM_FIFO] Fifo is now FULL !
UVM_INFO testbench.sv(122) @ 190: uvm_test_top [UVM_TLM_FIFO] Fifo is now FULL !
UVM_INFO testbench.sv(76) @ 200: uvm_test_top.compB [COMPB] ComponentA just gave me the packet  # compB get() after 100tu, -1 (FIFO 1)
pkt: (Packet@460) { addr: 'h72  data: 'hf4  } 
UVM_INFO testbench.sv(44) @ 200: uvm_test_top.compA [COMPA] Packet sent to CompB                # compA put() after 50tu, +1 (FIFO 2)
pkt: (Packet@468) { addr: 'h54  data: 'h5c  } 
UVM_INFO testbench.sv(122) @ 200: uvm_test_top [UVM_TLM_FIFO] Fifo is now FULL !                # FIFO full (depth = 2), check every #10
UVM_INFO testbench.sv(122) @ 210: uvm_test_top [UVM_TLM_FIFO] Fifo is now FULL !                # ...
UVM_INFO testbench.sv(122) @ 220: uvm_test_top [UVM_TLM_FIFO] Fifo is now FULL !
UVM_INFO testbench.sv(122) @ 230: uvm_test_top [UVM_TLM_FIFO] Fifo is now FULL !
UVM_INFO testbench.sv(122) @ 240: uvm_test_top [UVM_TLM_FIFO] Fifo is now FULL !
UVM_INFO testbench.sv(44) @ 250: uvm_test_top.compA [COMPA] Packet sent to CompB                # compA put() after 50tu, +1 (FIFO 3), this does not drop!!!
pkt: (Packet@483) { addr: 'haf  data: 'he7  } 
UVM_INFO testbench.sv(122) @ 250: uvm_test_top [UVM_TLM_FIFO] Fifo is now FULL !                # FIFO full (depth = 2), check every #10
UVM_INFO testbench.sv(122) @ 260: uvm_test_top [UVM_TLM_FIFO] Fifo is now FULL !                # ...
UVM_INFO testbench.sv(122) @ 270: uvm_test_top [UVM_TLM_FIFO] Fifo is now FULL !
UVM_INFO testbench.sv(122) @ 280: uvm_test_top [UVM_TLM_FIFO] Fifo is now FULL !
UVM_INFO testbench.sv(122) @ 290: uvm_test_top [UVM_TLM_FIFO] Fifo is now FULL !
UVM_INFO testbench.sv(76) @ 300: uvm_test_top.compB [COMPB] ComponentA just gave me the packet  # compB get() after 100tu, -1 (FIFO 2)
pkt: (Packet@465) { addr: 'hf0  data: 'h9d  } 
UVM_INFO testbench.sv(122) @ 300: uvm_test_top [UVM_TLM_FIFO] Fifo is now FULL !                # FIFO full (depth = 2), check every #10
UVM_INFO testbench.sv(122) @ 310: uvm_test_top [UVM_TLM_FIFO] Fifo is now FULL !                # ...
UVM_INFO testbench.sv(122) @ 320: uvm_test_top [UVM_TLM_FIFO] Fifo is now FULL !
UVM_INFO testbench.sv(122) @ 330: uvm_test_top [UVM_TLM_FIFO] Fifo is now FULL !
UVM_INFO testbench.sv(122) @ 340: uvm_test_top [UVM_TLM_FIFO] Fifo is now FULL !
UVM_INFO testbench.sv(122) @ 350: uvm_test_top [UVM_TLM_FIFO] Fifo is now FULL !
UVM_INFO testbench.sv(122) @ 360: uvm_test_top [UVM_TLM_FIFO] Fifo is now FULL !
UVM_INFO testbench.sv(122) @ 370: uvm_test_top [UVM_TLM_FIFO] Fifo is now FULL !
UVM_INFO testbench.sv(122) @ 380: uvm_test_top [UVM_TLM_FIFO] Fifo is now FULL !
UVM_INFO testbench.sv(122) @ 390: uvm_test_top [UVM_TLM_FIFO] Fifo is now FULL !
UVM_INFO testbench.sv(76) @ 400: uvm_test_top.compB [COMPB] ComponentA just gave me the packet  # compB get() after 100tu, -1 (FIFO 1)
pkt: (Packet@468) { addr: 'h54  data: 'h5c  } 
UVM_INFO testbench.sv(76) @ 500: uvm_test_top.compB [COMPB] ComponentA just gave me the packet  # compB get() after 100tu, -1 (FIFO 0)
pkt: (Packet@483) { addr: 'haf  data: 'he7  } 
 */

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
    
    // Create a blocking TLM put port which can send an object
    // of type 'Packet'
    uvm_blocking_put_port #(Packet) m_put_port;
    int m_num_tx = 2;
    
    function new (string name = "componentA", uvm_component parent= null);
        super.new (name, parent);
    endfunction
    
    // Remember that TLM put_port is a class object and it will have to be 
    // created with new ()
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
            #50;
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
            #100;
            m_get_port.get (pkt);
            `uvm_info ("COMPB", "ComponentA just gave me the packet", UVM_LOW)
            pkt.print (uvm_default_line_printer);
        end
        phase.drop_objection(this);
    endtask
endclass

class my_test extends uvm_env;
    `uvm_component_utils (my_test)
    
    componentA compA;
    componentB compB;
    
    int m_num_tx;
    
    // Create the UVM TLM Fifo that can accept simple_packet
    uvm_tlm_fifo #(Packet)    m_tlm_fifo;
    
    function new (string name = "my_test", uvm_component parent = null);
        super.new (name, parent);
    endfunction
    
    virtual function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        // Create an object of both components
        compA = componentA::type_id::create ("compA", this);
        compB = componentB::type_id::create ("compB", this);
        std::randomize(m_num_tx) with { m_num_tx inside {[4:10]}; };
        compA.m_num_tx = m_num_tx;
        compB.m_num_tx = m_num_tx;
    
        // Create a FIFO with depth 2
        m_tlm_fifo = new ("uvm_tlm_fifo", this, 2);
    endfunction
    
    // Connect the ports to the export of FIFO.
    virtual function void connect_phase (uvm_phase phase);
        compA.m_put_port.connect(m_tlm_fifo.put_export);
        compB.m_get_port.connect(m_tlm_fifo.get_export);
    endfunction
    
    // Display a message when the FIFO is full
    virtual task run_phase (uvm_phase phase);
        forever begin
            #10;
            if (m_tlm_fifo.is_full ())
                `uvm_info ("UVM_TLM_FIFO", "Fifo is now FULL !", UVM_MEDIUM)          
        end
    endtask
endclass

module top;
    initial begin
        run_test("my_test");
    end
endmodule