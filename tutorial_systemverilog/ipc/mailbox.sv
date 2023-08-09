/**
mailbox: 
generator generates desired data -> put into the mailbox -> driver retrieves the data from mailbox -> drive the signal onto the bus

module tb_mailbox;
[0] [driver] retrieving data from mailbox
[10] data = 0x28
[10] [generator] putting data into mailbox
[10] [generator] data put into mailbox
[10] [driver] data got from mailbox

*/



class transactions;
    rand bit [7:0] data;

    function display();
        $display("[%0t] data = 0x%0h", $time, data);
    endfunction
endclass

// generate the data pattern to driver
class generator;
    mailbox mbx;

    function new(mailbox mbx);
        this.mbx = mbx;
    endfunction //new()

    task gen_data();
        transactions trns = new();
        trns.randomize();
        trns.display();                 // display randomized data
        $display("[%0t] [generator] putting data into mailbox", $time);
        this.mbx.put(trns);
        $display("[%0t] [generator] data put into mailbox", $time);
    endtask
endclass //generator

// driver gets the data pattern from the generator, then uses it to drive the bus
class driver;
    mailbox mbx;

    function new(mailbox mbx);
        this.mbx = mbx;
    endfunction //new()

    task drive_data();
        transactions trns = new();
        $display("[%0t] [driver] retrieving data from mailbox", $time);
        this.mbx.get(trns);
        $display("[%0t] [driver] data got from mailbox", $time); 
    endtask
endclass //driver

// main testbench
module tb_mailbox;
    mailbox mbx;
    generator gen;
    driver drv;

    initial begin
        mbx = new();
        gen = new(mbx);
        drv = new(mbx);

        fork                        // run in parallel
            #10 gen.gen_data();     // data generated at #10
            drv.drive_data();       // immediately tries to retrieve data and blocked until #10 (mbox has the data)
        join
    end
endmodule