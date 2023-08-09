/**

module tb_simple;
assert pass if a=1 on clk posedge, fail otherwise (a=0)

[10] a = 0
"testbench.sv", 11: tb.unnamed$$_0: started at 10ns failed at 10ns
	Offending 'a'
[30] a = 1
[50] a = 1
[70] a = 1
[90] a = 1
[110] a = 1
[130] a = 1
[150] a = 0
"testbench.sv", 11: tb.unnamed$$_0: started at 150ns failed at 150ns
	Offending 'a'
[170] a = 1
[190] a = 1

a   __|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|_____|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
clk __|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|
t     10    30    50    70    90    110   130   150   170   190   210 

note. 
- a value is determined at the preponed region (right before clk edge) of clk posedge
- simulation ends at t = 210, for loop 0 ~ 190, #20 extra 20 t.u.

a=0 @t=10, so assert fails
a=1 @t=30, so assert passese. note. a goes high @t=10. if a goes high @t=30, then a is considered 0 due to sampling at clk preponed region
...
a=0 @t=150, so assert fails


module tb_rose;
assert passes if "a" value on a rise (0 -> 1) on 2 consecutive clk posedge

[10] a = 0
"testbench.sv", 11: tb_rose.unnamed$$_0: started at 10ns failed at 10ns
	Offending '$rose(a)'
[30] a = 1
[50] a = 1
"testbench.sv", 11: tb_rose.unnamed$$_0: started at 50ns failed at 50ns
	Offending '$rose(a)'
[70] a = 1
"testbench.sv", 11: tb_rose.unnamed$$_0: started at 70ns failed at 70ns
	Offending '$rose(a)'
[90] a = 1
"testbench.sv", 11: tb_rose.unnamed$$_0: started at 90ns failed at 90ns
	Offending '$rose(a)'
[110] a = 1
"testbench.sv", 11: tb_rose.unnamed$$_0: started at 110ns failed at 110ns
	Offending '$rose(a)'
[130] a = 1
"testbench.sv", 11: tb_rose.unnamed$$_0: started at 130ns failed at 130ns
	Offending '$rose(a)'
[150] a = 0
"testbench.sv", 11: tb_rose.unnamed$$_0: started at 150ns failed at 150ns
	Offending '$rose(a)'
[170] a = 1
[190] a = 1
"testbench.sv", 11: tb_rose.unnamed$$_0: started at 190ns failed at 190ns
	Offending '$rose(a)'

a   __|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|_____|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
clk __|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|
t     10    30    50    70    90    110   130   150   170   190   210 

a=0 @t=10
a=1 @t=30, "a" rose on 2 clk posedge (t=10 and t=30), so assert passes
...
a=0 @t=150
a=1 @t=170, "a" rose on 2 clk posedge (t=150 and t=170), so assert passes



module tb_fell;
assert passes if "a" value on a fall (1 -> 0) on 2 consecutive clk posedge

[10] a = 0
"testbench.sv", 11: tb_fell.unnamed$$_0: started at 10ns failed at 10ns
	Offending '$fell(a)'
[30] a = 1
"testbench.sv", 11: tb_fell.unnamed$$_0: started at 30ns failed at 30ns
	Offending '$fell(a)'
[50] a = 1
"testbench.sv", 11: tb_fell.unnamed$$_0: started at 50ns failed at 50ns
	Offending '$fell(a)'
[70] a = 1
"testbench.sv", 11: tb_fell.unnamed$$_0: started at 70ns failed at 70ns
	Offending '$fell(a)'
[90] a = 1
"testbench.sv", 11: tb_fell.unnamed$$_0: started at 90ns failed at 90ns
	Offending '$fell(a)'
[110] a = 1
"testbench.sv", 11: tb_fell.unnamed$$_0: started at 110ns failed at 110ns
	Offending '$fell(a)'
[130] a = 1
"testbench.sv", 11: tb_fell.unnamed$$_0: started at 130ns failed at 130ns
	Offending '$fell(a)'
[150] a = 0
[170] a = 1
"testbench.sv", 11: tb_fell.unnamed$$_0: started at 170ns failed at 170ns
	Offending '$fell(a)'
[190] a = 1
"testbench.sv", 11: tb_fell.unnamed$$_0: started at 190ns failed at 190ns
	Offending '$fell(a)'

a   __|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|_____|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
clk __|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|
t     10    30    50    70    90    110   130   150   170   190   210   

a=1 @t=130
a=0 @t=150, "a" fell on 2 clk posedge (t=130 and t=150), so assert passes


module tb_stable;
assert passes if "a" remains table (1 -> 1, or 0 -> 0) on 2 consecutive clk posedge

[10] a = 0
[30] a = 1
"testbench.sv", 11: tb_stable.unnamed$$_0: started at 30ns failed at 30ns
	Offending '$stable(a)'
[50] a = 1
[70] a = 1
[90] a = 1
[110] a = 1
[130] a = 1
[150] a = 0
"testbench.sv", 11: tb_stable.unnamed$$_0: started at 150ns failed at 150ns
	Offending '$stable(a)'
[170] a = 1
"testbench.sv", 11: tb_stable.unnamed$$_0: started at 170ns failed at 170ns
	Offending '$stable(a)'
[190] a = 1

a   __|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|_____|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
clk __|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|
t     10    30    50    70    90    110   130   150   170   190   210 

a=0 @t=10, strange that my result is pass but example is fail. should be fail as no 2 consecutive clk posedge
a=1 @t=30, 0->1 so assert fails
a=1 @t=50, 1->1 so assert passes
...
a=1 @t=130
a=0 @t=150, 1->0 so assert fails
a=1 @t=170, 0->1 so assert fails


note. comparison of waveforms
t   a
10  0
30  1
50  1   
70  1
90  1
110 1
130 1
150 0
170 1
190 1

a = $random;    // "a" first gets a random value
@(posedge clk); // then clk posedge happens. so "a" value is changed 1 clk posedge before
a   __|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|_____|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
clk __|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|
t     10    30    50    70    90    110   130   150   170   190   210 

@(posedge clk); // when clk posedge happends
a = $random;    // a gets a value. so "a" value is change upon clk posedge
a   ________|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|_____|‾‾‾‾‾‾‾‾‾‾‾
clk __|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|
t     10    30    50    70    90    110   130   150   170   190   210 

*/

