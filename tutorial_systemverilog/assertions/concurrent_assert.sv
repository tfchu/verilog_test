/**
note: 
the result matches the lecture description, but does not match lecture result!! not sure why!! 

(1) assert property (@(posedge clk) a & b);
both signals a, b are expected to be 1 at clock posedge
the assertion is expected to fail for all instances when a or b = 0

[10] a=0 b=0
"testbench.sv", 19: tb.unnamed$$_3: started at 10ns failed at 10ns
	Offending '(a & b)'
[30] a=0 b=1
"testbench.sv", 19: tb.unnamed$$_3: started at 30ns failed at 30ns
	Offending '(a & b)'
[50] a=0 b=1
"testbench.sv", 19: tb.unnamed$$_3: started at 50ns failed at 50ns
	Offending '(a & b)'
[70] a=1 b=1
"testbench.sv", 19: tb.unnamed$$_3: started at 70ns failed at 70ns
	Offending '(a & b)'
[90] a=0 b=1
[110] a=0 b=1
"testbench.sv", 19: tb.unnamed$$_3: started at 110ns failed at 110ns
	Offending '(a & b)'
[130] a=0 b=1
"testbench.sv", 19: tb.unnamed$$_3: started at 130ns failed at 130ns
	Offending '(a & b)'
[150] a=1 b=0
"testbench.sv", 19: tb.unnamed$$_3: started at 150ns failed at 150ns
	Offending '(a & b)'
[170] a=0 b=1
"testbench.sv", 19: tb.unnamed$$_3: started at 170ns failed at 170ns
	Offending '(a & b)'
[190] a=0 b=1
"testbench.sv", 19: tb.unnamed$$_3: started at 190ns failed at 190ns
	Offending '(a & b)'

summary
time    a   b   assert (Check a, b @ previous clk edge/time)
10      0   0   fail
30      0   1   fail
50      0   1   fail
70      1   1   fail
90      0   1   pass as sampling is done as "preponed" region (before clk edge), a, b = 1 from time 70 to right before 90
110     0   1   fail
130     0   1   fail
150     1   0   fail
170     0   1   fail
190     0   1   fail


(2) assert property (@(posedge clk) a | b);
either a, b = 1 or both a, b = 1 are expected to be 1 at clock posedge
the assertion is expected to fail for all instances when both a and b = 0
[10] a=0 b=0
"testbench.sv", 19: tb.unnamed$$_3: started at 10ns failed at 10ns
	Offending '(a | b)'
[30] a=0 b=1
"testbench.sv", 19: tb.unnamed$$_3: started at 30ns failed at 30ns
	Offending '(a | b)'
[50] a=0 b=1
[70] a=1 b=1
[90] a=0 b=1
[110] a=0 b=1
[130] a=0 b=1
[150] a=1 b=0
[170] a=0 b=1
[190] a=0 b=1

summary
time    a   b   assert (check a, b @ previous clk edge/time)
10      0   0   fail as both a, b = 0 at preponed region (before clk edge)
30      0   1   fail as both a, b = 0 at preponed region (before clk edge)
50      0   1   pass as b = 1 at preponed region
70      1   1   pass
90      0   1   pass
110     0   1   pass
130     0   1   pass
150     1   0   pass
170     0   1   pass
190     0   1   pass

(3) assert property (@(posedge clk) !(a ^ b));
[10] a=0 b=0
[30] a=0 b=1
[50] a=0 b=1
"testbench.sv", 19: tb.unnamed$$_3: started at 50ns failed at 50ns
	Offending '(!(a ^ b))'
[70] a=1 b=1
"testbench.sv", 19: tb.unnamed$$_3: started at 70ns failed at 70ns
	Offending '(!(a ^ b))'
[90] a=0 b=1
[110] a=0 b=1
"testbench.sv", 19: tb.unnamed$$_3: started at 110ns failed at 110ns
	Offending '(!(a ^ b))'
[130] a=0 b=1
"testbench.sv", 19: tb.unnamed$$_3: started at 130ns failed at 130ns
	Offending '(!(a ^ b))'
[150] a=1 b=0
"testbench.sv", 19: tb.unnamed$$_3: started at 150ns failed at 150ns
	Offending '(!(a ^ b))'
[170] a=0 b=1
"testbench.sv", 19: tb.unnamed$$_3: started at 170ns failed at 170ns
	Offending '(!(a ^ b))'
[190] a=0 b=1
"testbench.sv", 19: tb.unnamed$$_3: started at 190ns failed at 190ns
	Offending '(!(a ^ b))'

summary
time    a   b   !(a ^ b)    assert (check a, b @ previous clk edge/time)
10      0   0   1           pass as a, b = 0 at preponed region (before clk edge)
30      0   1   0           pass as a, b = 0 at preponed region (before clk edge)
50      0   1   0           fail as b = 1 at prepone region
70      1   1   1           fail
90      0   1   0           pass as a, b = 1 at preponed region (before clk edge)
110     0   1   0           fail
130     0   1   0           fail
150     1   0   0           fail
170     0   1   0           fail
190     0   1   0           fail
*/

module tb;

    bit a, b;
    bit clk;

    always #10 clk = ~clk;

    initial begin
        for (int i = 0; i < 10; i++) begin
            @(posedge clk);
            {a, b} = $random;
            $display("[%0t] a=%0b b=%0b", $time, a, b);
        end
        #10 $finish;
    end

    assert property (@(posedge clk) a & b);     // pass if a, b = 1, fail otherwise
    //assert property (@(posedge clk) a | b);     // fail if a, b = 1, pass otherwise
    //assert property (@(posedge clk) !(a ^ b));  // fail if either a or b = 1

endmodule
