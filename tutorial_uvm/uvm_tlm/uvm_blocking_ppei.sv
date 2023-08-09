/**
https://www.chipverify.com/uvm/uvm-tlm-port-export-imp

ppei: port - port - export -imp

subcompA (call put()) port -> compA port -> compB export -> subcompB imp (implement put())

note. like C, subCompB must be declared before componentB as componentB uses subCompB, so compilation is successful. 

output
UVM_INFO @ 0: reporter [RNTST] Running test my_test...
UVM_INFO /apps/vcsmx/vcs/S-2021.09//etc/uvm-1.2/src/base/uvm_root.svh(589) @ 0: reporter [UVMTOP] UVM testbench topology:
------------------------------------------------------
Name              Type                     Size  Value
------------------------------------------------------
uvm_test_top      my_test                  -     @336 
  compA           componentA               -     @349 
    m_put_port    uvm_blocking_put_port    -     @376 
    m_subcomp_A   subCompA                 -     @367 
      m_put_port  uvm_blocking_put_port    -     @386 
  compB           componentB               -     @358 
    m_put_export  uvm_blocking_put_export  -     @405 
    m_subcomp_B   subCompB                 -     @396 
      m_put_imp   uvm_blocking_put_imp     -     @415 
------------------------------------------------------

UVM_INFO testbench.sv(49) @ 0: uvm_test_top.compA.m_subcomp_A [SUBCOMPA] Packet sent to subCompB
pkt: (Packet@435) { addr: 'h7c  data: 'h39  } 
UVM_INFO testbench.sv(98) @ 0: uvm_test_top.compB.m_subcomp_B [SUBCOMPB] Packet received from subCompA
pkt: (Packet@435) { addr: 'h7c  data: 'h39  } 
UVM_INFO testbench.sv(49) @ 0: uvm_test_top.compA.m_subcomp_A [SUBCOMPA] Packet sent to subCompB
pkt: (Packet@440) { addr: 'hfd  data: 'h54  } 
UVM_INFO testbench.sv(98) @ 0: uvm_test_top.compB.m_subcomp_B [SUBCOMPB] Packet received from subCompA
pkt: (Packet@440) { addr: 'hfd  data: 'h54  } 
UVM_INFO /apps/vcsmx/vcs/S-2021.09//etc/uvm-1.2/src/base/uvm_objection.svh(1276) @ 0: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
UVM_INFO /apps/vcsmx/vcs/S-2021.09//etc/uvm-1.2/src/base/uvm_report_server.svh(904) @ 0: reporter [UVM/REPORT/SERVER] 
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

class subCompA extends uvm_component;
    `uvm_component_utils (subCompA)
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
  
    uvm_blocking_put_port #(Packet) m_put_port;
    int m_num_tx=2;
  
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
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
            `uvm_info ("SUBCOMPA", "Packet sent to subCompB", UVM_LOW)
            pkt.print (uvm_default_line_printer);
        
            // Call the TLM put() method of put_port class and pass packet as argument
            m_put_port.put (pkt);
        end
        phase.drop_objection(this);
    endtask
endclass

class componentA extends uvm_component;
   `uvm_component_utils (componentA)
   function new (string name = "componentA", uvm_component parent= null);
      super.new (name, parent);
   endfunction

    subCompA m_subcomp_A;
    uvm_blocking_put_port #(Packet) m_put_port;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_subcomp_A = subCompA::type_id::create("m_subcomp_A", this);
    m_put_port = new ("m_put_port", this);
  endfunction
  
  // Connection with subCompA
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    m_subcomp_A.m_put_port.connect(this.m_put_port);
  endfunction
endclass

class subCompB extends uvm_component;
    `uvm_component_utils (subCompB)
    function new (string name = "subCompB", uvm_component parent = null);
        super.new (name, parent);
    endfunction

    // Mention type of transaction, and type of class that implements the put ()
    uvm_blocking_put_imp #(Packet, subCompB) m_put_imp;
 
    virtual function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        m_put_imp = new ("m_put_imp", this);
    endfunction
 
    // Implementation of the 'put()' method in this case simply prints it.
  	virtual task put (Packet pkt);            
        `uvm_info ("SUBCOMPB", "Packet received from subCompA", UVM_LOW)
        pkt.print(uvm_default_line_printer);
    endtask
endclass

class componentB extends uvm_component;
    `uvm_component_utils (componentB)
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
 
	subCompB m_subcomp_B;
    uvm_blocking_put_export#(Packet) m_put_export;
  
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_subcomp_B = subCompB::type_id::create("m_subcomp_B", this);
        m_put_export = new("m_put_export", this);
    endfunction
  
    // Connection with subCompB
    virtual function void connect_phase(uvm_phase phase);
        m_put_export.connect(m_subcomp_B.m_put_imp);
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
     compA.m_put_port.connect (compB.m_put_export);  
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