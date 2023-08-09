/**
demo clocking block and modport

output
# KERNEL: time = 0, cb.ack=x
# KERNEL: time = 0, ack=0
# KERNEL: time = 2, cb.ack=0
# KERNEL: time = 10, ack=1
# KERNEL: time = 14, cb.ack=1
# KERNEL: time = 15: a=  5 b=  6, out=   30
# KERNEL: time = 15: a=  5 b=  6, out=   30
# KERNEL: time = 22, ack=0
# KERNEL: time = 26, cb.ack=0
# KERNEL: time = 50, ack=1
# KERNEL: time = 51: a= 20 b=  7, out=  140
# KERNEL: time = 54: a= 20 b=  7, out=  140
# KERNEL: time = 54, cb.ack=1
# KERNEL: time = 58, ack=0
# KERNEL: time = 62, cb.ack=0
# KERNEL: time = 90: a= 10 b=  4, out=  140
# KERNEL: time = 90, ack=1
# KERNEL: time = 94: a= 10 b=  4, out=   40
# KERNEL: time = 94, ack=0
# KERNEL: time = 94, cb.ack=1
# KERNEL: time = 98, cb.ack=0

*/

// IF
/*
TB                      DUT
   | <-- clk     --> |
   | <-- reset   --> |
   | --> a       --> |
   | --> b       --> |
   | --> en      --> |
   | <-- out     <-- |
   | <-- ack     <-- |
*/
interface mult_if (input logic clk, reset);
    logic [7:0] a, b;
    logic [15:0] out;
    logic en;
    logic ack;
    
    // internal signals is sampled/driven based on clocking event
    clocking cb @(posedge clk);
        default input #1 output #2;     // input is sampled #1 before posedge, output is driven #2 after posedge 
        input out, ack;
        output a, b, en;
    endclocking
    
    modport TB (clocking cb, input clk, reset);
    modport RTL (input clk, reset, a,b, en, output out, ack);
endinterface

// DUT
module multiplier(mult_if.RTL inf);
    always@(posedge inf.clk or posedge inf.reset) begin 
        if(inf.reset) begin 
            inf.out <= 0;
            inf.ack <= 0;
        end else if(inf.en) begin
            inf.out <= inf.a * inf.b;
            inf.ack <= 1;
        end else inf.ack <= 0;
    end
endmodule

// TB
module tb_top;
    bit clk;
    bit reset;
    
    always #2 clk = ~clk;       // toggle clock every 2 tu
    
    initial begin
        clk = 0;
        reset = 1;
        #2;
        reset = 0;
    end 
    
    mult_if inf(clk, reset);
    multiplier DUT(inf);
    
    // <vif>.<modport>.<clocking_block>
    `define TB_IF inf.TB.cb
    
    initial begin
        #5;
        `TB_IF.a <= 'd5; `TB_IF.b <= 'd6;   // output signals to drive
        `TB_IF.en <= 1;                     // output signals to drive
        #10 `TB_IF.en <= 0;
        $display("time = %0t: a=%d b=%d, out=%d", $time, inf.a,inf.b,inf.out);
        wait(`TB_IF.ack);                   // `TB_IF is already 1, so no wait
        $display("time = %0t: a=%d b=%d, out=%d", $time, inf.a,inf.b,inf.out);
        
        #25;
        `TB_IF.a <= 'd20; `TB_IF.b <= 'd7;
        #5ns `TB_IF.en <= 1;
        #6 `TB_IF.en <= 0;
        $display("time = %0t: a=%d b=%d, out=%d", $time, inf.a,inf.b,inf.out);
        wait(`TB_IF.ack);
        $display("time = %0t: a=%d b=%d, out=%d", $time, inf.a,inf.b,inf.out);
        
        #25;
        `TB_IF.a <= 'd10; `TB_IF.b <= 'd4;
        #6ns `TB_IF.en <= 1;
        #5 `TB_IF.en <= 0;
        $display("time = %0t: a=%d b=%d, out=%d", $time, inf.a,inf.b,inf.out);
        wait(`TB_IF.ack);
        $display("time = %0t: a=%d b=%d, out=%d", $time, inf.a,inf.b,inf.out);

        #10;
        $finish;
    end

    initial begin 
        $monitor("time = %0t, cb.ack=%d", $time, `TB_IF.ack);
        $monitor("time = %0t, ack=%d", $time, inf.ack);
        //$monitor("time = %0t, cb.a=%d", $time, `TB_IF.a);
        //$monitor("time = %0t, a=%d", $time, inf.a);
        $dumpfile("dump.vcd"); $dumpvars;
    end
endmodule