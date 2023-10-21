/**
https://www.fpga4fun.com/CrossClockDomain.html
https://www.fpga4fun.com/CrossClockDomain1.html

# KERNEL: 0 sig_in=0 sig_out=x
# KERNEL: 3 sig_in=1 sig_out=x
# KERNEL: 6 sig_in=1 sig_out=0
# KERNEL: 7 sig_in=0 sig_out=0      // sig_in toggle every 4 tu
# KERNEL: 10 sig_in=0 sig_out=1     // sig_out lags sig_in by 7 tu
# KERNEL: 11 sig_in=1 sig_out=1
# KERNEL: 14 sig_in=1 sig_out=0     // sig_out toggle every 4 tu
# KERNEL: 15 sig_in=0 sig_out=0
# KERNEL: 18 sig_in=0 sig_out=1
# KERNEL: 19 sig_in=1 sig_out=1
# KERNEL: 22 sig_in=1 sig_out=0
# KERNEL: 23 sig_in=0 sig_out=0
**/

module Signal_CrossDomain(
    input clkA,   // we actually don't need clkA in that example, but it is here for completeness as we'll need it in further examples
    input SignalIn_clkA,
    input clkB,
    output SignalOut_clkB
);

    // We use a two-stages shift-register to synchronize SignalIn_clkA to the clkB clock domain
    /*
    SignalIn_clkA -> | FF | -> SyncA_clkB[0] -> | FF | -> SyncA_clkB[1] -> SignalOut_clkB
                    0 1  2  3  4  5  6  7  8  9  0  1  2  3  4  5  6  
                      a1    a2    a3    a4    a5    a6    a7    a8
    clkA            __|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__ ...
                         b1          b2          b3          b4
    clkB            _____|‾‾‾‾‾|_____|‾‾‾‾‾|_____|‾‾‾‾‾|_____|‾‾‾‾‾|__ ...
    SignalIn_clkA   ________|‾‾‾‾‾‾‾‾‾‾‾|___________|‾‾‾‾‾‾‾‾‾‾‾|_____ ...
    SyncA_clkB[0]   _________________|‾‾‾‾‾‾‾‾‾‾‾|___________|‾‾‾‾‾‾‾‾ ...
    SignalOut_clkB  _____________________________|‾‾‾‾‾‾‾‾‾‾‾|________ ... // SyncA_clkB[1], lag SignalIn_clkA by 7 tu

    t               b1  b2  b3  b4
    SignalIn_clkA   0   1   0   1
    SyncA_clkB[0]   x   1   0   1       // SignalIn_clkA upon posedge clkB, assign at the end of clkB cycle
    SyncA_clkB[1]   x   0   1   0       // SyncA_clkB[0] upon posedge clkB, assign at the end of clkB cycle
    */
    reg [1:0] SyncA_clkB;
    always @(posedge clkB) SyncA_clkB[0] <= SignalIn_clkA;   // notice that we use clkB
    always @(posedge clkB) SyncA_clkB[1] <= SyncA_clkB[0];   // notice that we use clkB

    assign SignalOut_clkB = SyncA_clkB[1];  // new signal synchronized to (=ready to be used in) clkB domain
endmodule

module tb;
    logic clkA = 0, clkB = 0, sig_in = 0, sig_out;      // sig_out cannot be init to 0
    int count = 0;

    Signal_CrossDomain sc
    (
        .clkA (clkA), 
        .clkB (clkB), 
        .SignalIn_clkA (sig_in), 
        .SignalOut_clkB (sig_out)
    );

    always #1 clkA = ~clkA;
    always #2 clkB = ~clkB;

    // sig_in is synchronized to clkA
    always @(posedge clkA) begin
        count = count + 1;
        if (count == 2) begin   // toggle every 2 clkA cycles
            sig_in = ~sig_in;
            count = 0;
        end
    end

    initial begin
        $dumpfile("dump.vcd"); $dumpvars(1);
        $monitor("%g sig_in=%b sig_out=%b", $time, sig_in, sig_out);
        #25 $finish;
    end
endmodule