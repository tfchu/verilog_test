/**

UVM_INFO @ 0: reporter [RNTST] Running test base_test...
UVM_INFO testbench.sv(66) @ 0: uvm_test_top [TEST] Obj1.print:  m_name=obj1 m_bool=TRUE m_mode=0x3 m_data[0]=0x9f m_data[1]=0x33 m_data[2]=0x12 m_data[3]=0x9c
UVM_INFO testbench.sv(70) @ 0: uvm_test_top [TEST] After clone
UVM_INFO testbench.sv(71) @ 0: uvm_test_top [TEST] Obj2.print:  m_name=Object m_bool=FALSE m_mode=0x0 m_data[0]=0x0 m_data[1]=0x0 m_data[2]=0x0 m_data[3]=0x0
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
endclass

class base_test extends uvm_test;
    `uvm_component_utils(base_test)
    function new(string name = "base_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        // Create obj1, but only declare handle for obj2
        Object obj2;
        Object obj1 = Object::type_id::create("obj1");
        obj1.randomize();
        `uvm_info("TEST", $sformatf("Obj1.print: %s", obj1.convert2string()), UVM_LOW)
        
        // Use $cast to clone obj1 into obj2
        $cast(obj2, obj1.clone());
        `uvm_info("TEST", "After clone", UVM_LOW)
        `uvm_info("TEST", $sformatf("Obj2.print: %s", obj2.convert2string()), UVM_LOW)
    endfunction
endclass

module tb;
	initial begin
		run_test("base_test");
	end
endmodule