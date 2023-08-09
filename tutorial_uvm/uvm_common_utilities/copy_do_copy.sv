/**

UVM_INFO @ 0: reporter [RNTST] Running test base_test...
UVM_INFO testbench.sv(92) @ 0: uvm_test_top [TEST] Obj1.print:  m_name=obj1 m_bool=TRUE m_mode=0x3 m_data[0]=0x9f m_data[1]=0x33 m_data[2]=0x12 m_data[3]=0x9c
UVM_INFO testbench.sv(94) @ 0: uvm_test_top [TEST] Obj2.print:  m_name=obj2 m_bool=TRUE m_mode=0xf m_data[0]=0xcb m_data[1]=0x49 m_data[2]=0xcc m_data[3]=0x49
UVM_INFO testbench.sv(25) @ 0: reporter [m_pkt] In Packet::do_copy()
UVM_INFO testbench.sv(78) @ 0: reporter [obj2] In Object::do_copy()
UVM_INFO testbench.sv(97) @ 0: uvm_test_top [TEST] After copy
UVM_INFO testbench.sv(98) @ 0: uvm_test_top [TEST] Obj2.print:  m_name=obj1 m_bool=TRUE m_mode=0x3 m_data[0]=0x9f m_data[1]=0x33 m_data[2]=0x12 m_data[3]=0x9c
UVM_INFO /apps/vcsmx/vcs/Q-2020.03-SP1-1//etc/uvm-1.2/src/base/uvm_report_server.svh(894) @ 0: reporter [UVM/REPORT/SERVER] 

*/

typedef enum {FALSE, TRUE} e_bool;

class Packet extends uvm_object;
    rand bit[15:0] 	m_addr;
    
    // Function is used to return contents of this class in a 
    // string format
    virtual function string convert2string();
        string contents;
        contents = $sformatf("m_addr=0x%0h", m_addr);
    endfunction

    `uvm_object_utils(Packet)
    
    // Implementation of "do_copy". A generic uvm_object called "rhs"
    // is received and type casted into Packet called "_pkt". Then 
    // m_addr is copied from _pkt to the variable in current class
    virtual function void do_copy(uvm_object rhs);
        Packet _pkt;
        super.do_copy(rhs);
        $cast(_pkt, rhs);
        m_addr = _pkt.m_addr;
        `uvm_info(get_name(), "In Packet::do_copy()", UVM_LOW)
    endfunction
    
    function new(string name = "Packet");
        super.new(name);
    endfunction
endclass

class Object extends uvm_object;
    rand e_bool 			m_bool;
    rand bit[3:0] 			m_mode;
    rand byte 				m_data[4];
    rand shortint 			m_queue[$];
    string 					m_name;
    rand Packet 			m_pkt;
    
    constraint c_queue { m_queue.size() == 3; }
    
    function new(string name = "Object");
        super.new(name);
        m_name = name;
        m_pkt = Packet::type_id::create("m_pkt");
        m_pkt.randomize();
    endfunction
    
    // Function used to return contents of this class in a 
    // string format
    virtual function string convert2string();
        string contents = "";
        $sformat(contents, "%s m_name=%s", contents, m_name);
        $sformat(contents, "%s m_bool=%s", contents, m_bool.name());
        $sformat(contents, "%s m_mode=0x%0h", contents, m_mode);
        foreach(m_data[i]) begin
        $sformat(contents, "%s m_data[%0d]=0x%0h", contents, i, m_data[i]);
        end
        return contents;
    endfunction
    
    `uvm_object_utils(Object)
    
    // "rhs" does not contain m_bool, m_mode, etc since its a parent
    // handle. So cast into child data type and access using child handle
    // Copy each field from the casted handle into local variables
    virtual function void do_copy(uvm_object rhs);
        Object _obj;
        super.do_copy(rhs);
        $cast(_obj, rhs);
        m_bool 	= _obj.m_bool;
        m_mode 	= _obj.m_mode;
        m_data 	= _obj.m_data;
        m_queue = _obj.m_queue;
        m_name 	= _obj.m_name;
        m_pkt.copy(_obj.m_pkt);
        `uvm_info(get_name(), "In Object::do_copy()", UVM_LOW)
    endfunction
endclass

class base_test extends uvm_test;
        `uvm_component_utils(base_test)
    function new(string name = "base_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        Object obj1 = Object::type_id::create("obj1");
        Object obj2 = Object::type_id::create("obj2");
        obj1.randomize();
        `uvm_info("TEST", $sformatf("Obj1.print: %s", obj1.convert2string()), UVM_LOW)
        obj2.randomize();
        `uvm_info("TEST", $sformatf("Obj2.print: %s", obj2.convert2string()), UVM_LOW)
        
        obj2.copy(obj1);
        `uvm_info("TEST", "After copy", UVM_LOW)
        `uvm_info("TEST", $sformatf("Obj2.print: %s", obj2.convert2string()), UVM_LOW)
    endfunction
endclass

module tb;
	initial begin
		run_test("base_test");
	end
endmodule