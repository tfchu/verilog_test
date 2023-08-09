/**
https://www.chipverify.com/uvm/uvm-tlm-nonblocking-put-port

UVM TLM non-blocking put port
- case 1: simple try_put()
- case 2: try_put() in do while loop
- case 3: can_put()

componentA 
- declare m_put_port (uvm_nonblocking_put_port)
- call m_put_port.try_put(pkt)
    - try_put() checks if the put was successful
    - can_put() checks if the receiver is ready to accept a transfer

componentB
- implement try_put()

output

// case 1: simple try_put
UVM_INFO @ 0: reporter [RNTST] Running test my_test...
UVM_INFO /apps/vcsmx/vcs/S-2021.09//etc/uvm-1.2/src/base/uvm_root.svh(589) @ 0: reporter [UVMTOP] UVM testbench topology:
-----------------------------------------------------
Name            Type                      Size  Value
-----------------------------------------------------
uvm_test_top    my_test                   -     @336 
  compA         componentA                -     @349 
    m_put_port  uvm_nonblocking_put_port  -     @367 
  compB         componentB                -     @358 
    m_put_imp   uvm_nonblocking_put_imp   -     @377 
-----------------------------------------------------

UVM_INFO testbench.sv(62) @ 0: uvm_test_top.compA [COMPA] Packet sent to CompB		// send 1st packet at 0to
pkt: (Packet@397) { addr: 'h85  data: 'hf1  } 
UVM_INFO testbench.sv(95) @ 0: uvm_test_top.compB [COMPB] Packet received
pkt: (Packet@397) { addr: 'h85  data: 'hf1  } 
UVM_INFO testbench.sv(68) @ 0: uvm_test_top.compA [COMPA] COMPB was ready to accept and transfer is successful
UVM_INFO testbench.sv(62) @ 0: uvm_test_top.compA [COMPA] Packet sent to CompB		// send 2nd packet still at 0tu due to non-blocking
pkt: (Packet@404) { addr: 'h72  data: 'hf4  } 
UVM_INFO testbench.sv(95) @ 0: uvm_test_top.compB [COMPB] Packet received
pkt: (Packet@404) { addr: 'h72  data: 'hf4  } 
UVM_INFO testbench.sv(68) @ 0: uvm_test_top.compA [COMPA] COMPB was ready to accept and transfer is successful
UVM_INFO /apps/vcsmx/vcs/S-2021.09//etc/uvm-1.2/src/base/uvm_objection.svh(1276) @ 0: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
UVM_INFO /apps/vcsmx/vcs/S-2021.09//etc/uvm-1.2/src/base/uvm_report_server.svh(904) @ 0: reporter [UVM/REPORT/SERVER] 



// case 2: try_put() in do while loop
UVM_INFO @ 0: reporter [RNTST] Running test my_test...
UVM_INFO /apps/vcsmx/vcs/S-2021.09//etc/uvm-1.2/src/base/uvm_root.svh(589) @ 0: reporter [UVMTOP] UVM testbench topology:
-----------------------------------------------------
Name            Type                      Size  Value
-----------------------------------------------------
uvm_test_top    my_test                   -     @336 
  compA         componentA                -     @349 
    m_put_port  uvm_nonblocking_put_port  -     @367 
  compB         componentB                -     @358 
    m_put_imp   uvm_nonblocking_put_imp   -     @377 
-----------------------------------------------------

UVM_INFO testbench.sv(92) @ 0: uvm_test_top.compA [COMPA] Packet sent to CompB
pkt: (Packet@397) { addr: 'h85  data: 'hf1  } 
UVM_INFO testbench.sv(149) @ 0: uvm_test_top.compB [COMPB] Packet received
pkt: (Packet@397) { addr: 'h85  data: 'hf1  } 
UVM_INFO testbench.sv(110) @ 0: uvm_test_top.compA [COMPA] COMPB was ready to accept and transfer is successful
UVM_INFO testbench.sv(92) @ 1: uvm_test_top.compA [COMPA] Packet sent to CompB
pkt: (Packet@417) { addr: 'hf0  data: 'h9d  } 
UVM_INFO testbench.sv(149) @ 1: uvm_test_top.compB [COMPB] Packet received
pkt: (Packet@417) { addr: 'hf0  data: 'h9d  } 
UVM_INFO testbench.sv(110) @ 1: uvm_test_top.compA [COMPA] COMPB was ready to accept and transfer is successful
UVM_INFO /apps/vcsmx/vcs/S-2021.09//etc/uvm-1.2/src/base/uvm_objection.svh(1276) @ 2: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
UVM_INFO /apps/vcsmx/vcs/S-2021.09//etc/uvm-1.2/src/base/uvm_report_server.svh(904) @ 2: reporter [UVM/REPORT/SERVER] 



// case 3: use can_put
UVM_INFO @ 0: reporter [RNTST] Running test my_test...
UVM_INFO /apps/vcsmx/vcs/S-2021.09//etc/uvm-1.2/src/base/uvm_root.svh(589) @ 0: reporter [UVMTOP] UVM testbench topology:
-----------------------------------------------------
Name            Type                      Size  Value
-----------------------------------------------------
uvm_test_top    my_test                   -     @336 
  compA         componentA                -     @349 
    m_put_port  uvm_nonblocking_put_port  -     @367 
  compB         componentB                -     @358 
    m_put_imp   uvm_nonblocking_put_imp   -     @377 
-----------------------------------------------------

UVM_INFO testbench.sv(122) @ 0: uvm_test_top.compA [COMPA] Packet sent to CompB
pkt: (Packet@397) { addr: 'h85  data: 'hf1  } 
UVM_INFO testbench.sv(150) @ 0: uvm_test_top.compA [COMPA] Waiting for receiver to be ready ...
UVM_INFO testbench.sv(154) @ 0: uvm_test_top.compA [COMPA] Receiver is now ready to accept transfers
UVM_INFO testbench.sv(181) @ 0: uvm_test_top.compB [COMPB] Packet received
pkt: (Packet@397) { addr: 'h85  data: 'hf1  } 
UVM_INFO testbench.sv(122) @ 0: uvm_test_top.compA [COMPA] Packet sent to CompB
pkt: (Packet@406) { addr: 'hf0  data: 'h9d  } 
UVM_INFO testbench.sv(150) @ 0: uvm_test_top.compA [COMPA] Waiting for receiver to be ready ...
UVM_INFO testbench.sv(154) @ 0: uvm_test_top.compA [COMPA] Receiver is now ready to accept transfers
UVM_INFO testbench.sv(181) @ 0: uvm_test_top.compB [COMPB] Packet received
pkt: (Packet@406) { addr: 'hf0  data: 'h9d  } 
UVM_INFO /apps/vcsmx/vcs/S-2021.09//etc/uvm-1.2/src/base/uvm_objection.svh(1276) @ 0: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
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
 
  	// Create a nonblocking TLM put port which can send an object
  	// of type 'Packet'
  	uvm_nonblocking_put_port #(Packet) m_put_port;
  	int m_num_tx;
 
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
			bit success;
			Packet pkt = Packet::type_id::create ("pkt");
			assert(pkt.randomize ()); 
		
			// Print the packet to be displayed in log
			`uvm_info ("COMPA", "Packet sent to CompB", UVM_LOW)
			pkt.print (uvm_default_line_printer);
	
			// case 1: Try to put the packet through the put port, simple try_put()
			// success = m_put_port.try_put(pkt);
			// if (success) 
			// 	`uvm_info("COMPA", $sformatf("COMPB was ready to accept and transfer is successful"), UVM_MEDIUM)
			// else
			// 	`uvm_info("COMPA", $sformatf("COMPB was NOT ready to accept and transfer failed"), UVM_MEDIUM)

			// case 2: try_put in a do while loop
			// do-while loop uses a "try_put" to keep the sender blocked until the receiver is ready. Return
			// type of the try_put indicates if the transfer was successful. So, lets just try putting 
			// the same packet until the receiver returns a 1 indicating successful transfer. 
			// Note that this is the same as using "put" but we are doing it with "try_put" and a loop
			// do begin
			// 	success = m_put_port.try_put(pkt);
			// 	if (success) 
			// 		`uvm_info("COMPA", $sformatf("COMPB was ready to accept and transfer is successful"), UVM_MEDIUM)
			// 	else
			// 		`uvm_info("COMPA", $sformatf("COMPB was NOT ready to accept and transfer failed, try after 1ns"), UVM_MEDIUM)
			// 	#1;
			// end while (!success);

			// case 3: call can_put() to make sure receiver is ready
			// Another way to do the same is to loop until can_put returns a 1. In this case, its is 
			// not even attempted to send a transaction using put, until the sender knows for sure
			// that the receiver is ready to accept it
			`uvm_info("COMPA", $sformatf("Waiting for receiver to be ready ..."), UVM_MEDIUM)
			do begin
				success = m_put_port.can_put();
			end while (!success);
			`uvm_info("COMPA", $sformatf("Receiver is now ready to accept transfers"), UVM_MEDIUM)
			m_put_port.try_put(pkt);
		end
     	phase.drop_objection(this);
   	endtask
endclass

class componentB extends uvm_component;
   	`uvm_component_utils (componentB)
 
   	// Mention type of transaction, and type of class that implements the put ()
  	uvm_nonblocking_put_imp #(Packet, componentB) m_put_imp;

   	function new (string name = "componentB", uvm_component parent = null);
      	super.new (name, parent);
   	endfunction
 
   	virtual function void build_phase (uvm_phase phase);
    	super.build_phase (phase);
    	m_put_imp = new ("m_put_imp", this);
   	endfunction
 
  	// 'try_put' method definition accepts the packet and prints it.
  	// Note that it should return 1 if successful so that componentA
  	// knows how to handle the transfer return code
  	virtual function bit try_put (Packet pkt);
		// case 1: simple try_put(), return 1 means put is successful
    	`uvm_info ("COMPB", "Packet received", UVM_LOW)
    	pkt.print(uvm_default_line_printer);
    	return 1;

		// case 2: do while try_put(), return 1 or 0 (random) indicating success or fail
		// bit ready;
		// std::randomize(ready);
		
		// if (ready) begin
		// 	`uvm_info ("COMPB", "Packet received", UVM_LOW)
		// 	pkt.print(uvm_default_line_printer);
		// 	return 1;
		// end else begin
		// 	return 0;
		// end
  	endfunction
  
	// case 3: use can_put, when using can_put, use case 1 in try_put
  	virtual function bit can_put();
		return $urandom_range(0,1); 
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
		compA.m_num_tx = 2;
   	endfunction
 
   	// Connection between componentA and componentB is done here
   	// Note that the "put_port" is connected to its implementation "put_imp"
   	virtual function void connect_phase (uvm_phase phase);
    	compA.m_put_port.connect (compB.m_put_imp);  
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