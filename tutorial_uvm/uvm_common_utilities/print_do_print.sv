/**
summary
- override do_print() to just print selected members of the class to reduce print overhead

output
-------------------------------
Name      Type      Size  Value
-------------------------------
obj       Object    -     @349 
  m_bool  string    4     TRUE 
  m_mode  integral  4     'h3  
  m_name  string    3     obj  
-------------------------------

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
    
    // This function simply uses the printer functions to print variables based on their
    // data types. For example, "int" variables are printed using function "print_field_int"
    virtual function void do_print(uvm_printer printer);
        super.do_print(printer);
        printer.print_string("m_bool", m_bool.name());
        printer.print_field_int("m_mode", m_mode, $bits(m_mode), UVM_HEX);
        printer.print_string("m_name", m_name);
    endfunction
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
        obj.print();
    endfunction
endclass

module tb;
	initial begin
		run_test("base_test");
	end
endmodule
