/**

due to "Virtual" keyword in base class, display() method is overridden by child class
so outputs are the same

[Child] Thread1: addr=0xed data=0x78 en=1
[Child] Thread1: addr=0xed data=0x78 en=1

*/
class Base;
	rand bit [7:0] addr;
	rand bit [7:0] data;
	
    function new(int addr, int data);
        this.addr = addr;
        this.data = data;
    endfunction

	// Parent class has a method called 'display' declared as virtual
	virtual function void display(string tag="Thread1");
		$display ("[Base] %s: addr=0x%0h data=0x%0h", tag, addr, data);
	endfunction
endclass

class Child extends Base;
	rand bit en;

    function new(int addr, int data, int en);
        super.new(addr, data);
        this.en = en;
    endfunction
	
	// Child class redefines the method to also print 'en' variable
	function void display(string tag="Thread1");
		$display ("[Child] %s: addr=0x%0h data=0x%0h en=%0d", tag, addr, data, en);
	endfunction
endclass

module tb;
	Base    bc; 	// bc stands for BaseClass
	Child   sc; 	// sc stands for SubClass

	initial begin
		sc = new (32'hfeed_feed, 32'h1234_5678, 1);
		
		// Assign sub-class to base-class handle
		bc = sc;
      
		bc.display ();  // function call based on object (handle) type, so it calls display() of Child. [Child] Thread1: addr=0xed data=0x78 en=1
		sc.display ();	// [Child] Thread1: addr=0xed data=0x78 en=1

        //$display ("data=0x%0h", bc.data);   // again variable is based on object type, Packet class does not have "data"
	end
endmodule