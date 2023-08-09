/**
assign base to child (sub) class
bc = sc;

demo class attributes/methods are based on object type

test 1: 
bc.display ();
sc.display ();

[Base] addr=0xfeedfeed
[Child] addr=0xfeedfeed data=0x12345678

test 2: 
$display ("data=0x%0h", bc.data);
"bc."
  Could not find member 'data' in class 'Packet', at "testbench.sv", 3.
*/

class Packet;
	int addr;

	function new (int addr);
		this.addr = addr;
	endfunction

	function display ();
		$display ("[Base] addr=0x%0h", addr);
	endfunction
endclass

// A subclass called 'ExtPacket' is derived from the base class 'Packet' using
// 'extends' keyword which makes 'EthPacket' a child of the parent class 'Packet'
// The child class inherits all variables and methods from the parent class
class ExtPacket extends Packet;

	// This is a new variable only available in child class
	int data; 		

	function new (int addr, data);
		super.new (addr); 	// Calls 'new' method of parent class
		this.data = data;
	endfunction

	function display ();
		$display ("[Child] addr=0x%0h data=0x%0h", addr, data);
	endfunction
endclass

module tb;
	Packet      bc; 	// bc stands for BaseClass
	ExtPacket   sc; 	// sc stands for SubClass

	initial begin
		sc = new (32'hfeed_feed, 32'h1234_5678);
		
		// Assign sub-class to base-class handle
		bc = sc;
      
		bc.display ();  // function call based on object (handle) type, so it calls display() of Packet
		sc.display ();

        //$display ("data=0x%0h", bc.data);   // again variable is based on object type, Packet class does not have "data"
	end
endmodule