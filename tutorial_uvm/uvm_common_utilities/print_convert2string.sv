/**

UVM_INFO @ 0: reporter [RNTST] Running test base_test...
UVM_INFO testbench.sv(43) @ 0: uvm_test_top [base_test] convert2string:  m_name=obj m_bool=TRUE m_mode=0x3 m_data[0]=0x9f m_data[1]=0x33 m_data[2]=0x12 m_data[3]=0x9c
UVM_INFO /apps/vcsmx/vcs/Q-2020.03-SP1-1//etc/uvm-1.2/src/base/uvm_report_server.svh(894) @ 0: reporter [UVM/REPORT/SERVER] 

*/

typedef enum {FALSE, TRUE} e_bool;
class Object extends uvm_object;
    rand e_bool 			m_bool;
    rand bit[3:0] 			m_mode;
    rand byte 				m_data[4];
    rand shortint 			m_queue[$];
    string 					m_name;
    
    constraint c_queue { m_queue.size() == 3; }
    
    function new(string name = "Object");
        super.new(name);
        m_name = name;
    endfunction
    
    // Use "do_print" instead of the automation macro
    `uvm_object_utils(Object)
    
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
endclass

class base_test extends uvm_test;
    `uvm_component_utils(base_test)
    function new(string name = "base_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        Object obj = Object::type_id::create("obj");
        obj.randomize();
        
        `uvm_info(get_type_name(), $sformatf("convert2string: %s", obj.convert2string()), UVM_LOW)
    endfunction
endclass

module tb;
	initial begin
		run_test("base_test");
	end
endmodule