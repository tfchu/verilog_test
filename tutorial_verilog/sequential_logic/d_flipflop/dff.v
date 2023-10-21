/**
D flip-flop
- negedge rstn -> q = 0
- posedge clk -> q <= d

output
# KERNEL: [0] clk=0 rstn=0x0 d=0x0 q=0x0 qb=0x1
# KERNEL: [10] clk=1 rstn=0x0 d=0x0 q=0x0 qb=0x1
# KERNEL: [15] clk=1 rstn=0x0 d=0x1 q=0x0 qb=0x1
# KERNEL: [20] clk=0 rstn=0x0 d=0x1 q=0x0 qb=0x1
# KERNEL: [25] clk=0 rstn=0x1 d=0x1 q=0x0 qb=0x1
# KERNEL: [29] clk=0 rstn=0x1 d=0x0 q=0x0 qb=0x1
# KERNEL: [30] clk=1 rstn=0x1 d=0x1 q=0x1 qb=0x0
# KERNEL: [31] clk=1 rstn=0x1 d=0x0 q=0x1 qb=0x0
# KERNEL: [34] clk=1 rstn=0x1 d=0x1 q=0x1 qb=0x0
# KERNEL: [39] clk=1 rstn=0x1 d=0x0 q=0x1 qb=0x0
# KERNEL: [40] clk=0 rstn=0x1 d=0x0 q=0x1 qb=0x0
**/
// 
// 
// On posedge of CLK (and reset = 0), Q = D
module dff (clk, rstn, d, q, qb);
    input      clk;
    input      rstn;
    input      d;
    output     q;
    output     qb;

    reg        q, qb;
    assign     qb = ~q;

    always @(posedge clk or negedge rstn)
    begin
        if (!rstn) begin
            // Asynchronous reset when reset goes low
            q <= 1'b0;
        end else begin
            // Assign D to Q on positive clock edge
            q <= d;
        end
    end
endmodule

// new syntax
module dff (input clk, input rstn, input d, output reg q, output reg qb);
    assign qb = ~q;

    // this does not have begin ... end (tchu: probably just 1 line for each condition?)
    always @(posedge clk or negedge rstn)
        if (!rstn)
            q <= 1'b0;
        else
            q <= d;
endmodule

// use `include "design.v" if under different folders
module tb_dff();

    reg clk;
    reg rstn;
    reg d;
    wire q, qb;
    reg [2:0] delay;

    dff dff0(.clk(clk), .rstn(rstn), .d(d), .q(q), .qb(qb));

    always #10 clk <= ~clk;

    initial begin
        $dumpfile("dump.vcd");$dumpvars(1);

        $monitor ("[%0t] clk=%1b rstn=0x%0h d=0x%0h q=0x%0h qb=0x%0h", $time, clk, rstn, d, q, qb);

        clk <= 0;
        rstn <= 0;
        d <= 0;

        #15 d <= 1;
        #10 rstn <= 1;
        for (int i = 0; i < 5; i=i+1) begin
            delay = $random;
            $display(delay);
            #(delay) d <= i;
        end

        #5 $finish;

        // #10 rstn <= 1;
        // #5 d <= 1;
        // #8 d <= 0;
        // #2 d <= 1;
        // #10 d <= 0;
    end

endmodule

// older tb
module tb_dff2;

    reg clk;
    reg rstn;
    reg d;
    wire q;
    wire qb;
    
    // Instantiate design under test
    dff dff0(.clk(clk), .rstn(rstn),
            .d(d), .q(q), .qb(qb));
            
    initial begin
        // Dump waves
        $dumpfile("dump.vcd");
        $dumpvars(1);
        
        $display("Reset flop.");
        clk = 0;
        reset = 1;
        d = 1'bx;
        display;
        
        $display("Release reset.");
        d = 1;
        reset = 0;
        display;

        $display("Toggle clk.");
        clk = 1;
        display;
    end
    
    task display;
        #1 $display("d:%0h, q:%0h, qb:%0h",
        d, q, qb);
    endtask

endmodule