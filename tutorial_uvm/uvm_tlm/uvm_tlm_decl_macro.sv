/**
https://www.chipverify.com/uvm/using-decl-macro-in-tlm

TLM macro `uvm_blocking_put_imp_decl

output
UVM_INFO @ 0: reporter [RNTST] Running test my_test...
UVM_INFO /apps/vcsmx/vcs/S-2021.09//etc/uvm-1.2/src/base/uvm_root.svh(589) @ 0: reporter [UVMTOP] UVM testbench topology:
---------------------------------------------------
Name            Type                    Size  Value
---------------------------------------------------
uvm_test_top    my_test                 -     @336 
  env           my_env                  -     @349 
    compA       componentA              -     @358 
      put_port  uvm_blocking_put_port   -     @385 
    compB       componentB              -     @376 
      put_imp1  uvm_blocking_put_imp_1  -     @395 
      put_imp2  uvm_blocking_put_imp_2  -     @405 
    compC       componentC              -     @367 
      put_port  uvm_blocking_put_port   -     @415 
---------------------------------------------------

UVM_INFO testbench.sv(42) @ 0: uvm_test_top.env.compA [COMPA] Packet sent to CompB
pkt: (simple_packet@435) { addr: 'h59  data: 'hf  } 
UVM_INFO testbench.sv(101) @ 0: uvm_test_top.env.compB [COMPB] Packet received from put_1
pkt: (simple_packet@435) { addr: 'h59  data: 'hf  } 
UVM_INFO testbench.sv(42) @ 0: uvm_test_top.env.compA [COMPA] Packet sent to CompB
pkt: (simple_packet@440) { addr: 'h50  data: 'h4  } 
UVM_INFO testbench.sv(101) @ 0: uvm_test_top.env.compB [COMPB] Packet received from put_1
pkt: (simple_packet@440) { addr: 'h50  data: 'h4  } 
UVM_INFO testbench.sv(73) @ 0: uvm_test_top.env.compC [COMPC] Packet sent to CompB
pkt: (simple_packet@445) { addr: 'h30  data: 'h44  } 
UVM_INFO testbench.sv(106) @ 0: uvm_test_top.env.compB [COMPB] Packet received from put_2
pkt: (simple_packet@445) { addr: 'h30  data: 'h44  } 
UVM_INFO testbench.sv(73) @ 0: uvm_test_top.env.compC [COMPC] Packet sent to CompB
pkt: (simple_packet@450) { addr: 'heb  data: 'hdd  } 
UVM_INFO testbench.sv(106) @ 0: uvm_test_top.env.compB [COMPB] Packet received from put_2
pkt: (simple_packet@450) { addr: 'heb  data: 'hdd  } 
UVM_INFO /apps/vcsmx/vcs/S-2021.09//etc/uvm-1.2/src/base/uvm_report_server.svh(904) @ 0: reporter [UVM/REPORT/SERVER] 

 */

// Create a class data object that can be sent from one 
// component to another
class simple_packet extends uvm_object;
  	rand bit[7:0] addr;
  	rand bit[7:0] data;
  
  	`uvm_object_utils_begin(simple_packet)
  		`uvm_field_int(addr, UVM_ALL_ON)
  		`uvm_field_int(data, UVM_ALL_ON)
  	`uvm_object_utils_end
  
  	function new(string name = "simple_packet");
    	super.new(name);
  	endfunction
endclass

//------------------------ componentA -------------------------------------

class componentA extends uvm_component;
    `uvm_component_utils (componentA)

    // We are creating a put_port parameterized to use a "simple_packet" type of data
    uvm_blocking_put_port #(simple_packet) put_port;
    simple_packet  pkt;

    function new (string name = "componentA", uvm_component parent= null);
        super.new (name, parent);
    endfunction

    virtual function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        // Remember that put_port is a class object and it will have to be 
        // created with new ()
        put_port = new ("put_port", this);
    endfunction

    virtual task run_phase (uvm_phase phase);
        // Let us generate 5 packets and send it via the put_port
        repeat (2) begin
            pkt = simple_packet::type_id::create ("pkt");
            assert(pkt.randomize ()); 
            `uvm_info ("COMPA", "Packet sent to CompB", UVM_LOW)
            pkt.print (uvm_default_line_printer);
            put_port.put (pkt);
        end
    endtask
endclass

//------------------------ componentC -------------------------------------
class componentC extends uvm_component;
    `uvm_component_utils (componentC)

    // We are creating a put_port which will accept a "simple_packet" type of data
    uvm_blocking_put_port #(simple_packet) put_port;
    simple_packet  pkt;

    function new (string name = "componentC", uvm_component parent= null);
        super.new (name, parent);
    endfunction

    virtual function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        // Remember that put_port is a class object and it will have to be 
        // created with new ()
        put_port = new ("put_port", this);
    endfunction

    virtual task run_phase (uvm_phase phase);
        // Let us generate 5 packets and send it via the put_port
        repeat (2) begin
            pkt = simple_packet::type_id::create ("pkt");
            assert(pkt.randomize ()); 
            `uvm_info ("COMPC", "Packet sent to CompB", UVM_LOW)
            pkt.print (uvm_default_line_printer);
            put_port.put (pkt);
        end
    endtask
endclass

`uvm_blocking_put_imp_decl (_1)
`uvm_blocking_put_imp_decl (_2)

class componentB extends uvm_component;
    `uvm_component_utils (componentB)
    
    // Mention type of transaction, and type of class that implements the put ()
    uvm_blocking_put_imp_1 #(simple_packet, componentB) put_imp1;
    uvm_blocking_put_imp_2 #(simple_packet, componentB) put_imp2;

    function new (string name = "componentB", uvm_component parent = null);
        super.new (name, parent);
    endfunction
    
    virtual function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        put_imp1 = new ("put_imp1", this);
        put_imp2 = new ("put_imp2", this);
    endfunction

    task put_1 (simple_packet pkt);
        `uvm_info ("COMPB", "Packet received from put_1", UVM_LOW)
        pkt.print (uvm_default_line_printer);
    endtask

    task put_2 (simple_packet pkt);
        `uvm_info ("COMPB", "Packet received from put_2", UVM_LOW)
        pkt.print (uvm_default_line_printer);
    endtask
endclass

class my_env extends uvm_env;
    `uvm_component_utils (my_env)

    componentA compA;
    componentC compC;
    componentB compB;

    function new (string name = "my_env", uvm_component parent = null);
        super.new (name, parent);
    endfunction

    virtual function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        compA = componentA::type_id::create ("compA", this);
        compC = componentC::type_id::create ("compC", this);
        compB = componentB::type_id::create ("compB", this);
    endfunction

    virtual function void connect_phase (uvm_phase phase);
        compA.put_port.connect (compB.put_imp1);  
        compC.put_port.connect (compB.put_imp2);
    endfunction
endclass

class my_test extends uvm_env;
    `uvm_component_utils (my_test)
    
    my_env env;
    
    function new (string name = "my_test", uvm_component parent = null);
        super.new (name, parent);
    endfunction
    
    virtual function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        // Create an object of both components
        env = my_env::type_id::create ("env", this);
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