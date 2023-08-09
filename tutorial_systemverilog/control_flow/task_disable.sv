/**

module tb_disable_task1;
[0] DISPLAY1 started
[60] DISPLAY2 started
[80] DISPLAY2 ended

module tb_disable_task2;
[0] DISPLAY1 started
*/

/**
#0: 1st display() shows "DISPLAY1 started", then start waiting for #100
#50: block DISPLAY1 is disabled, so the block is terminated, and DISPALY2 runs
#60: #10 later, "DISPLAY2 started"
#80: #20 later, "DISPLAY2 ended"
*/
module tb_disable_task1;

    initial display();

    initial begin
        #50 disable display.DISPLAY1;       // disable the named block
    end

    task display();
        begin : DISPLAY1
            $display("[%0t] DISPLAY1 started", $time);
            #100; 
            $display("[%0t] DISPLAY1 ended", $time);
        end
        begin : DISPLAY2
            #10;
            $display("[%0t] DISPLAY2 started", $time);
            #20; 
            $display("[%0t] DISPLAY2 ended", $time);
        end
    endtask        

endmodule

// this disables the entire task, so only "DISPLAY1 started" is shown
module tb_disable_task2;

    initial display();

    initial begin
        #50 disable display;                // disable the entire task
    end

    task display();
        begin : DISPLAY1
            $display("[%0t] DISPLAY1 started", $time);
            #100; 
            $display("[%0t] DISPLAY1 ended", $time);
        end
        begin : DISPLAY2
            #10;
            $display("[%0t] DISPLAY2 started", $time);
            #20; 
            $display("[%0t] DISPLAY2 ended", $time);
        end
    endtask        

endmodule