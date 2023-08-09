/**

module tb_ipc_event;
[0] wait for e to trigger
[5] e has triggered
[5] run after e is triggered

*/

// event as argument
module tb_ipc_event;
    event e;

    initial begin                   // wait for an event to be triggered, so next expression ($display) can continue
        fork                        // (expressions inside) run in parallel
            wait_for_trigger(e); 
            #5 ->e;
        join
        $display("[%0t] run after e is triggered", $time);  // run after fork join is done
    end

    task wait_for_trigger(event e);
        $display("[%0t] wait for e to trigger", $time);
        wait (e.triggered);
        $display("[%0t] e has triggered", $time);
    endtask 

endmodule