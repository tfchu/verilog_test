/**

*/

interface my_if(input bit clk);
    logic gnt;
    logic req;

    // clocking block
    clocking cb0 @(posedge clk);
        output #0 req;
    endclocking
    
    clocking cb1 @(posedge clk);
        output #2 req;
    endclocking
    
    clocking cb2 @(posedge clk);
        output #5 req;
    endclocking
endinterface

module tb;

    bit clk;
    always #10 clk = ~clk;

    initial begin
        clk <= 0;
        if0.req <= 0;
    end

    my_if if0(.clk(clk));

    initial begin
        $dumpfile("dump.vcd");      // waveform
      	$dumpvars;
        for (int i = 0; i < 3; i++) begin
            repeat (2) @(if0.cb0);      // repeat 2 clk posedge
            case (i)                    // then set req based on i
                0: if0.cb0.req <= 1;
                1: if0.cb1.req <= 1;
                2: if0.cb2.req <= 1;
            endcase
            repeat (2) @(if0.cb0);      // repeat another 2 clk posedge
            if0.req <= 0;               // then reset req
        end
        #20 $finish;
    end
    
endmodule