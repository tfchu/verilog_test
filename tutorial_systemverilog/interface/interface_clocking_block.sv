/**

clocking block
- specify timing and synchronization for a group of signals 

# KERNEL: [0] gnt=x req=x
# KERNEL: [10] gnt=0 req=x
# KERNEL: [15] gnt=0 req=0
# KERNEL: [75] gnt=0 req=1
# KERNEL: [90] gnt=1 req=1
# KERNEL: [155] gnt=1 req=0
# KERNEL: [170] gnt=0 req=0
# KERNEL: [235] gnt=0 req=1
# KERNEL: [250] gnt=1 req=1
# KERNEL: [315] gnt=1 req=0
# KERNEL: [330] gnt=0 req=0
# KERNEL: [395] gnt=0 req=1
# KERNEL: [410] gnt=1 req=1
# KERNEL: [475] gnt=1 req=0
# KERNEL: [490] gnt=0 req=0
# KERNEL: [555] gnt=0 req=1
# KERNEL: [570] gnt=1 req=1
# KERNEL: [635] gnt=1 req=0
# KERNEL: [650] gnt=0 req=0
# KERNEL: [715] gnt=0 req=1
# KERNEL: [730] gnt=1 req=1
# KERNEL: [795] gnt=1 req=0

*/


interface my_if (input bit clk);

    logic gnt;      // grant
    logic req;      // request

    // clocking block - gnt before 1ns of clk posedge, req after 5 tu of clk posedge
    clocking cb @(posedge clk);
        input #1ns gnt; // gnt is 1ns before clk posedge (SETUP TIME)
        output #5 req;  // req is 5tu (5ns here) after clk posedge (HOLD TIME)
    endclocking

endinterface

module my_design (
    input req, clk,
    output reg gnt
);
    always @(posedge clk)
        if (req)
            gnt <= 1;
        else
            gnt <= 0;
endmodule

module tb;
    bit clk;

    always #10 clk = ~clk;
    my_if if0 (.clk (clk));

    initial begin
        clk <= 0;
        if0.cb.req <= 0;
    end

    my_design md0 (
        .clk(clk), 
        .req(if0.req),
        .gnt(if0.gnt)
    );

    // stimulus
    initial begin
        $dumpfile("dump.vcd");      // waveform
      	$dumpvars;
        // if0.cb.req, if0.cb.gnt won't work as cannot be read, what about $monitor in for loop? 
        $monitor("[%0t] gnt=%0b req=%0b", $time, md0.gnt, md0.req);
        for (int i = 0; i < 10; i++) begin
            bit[3:0] delay = $random;
            repeat (delay) @(posedge if0.clk);
            // original if0.cb.req <= ~if0.cb.req; won't work as if0.cb.req cannot be read
            if0.cb.req <= ~md0.req; 
        end
        #20 $finish;
    end
endmodule;