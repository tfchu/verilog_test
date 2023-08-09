/**
copy with automation macro 

obj2.copy(obj1);    // copy obj1 (source) to obj2

comparison after copying 
- obj2 values of simple variable types (e.g. enum, int, byte, shortint, sstring) becomes the same as those of obj1
- for object data types (i.e class Packet), a copy of is created and copied into obj2, so the value do not match 
- obj2 value remains the same so the contents are held in the refernece to obj2

--------------------------------------
Name        Type          Size  Value 
--------------------------------------
obj1        Object        -     @349  
  m_bool    e_bool        32    TRUE  
  m_mode    integral      4     'h3   
  m_data    sa(integral)  4     -     
    [0]     integral      8     'h9f  
    [1]     integral      8     'h33  
    [2]     integral      8     'h12  
    [3]     integral      8     'h9c  
  m_queue   da(integral)  3     -     
    [0]     integral      16    'h182f
    [1]     integral      16    'h3b39
    [2]     integral      16    'hd7bd
  m_name    string        4     obj1  
  m_pkt     Packet        -     @350  
    m_addr  integral      16    'hbbf9
--------------------------------------
--------------------------------------
Name        Type          Size  Value 
--------------------------------------
obj2        Object        -     @351  
  m_bool    e_bool        32    TRUE  
  m_mode    integral      4     'hf   
  m_data    sa(integral)  4     -     
    [0]     integral      8     'hcb  
    [1]     integral      8     'h49  
    [2]     integral      8     'hcc  
    [3]     integral      8     'h49  
  m_queue   da(integral)  3     -     
    [0]     integral      16    'h9c6d
    [1]     integral      16    'h7866
    [2]     integral      16    'h7227
  m_name    string        4     obj2  
  m_pkt     Packet        -     @352  
    m_addr  integral      16    'h35f0
--------------------------------------
UVM_INFO testbench.sv(60) @ 0: uvm_test_top [TEST] After copy
--------------------------------------
Name        Type          Size  Value 
--------------------------------------
obj2        Object        -     @351  
  m_bool    e_bool        32    TRUE  
  m_mode    integral      4     'h3   
  m_data    sa(integral)  4     -     
    [0]     integral      8     'h9f  
    [1]     integral      8     'h33  
    [2]     integral      8     'h12  
    [3]     integral      8     'h9c  
  m_queue   da(integral)  3     -     
    [0]     integral      16    'h182f
    [1]     integral      16    'h3b39
    [2]     integral      16    'hd7bd
  m_name    string        4     obj1  
  m_pkt     Packet        -     @353  
    m_addr  integral      16    'hbbf9
--------------------------------------

*/

typedef enum {FALSE, TRUE} e_bool;

class Packet extends uvm_object;
    rand bit[15:0] 	m_addr;
    
    // Automation macros
    `uvm_object_utils_begin(Packet)
        `uvm_field_int(m_addr, UVM_DEFAULT)
    `uvm_object_utils_end
    
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
    
    `uvm_object_utils_begin(Object)
        `uvm_field_enum(e_bool, m_bool, UVM_DEFAULT)
        `uvm_field_int (m_mode, 		UVM_DEFAULT)
        `uvm_field_sarray_int(m_data, 	UVM_DEFAULT)
        `uvm_field_queue_int(m_queue, 	UVM_DEFAULT)
        `uvm_field_string(m_name, 		UVM_DEFAULT)
        `uvm_field_object(m_pkt, 		UVM_DEFAULT)
    `uvm_object_utils_end
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
        obj1.print();
        obj2.randomize();
        obj2.print();
        
        obj2.copy(obj1);
        `uvm_info("TEST", "After copy", UVM_LOW)
        obj2.print();
    endfunction
endclass

module tb;
	initial begin
		run_test("base_test");
	end
endmodule