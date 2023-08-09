/**
[Udemy Writing UVM testbenches for Newbie] 

same example from verilog_test\tutorial_systemverilog\class\poly3.sv
added factory class to dynamically create objects

output
Hardware Engg Name : abc and Age : 25

note
- employee_record must be before hardware, software as they extends employee_record
- hardware, software must be before factory as factory uses them
*/

class employee_record;
    int age;
    string name;
    
    function new (input string name, input int age);
        this.age  = age;
        this.name = name;
    endfunction
    
    virtual function void run();
        $display("Error");
    endfunction
endclass
 
class hardware extends employee_record;
    function new(input string name,input int age);
        super.new(name,age);
    endfunction
    
    function void run();
        $display("Hardware Engg Name : %0s and Age : %0d",name,age);
    endfunction
endclass
 
class software extends employee_record;
    function new(input string name,input int age);
        super.new(name,age);
    endfunction
    
    function void run();
        $display("Software Engg Name : %0s and Age : %0d",name,age);
    endfunction
endclass

class factory;
    static function employee_record add_record(input string category, input string name, input int age);
        hardware h;
        software s;

        case(category)
            "hardware": begin
                h = new(name, age);
                return h;
            end
            "software": begin
                s = new(name, age);
                return s;
            end
            default: $stop();
        endcase
    endfunction
endclass

module tb;
    employee_record t;

    initial begin
        t = factory::add_record("hardware", "abc", 25);
        t.run();
    end
endmodule
