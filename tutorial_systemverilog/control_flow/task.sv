
/**
syntax
task <name>;
    input <port_list>;
    inout <port_list>;
    output <port_list>;
    begin  
        ...
    end
endtask

task <name> (input <port_list>, inout <port_list>, output <port_list>);
    begin  
        ...
    end
endtask

task <name> ();
    begin
        ...
    end
endtask

module tb_static;   // the local variables are "static"
i = 1
i = 2
i = 3
i = 4

module tb_auto;     // the local variables are NOT "static"
i = 1
i = 1
i = 1
i = 1

module tb_call_task;    // 
Hello!
tb_call_task, i = 1
tb_call_task, i = 2
tb_task, i = 3
tb_task, i = 4
*/

// static task (default)
module tb_static;

    initial display();
    initial display();
    initial display();
    initial display();

    task display();
        integer i = 0;
        i = i + 1;
        $display("[i = %0d", i);
    endtask

endmodule

// automatic task ("automatic" keyword)
module tb_auto;

    initial display();
    initial display();
    initial display();
    initial display();

    task automatic display();
        integer i = 0;
        i = i + 1;
        $display("i = %0d", i);
    endtask

endmodule


// global task
task display();
    $display("Hello!");
endtask

// module to be instantiated
module tb_task;

    initial display("tb_task");
    initial display("tb_task");

    task display(string a);
        integer i = 0;
        i = i + 1;
        $display("%s, i = %0d", a, i);
    endtask

endmodule

// use global or other modules' tasks
module tb_call_task;
    tb_task tt();           // instantiate another module to use its task
    
    initial begin
        display();          // use global task
        tt.display("tb_call_task"); // use another module's task
        tt.display("tb_call_task");
    end
endmodule