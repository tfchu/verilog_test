/**


time = 10, cb0.gnt = 0xd
time = 10, cb1.gnt = 0x1
time = 10, cb2.gnt = 0x1
time = 10, cb3.gnt = 0x2

*/

module my_design (output reg [3:0] gnt);
    always #1 gnt <= $random;
endmodule

interface my_if (input bit clk);
    logic [3:0] gnt;

    // clocking block
    clocking cb0 @(posedge clk);
        input #0 gnt;
    endclocking

    clocking cb1 @(posedge clk);
        input #1step gnt;
    endclocking

    clocking cb2 @(posedge clk);
        input #1 gnt;
    endclocking

    clocking cb3 @(posedge clk);
        input #2 gnt;
    endclocking
endinterface

module tb;
    bit clk;
    always #10 clk = ~clk;
    initial clk <= 0;

    my_if if0 (.clk(clk));
    my_design md0(.gnt (if0.gnt));

    initial begin
        $dumpfile("dump.vcd");      // waveform
      	$dumpvars;
        fork
            begin
                @(if0.cb0);
                $display("time = %0t, cb0.gnt = 0x%0h", $time, if0.cb0.gnt);
            end
            begin
                @(if0.cb1);
                $display("time = %0t, cb1.gnt = 0x%0h", $time, if0.cb1.gnt);
            end
            begin
                @(if0.cb2);
                $display("time = %0t, cb2.gnt = 0x%0h", $time, if0.cb2.gnt);
            end
            begin
                @(if0.cb3);
                $display("time = %0t, cb3.gnt = 0x%0h", $time, if0.cb3.gnt);
            end
        join
        #10 $finish;
    end

endmodule