/**
semaphore: a key to shared resource, get key (get(1)) -> no one else get can it -> return key (put(1)) -> anyone can get the key again

module tb_semaphore;
key = new (1);          // only 1 key
[0] trying to get the key for person a
[0] key got for person a
[5] trying to get the key for person b
[20] returning the key for person a
[20] key put for person a
[20] key got for person b
[25] trying to get the key for person a
[30] returning the key for person b
[30] key put for person b
[30] key got for person a
[50] returning the key for person a
[50] key put for person a

key = new (2);          // 2 keys, so person_a and person_b can get simultaneously
[0] trying to get the key for person a
[0] key got for person a
[5] trying to get the key for person b
[5] key got for person b
[15] returning the key for person b
[15] key put for person b
[20] returning the key for person a
[20] key put for person a
[25] trying to get the key for person a
[25] key got for person a
[45] returning the key for person a
[45] key put for person a
*/

module tb_semaphore;

    semaphore key;

    initial begin
        key = new (1);      // create a new key

        fork                // multiple threads (e.g. person) to use the key
            person_a();
            person_b();     // the moment person_a puts the key, person_b gets the key
            #25 person_a(); // the moment person_b puts the key, person_a gets the key again
        join
    end

    task get_room(string id);
        $display("[%0t] trying to get the key for person %s", $time, id);
        key.get(1);                                         // get the semaphore key
        $display("[%0t] key got for person %s", $time, id);
    endtask

    task put_room(string id);
        $display("[%0t] returning the key for person %s", $time, id);
        key.put(1);                                         // get the semaphore key
        $display("[%0t] key put for person %s", $time, id);        
    endtask

    task person_a();
        get_room("a");
        #20 put_room("a");
    endtask

    task person_b();            // expressions run sequentially, i.e. #10 delay after 1st line
        #5 get_room("b");   
        #10 put_room("b");
    endtask  

endmodule