/**
use foreach to set constraint for dynamic array and queue

darray = '{'h0, 'h1, 'h2, 'h3, 'h4} , queue = '{'h1, 'h2, 'h3, 'h4, 'h5} 
*/

class ABC;
    rand bit [3:0] darray[];    // dynamic array (size unknown)
    rand bit [3:0] queue[$];    // queue (size unknown)

    constraint c_darray {
        foreach (darray[i])
            darray[i] == i;     // value equals index for darray
        foreach (queue[i])
            queue[i] == i + 1;  // value equals index +1 for queue
    }

    constraint c_queue {
        queue.size() == 5;      // queue size equals 5
    }

    function new();             // use class constructor, but can also use constraint
        darray = new[5];        // set darray size to 5
    endfunction
endclass

module tb;
    initial begin
        ABC abc = new();
        abc.randomize();
        $display("darray = %p, queue = %p", abc.darray, abc.queue);    
    end
endmodule