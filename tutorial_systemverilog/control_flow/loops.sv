/**
module tb_repeat;
0, Hello!
0, Hello!
0, Hello!
0, Hello!
0, Hello!

module tb_while;
Counter = 1
Counter = 2
Counter = 3
Counter = 4
Counter = 5
Counter = 6
Counter = 7
Counter = 8
Counter = 9
Counter = 10

module tb_for;
Counter = 2
Counter = 3
Counter = 4
Counter = 5
Counter = 6
Counter = 7
Counter = 8
Counter = 9
Counter = 10
Counter = 11
Counter = 12
Counter = 13

module tb_do_while;
Counter = 1
Counter = 2
Counter = 3
Counter = 4
Counter = 5

module tb_foreach;
arr[0] = 0
arr[1] = 0
arr[2] = 0
arr[3] = 0
arr[4] = 0
arr[5] = 0
arr[6] = 0
arr[7] = 0

*/
module tb_repeat;
    initial begin
        repeat(5) begin
            $display("%g, Hello!", $time);
        end
    end
endmodule

module tb_while;
    bit clk;

    always #10 clk = ~clk;

    initial begin
        bit [3:0] counter;
        $dumpfile("dump.vcd");      // need to place after counter
      	$dumpvars;
          
        while(counter < 10) begin
            @(posedge clk);
            counter++;
            $display("Counter = %0d", counter);
        end
        $finish;
    end
endmodule

module tb_for;
    bit clk;

    always #10 clk = ~clk;

    initial begin
        bit [3:0] counter;
        $dumpfile("dump.vcd");      // need to place after counter
      	$dumpvars;
          
        for(counter = 2; counter < 14; counter++) begin
            @(posedge clk);
            $display("Counter = %0d", counter);
        end
        $finish;
    end
endmodule

module tb_do_while;
    bit clk;

    always #10 clk = ~clk;

    initial begin
        bit [3:0] counter;
        $dumpfile("dump.vcd");      // need to place after counter
      	$dumpvars;
          
        do begin
            @(posedge clk);
            counter++;
            $display("Counter = %0d", counter);
        end while (counter < 5);
        $finish;
    end
endmodule

module tb_foreach;
    bit [7:0]   arr [8];    // 8 arrays, each has 8 bits

    initial begin
        foreach (arr[i]) begin
            arr[i] = 0;
        end 
        foreach (arr[i]) begin
            $display("arr[%0d] = %0d", i, arr[i]);
        end
    
    end
endmodule