/**

vcs
module tb_event;
[0] thread2: waiting for event_a
[0] thread3: waiting for event_a
[20] thread1: triggered event_a
[20] thread2: received event_a
[20] thread3: received event_a

module tb_triggered;
[0] thread2: waiting for event_a
[0] thread3: waiting for event_a
[20] thread1: triggered event_a
[20] thread3: received event_a

module tb_wait_order;
events were executed in the correct order


*/

module tb_event;
    event event_a;

    initial begin
        #20 ->event_a;
        $display("[%0t] thread1: triggered event_a", $time);
    end

    initial begin
        $display("[%0t] thread2: waiting for event_a", $time);
        @(event_a);
        $display("[%0t] thread2: received event_a", $time);
    end   

    initial begin
        $display("[%0t] thread3: waiting for event_a", $time);
        wait(event_a.triggered);
        $display("[%0t] thread3: received event_a", $time);
    end    
endmodule

// race condition between trigger and receive for thread 2
// thread 2 never received the trigger 
// use .triggered like thread 3 to avoid race condition
module tb_triggered;
    event event_a;

    initial begin
        #20 ->event_a;
        $display("[%0t] thread1: triggered event_a", $time);
    end

    initial begin
        $display("[%0t] thread2: waiting for event_a", $time);
        #20 @(event_a);
        $display("[%0t] thread2: received event_a", $time);
    end   

    initial begin
        $display("[%0t] thread3: waiting for event_a", $time);
        wait(event_a.triggered);
        $display("[%0t] thread3: received event_a", $time);
    end    
endmodule

// wait_order(e1, e2, ...): wait for events to be triggered in the given order, issue and error if out-of-order
module tb_wait_order;
    event a, b, c;

    initial begin
        #10 -> a;
        #10 -> b;
        #10 -> c;
    end

    initial begin
        wait_order(a, b, c)
            $display("events were executed in the correct order");
        else
            $display("events were NOT executed in the correct order");
    end
endmodule