/**
module tb_fork_join;
#1  3  6 7  11
_|          |
 |_____|            // thread 1
 |__|____|          // thread 2
 |__________|       // thread 3

[1] fork started
[3] thread 2
[6] thread 1
[7] thread 2
[11] thread 3
[11] fork ended

module tb_fork_join_any;
[1] fork started
[3] thread 2
[6] thread 1            // fork_any unblocks here
[6] fork ended          // run next statement
[7] thread 2
[11] thread 3

if disable_fork
[1] fork started
[3] thread 2
[6] thread 1            // unfinished child threads will terminate immediately after thread 1 is done
[6] fork ended

module tb_fork_join_none;
[1] fork started
[1] fork ended          // for_none immediately unblocks
[3] thread 2            // for_none start running
[6] thread 1
[7] thread 2
[11] thread 3

module tb_fork_join_any_wait;
[2] thread 2
[5] thread 1
[6] thread 2
[7] thread 5
[10] thread 3
[10] thread 4
[11] thread 5
[15] thread 6
[15] fork ended

*/

// (1) -> (2) 3 threads -> (3)
module tb_fork_join;
    initial begin                                       // run sequentially
        #1 $display("[%0t] fork started", $time);       // (1)

        fork                                            // (2) all threads run in parallel
            #5 $display("[%0t] thread 1", $time);       // thread 1

            begin                                       // run sequentially
                #2 $display("[%0t] thread 2", $time);   // thread 2 expression 1
                #4 $display("[%0t] thread 2", $time);   // thread 2 expression 2
            end

            #10 $display("[%0t] thread 3", $time);      // thread 3
        join

        $display("[%0t] fork ended", $time);            // (3)
    end 
endmodule

// join_any unblocks when any of the child element ends, here "thread 1" ends first
// immmediately "for ended" runs
// however, the child elements inside the fork continues to run until all of them are done
//  since for_any unblocks immediately, we can disable fork when any thread is done
//  in this case, the remaining child elemnents will not run
module tb_fork_join_any;
    initial begin                                       // run sequentially
        #1 $display("[%0t] fork started", $time);       // (1)

        fork                                            // (2) all threads run in parallel
            #5 $display("[%0t] thread 1", $time);       // thread 1

            begin                                       // run sequentially
                #2 $display("[%0t] thread 2", $time);   // thread 2 expression 1
                #4 $display("[%0t] thread 2", $time);   // thread 2 expression 2
            end

            #10 $display("[%0t] thread 3", $time);      // thread 3
        join_any

        $display("[%0t] fork ended", $time);            // (3)

        //disable fork;
    end 
endmodule

// for_none immediately unblocks
module tb_fork_join_none;
    initial begin                                       // run sequentially
        #1 $display("[%0t] fork started", $time);       // (1)

        fork                                            // (2) all threads run in parallel
            #5 $display("[%0t] thread 1", $time);       // thread 1

            begin                                       // run sequentially
                #2 $display("[%0t] thread 2", $time);   // thread 2 expression 1
                #4 $display("[%0t] thread 2", $time);   // thread 2 expression 2
            end

            #10 $display("[%0t] thread 3", $time);      // thread 3
        join_none

        $display("[%0t] fork ended", $time);            // (3)
    end 
endmodule

// wait for all child threads in all forks are done
module tb_fork_join_any_wait;
    initial begin                                       // run sequentially

        fork                                            // all threads run in parallel
            #5 $display("[%0t] thread 1", $time);       // thread 1

            begin                                       // run sequentially
                #2 $display("[%0t] thread 2", $time);   // thread 2 expression 1
                #4 $display("[%0t] thread 2", $time);   // thread 2 expression 2
            end

            #10 $display("[%0t] thread 3", $time);      // thread 3
        join_any
        
        fork                                            // all threads run in parallel
            #5 $display("[%0t] thread 4", $time);       // thread 4

            begin                                       // run sequentially
                #2 $display("[%0t] thread 5", $time);   // thread 5 expression 1
                #4 $display("[%0t] thread 5", $time);   // thread 5 expression 2
            end

            #10 $display("[%0t] thread 6", $time);      // thread 6
        join_any

        wait fork;                                      // wait for all child threads are done for all forks

        $display("[%0t] fork ended", $time);            // (3)
    end 
endmodule
