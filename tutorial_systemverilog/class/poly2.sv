/**
Test 1: assign child (sub) class to base class
sc = bc;

this causes compile error

Expression 'bc' on rhs is not a class or a compatible class and hence cannot
  be assigned to a class handle on lhs.
  Source type: class $unit::Packet
  Target type: class $unit::ExtPacket
  Please make sure that the lhs and rhs expressions are compatible.

Test 2: use cast
$cast (sc, bc);

this compiles ok but still has run-time error

Error-[DCF] Dynamic cast failed

testbench.sv, 44
  Casting of source class type 'Packet' to destination class type 'ExtPacket' 
  failed due to type mismatch.
  Please ensure matching types for dynamic cast

Test 3: cast with another child class (module tb1)

[Base] addr=0xfeedfeed
[Child] addr=0xfeedfeed data=0x12345678
[Child] addr=0xfeedfeed data=0x12345678
data=0x12345678
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
		bc = new (32'hface_cafe);
      
        // Assign base class object to sub-class handle
		sc = bc;

        // Dynamic cast base class object to sub-class type
        //$cast (sc, bc);
      
		bc.display();
        sc.display();
	end
endmodule

module tb1;
	Packet      bc; 	// bc stands for BaseClass
	ExtPacket   sc; 	// sc stands for SubClass

	initial begin
        ExtPacket sc2;
        bc = new (32'hface_cafe);
        sc = new (32'hfeed_feed, 32'h1234_5678);
        bc = sc;
        
        // Dynamic cast sub class object in base class handle to sub-class type
        // bs acts like a carrier to cast between 2 sub-classes (ExtPacket)
        $cast (sc2, bc);
        
        bc.display();
        sc.display();
        sc2.display ();
        $display ("data=0x%0h", sc2.data);
	end
endmodule