// simple sequence
module tb_simple;
    bit a;
    bit clk;

    sequence s_a;
        @(posedge clk) a;
    endsequence

    assert property(s_a);

    always #10 clk = ~clk;

    initial begin
        for (int i = 0; i < 10; i++) begin
            a = $random;
            @(posedge clk);

            $display("[%0t] a = %0d", $time, a);
        end
        #20 $finish;
    end
endmodule

// sequence with $rose() system task
module tb_rose;
    bit a;
    bit clk;

    sequence s_a;
        @(posedge clk) $rose(a);
    endsequence

    assert property(s_a);

    always #10 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd"); $dumpvars;
        for (int i = 0; i < 10; i++) begin
            a = $random;
            @(posedge clk);

            $display("[%0t] a = %0d", $time, a);
        end
        #20 $finish;
    end
endmodule

// sequence with $fell() system task
module tb_fell;
    bit a;
    bit clk;

    sequence s_a;
        @(posedge clk) $fell(a);
    endsequence

    assert property(s_a);

    always #10 clk = ~clk;

    initial begin
        for (int i = 0; i < 10; i++) begin
            a = $random;
            @(posedge clk);

            $display("[%0t] a = %0d", $time, a);
        end
        #20 $finish;
    end
endmodule

// sequence with $stable() system task
module tb_stable;
    bit a;
    bit clk;

    sequence s_a;
        @(posedge clk) $stable(a);
    endsequence

    assert property(s_a);

    always #10 clk = ~clk;

    initial begin
        for (int i = 0; i < 10; i++) begin
            a = $random;
            @(posedge clk);

            $display("[%0t] a = %0d", $time, a);
        end
        #20 $finish;
    end
endmodule