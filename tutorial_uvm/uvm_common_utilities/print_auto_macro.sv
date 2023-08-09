/**

----------------------------------------------------------------
UVM-1.2.Synopsys
(C) 2007-2014 Mentor Graphics Corporation
(C) 2007-2014 Cadence Design Systems, Inc.
(C) 2006-2014 Synopsys, Inc.
(C) 2011-2013 Cypress Semiconductor Corp.
(C) 2013-2014 NVIDIA Corporation
----------------------------------------------------------------

  ***********       IMPORTANT RELEASE NOTES         ************

  You are using a version of the UVM library that has been compiled
  with `UVM_NO_DEPRECATED undefined.
  See http://www.eda.org/svdb/view.php?id=3313 for more details.

  You are using a version of the UVM library that has been compiled
  with `UVM_OBJECT_DO_NOT_NEED_CONSTRUCTOR undefined.
  See http://www.eda.org/svdb/view.php?id=3770 for more details.

      (Specify +UVM_NO_RELNOTES to turn off this notice)

UVM_INFO @ 0: reporter [RNTST] Running test base_test...
-------------------------------------
Name       Type          Size  Value 
-------------------------------------
obj        Object        -     @349  
  m_bool   e_bool        32    TRUE  
  m_mode   integral      4     'h3   
  m_data   sa(integral)  4     -     
    [0]    integral      8     'h9f  
    [1]    integral      8     'h33  
    [2]    integral      8     'h12  
    [3]    integral      8     'h9c  
  m_queue  da(integral)  3     -     
    [0]    integral      16    'h182f
    [1]    integral      16    'h3b39
    [2]    integral      16    'hd7bd
  m_name   string        3     obj   
-------------------------------------
UVM_INFO /apps/vcsmx/vcs/Q-2020.03-SP1-1//etc/uvm-1.2/src/base/uvm_report_server.svh(894) @ 0: reporter [UVM/REPORT/SERVER] 
--- UVM Report Summary ---

** Report counts by severity
UVM_INFO :    2
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[RNTST]     1
[UVM/RELNOTES]     1


// if using utility macro - `uvm_object_utils(Object)
-------------------------
Name  Type    Size  Value
-------------------------
obj   Object  -     @349 
-------------------------

*/

typedef enum {FALSE, TRUE} e_bool;
class Object extends uvm_object;
    
    rand e_bool 			m_bool;
    rand bit[3:0] 			m_mode;
    rand byte 				m_data[4];
    rand shortint 			m_queue[$];
    string					m_name;
    
    constraint c_queue { m_queue.size() == 3; }
    
    function new(string name = "Object");
        super.new(name);
        m_name = name;
    endfunction

    // `uvm_object_utils(Object); 
    
    Each variable has to be registered with a macro corresponding to its data
    type. For example, "int" types use `uvm_field int, "enum" types use 
    `uvm_field_enum, and "string" use `uvm_field_string
    `uvm_object_utils_begin(Object)
        `uvm_field_enum(e_bool, m_bool,	UVM_DEFAULT)
        `uvm_field_int (m_mode,					UVM_DEFAULT)
        `uvm_field_sarray_int(m_data,		UVM_DEFAULT)
        `uvm_field_queue_int(m_queue,		UVM_DEFAULT)
        `uvm_field_string(m_name,				UVM_DEFAULT)
    `uvm_object_utils_end
endclass

class base_test extends uvm_test;
    `uvm_component_utils(base_test)
    function new(string name = "base_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction
    
    // In the build phase, create an object, randomize it and print
    // its contents
    function void build_phase(uvm_phase phase);
        Object obj = Object::type_id::create("obj");
        obj.randomize();
        obj.print();          // use print() created by automatic macro defined in `uvm_object_utils_begin and `uvm_object_utils_end
    endfunction
endclass

module tb;
	initial begin
		run_test("base_test");
	end
endmodule
