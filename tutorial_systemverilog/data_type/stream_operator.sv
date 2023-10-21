module tb();
    bit[31:0] q[$];
    bit[31:0] q1[$];
    bit[31:0] q2[$];
    bit[31:0] tmp;
    
    initial begin
        q.push_back(32'hdeadbeef);
        q.push_back(32'h01234567);

        /**
        q[0] = deadbeef
        q[1] = 01234567
        **/
        foreach (q[i])
            $display($sformatf("q[%0d] = %8h", i, q[i]));

        // stream operator <<8: (1) slice q[i] in 8-bit, (2) print the 8-bit from right to left
        foreach(q[i]) begin
        tmp = {<<8{q[i]}};        // <<byte also ok
        q[i] = tmp;
        end

        /**
        q[0] = efbeadde
        q[1] = 67452301
        **/
        foreach (q[i])
            $display($sformatf("q[%0d] = %8h", i, q[i]));

        /**
        q1[0] = 01234567
        q1[1] = deadbeef 
        q: |ef|be|ad|de|67|45|23|01| -> q1: |01|23|45|67|de|ad|be|ef|
        **/
        q1 = {<<8{q}};      // stream operator for entire q, (1) slice entire q in 8-bit, (2) print from right to left
        foreach (q1[i])
            $display($sformatf("q1[%0d] = %8h", i, q1[i]));     // since q1[x] is 32-bit, q[0] is 1st 32-bit value, q[1] is 2nd 32-bit value

        /**
        q2[0] = 01234567
        q2[1] = deadbeef
        q1: |01|23|45|67|de|ad|be|ef|
        **/
        q2 = {>>{q1}};      // no change
        foreach (q1[i])
            $display($sformatf("q2[%0d] = %8h", i, q2[i]));            
    end
endmodule