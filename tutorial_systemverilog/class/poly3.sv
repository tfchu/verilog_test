/**
[Udemy Writing UVM testbenches for Newbie] 

summary
- class polymorphism



Hardware Engg Name : Jayesh and Age : 25
Hardware Engg Name : Jayesh and Age : 25
Software Engg Name : Dhiraj and Age : 25

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
 
module tb;
    employee_record e;
    hardware h;
    software s;
    
    initial begin
        h = new("Jayesh", 25);
        s = new("Dhiraj", 25);
        e = h;
        e.run();    // run hardware::run due to "virtual" method, overridden by child method
        h.run();    // run hardware::run
        s.run();    // run sofware::run
    end
endmodule