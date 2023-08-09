/*
ref: http://www.verificationland.com/blog/2017/5/28/fun-with-type-handles

use class parameter as type handle (type T)
- a handle to some sort of object that uniquely identifies a type
- used for classifying objects by type at run time

call flow
(1) new my_container -> container#(int) type_handle -> get_type() -> type_handle is null -> new type_handle -> assign to type_handle
(2) new my_container1 -> container#(int) type_handle -> get_type() -> type is the same, so type_handle is NOT null -> return the same type_handle in (1)
so (1) and (2) share the same type_handle, i.e. as long as the types are the same, type_handle is the same

(3) new my_container2 -> container#(real) type_handle -> get_type() -> type different, so type_handle is null -> new type_handle -> assign to type_handle
so (3) and (1) type_handle points to different location due to the nature of static variable

output: 
int containers
1
0
0
*/
virtual class base;
    pure virtual function base get_type_handle();
endclass

class container#(type T=int) extends base;
    typedef container#(T) this_type;
    
    local static this_type type_handle = get_type();

    //local function new();
    // empty
    //endfunction

    // static method, no need to instantiate   
    static function this_type get_type();
        if(type_handle == null)
            type_handle = new();
        return type_handle;
    endfunction
    
    // normal method, called in run time to get class type
    virtual function base get_type_handle();
        return get_type();
    endfunction
endclass
    
module tb;
    container my_container = new;     		// default to container#(int), type_handle is static (init once if type is the same)
    container#(int) my_container1 = new;
    container#(real) my_container2 = new;
    initial begin
        case(my_container.get_type_handle())
            container#(int)::get_type()    : $display("int containers"); // int containers
            container#(real)::get_type()   : $display("real containers"); // real containers
            container#(string)::get_type() : $display("string containers");// string containers
            default: $display("Uh oh! illegal container type");
        endcase
        $display(my_container.get_type_handle() == my_container1.get_type_handle());     // 1 (true as class types are the same)
        $display(my_container == my_container1);                                         // 0 (false as these handles point to different location)
        $display(my_container.get_type_handle() == my_container2.get_type_handle());     // 0 (false)
    end
endmodule