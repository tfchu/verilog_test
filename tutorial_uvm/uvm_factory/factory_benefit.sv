/**
[Udemy Writing UVM testbenches for Newbie] 

pure systemverilog example

output
Data : 12

note
- class env does not define a constructor, it is ok
- class env::run task can be also changed to a function

now if we want to add data1 to drv, then drv class new(), run() are change. 
after that, class env needs to change as it uses the drv handle. 
so we cannot dynamically change drv class
we can extend drv, but inside env we still need to change the handle

benefit of UVM factory
- dynamically change behavior of a class by class/type override
- dynamically create an object (type_id::create()), see factory_benefit2.sv
*/
`timescale 1ns/1ps

class drv;
    int data;

    function new(input int data);
        this.data = data;
    endfunction

    task run();
        $display("Data : %0d\n", this.data);
    endtask
endclass

class env;
    drv d;

    task run();
        d = new(12);
        d.run();
    endtask
endclass

module tb;
    env e;

    initial begin
        e = new();
        e.run();
    end
endmodule