/**
module tb_delay;

@(posedge clk) a ##2 b;
- if a=0, then sequence starts and fails at the same cycle
- if a=1, then assertion starts and passes if b=1 two cycles after a, fails otherwise. 

[10] a=0 b=1
"testbench.sv", 11: tb.unnamed$$_0: started at 10ns failed at 10ns
	Offending 'a'
[30] a=1 b=1
"testbench.sv", 11: tb.unnamed$$_0: started at 30ns failed at 30ns
	Offending 'a'
[50] a=1 b=1
[70] a=1 b=0
[90] a=1 b=1
"testbench.sv", 11: tb.unnamed$$_0: started at 50ns failed at 90ns
	Offending 'b'
[110] a=0 b=1
[110] assertion passed!
[130] a=1 b=0
"testbench.sv", 11: tb.unnamed$$_0: started at 130ns failed at 130ns
	Offending 'a'
[130] assertion passed!
[150] a=1 b=0
"testbench.sv", 11: tb.unnamed$$_0: started at 110ns failed at 150ns
	Offending 'b'
[170] a=1 b=0
[190] a=1 b=1
"testbench.sv", 11: tb.unnamed$$_0: started at 150ns failed at 190ns
	Offending 'b'


a   ________|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|_____|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
b   __|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|_____|‾‾‾‾‾‾‾‾‾‾‾|_________________|‾‾‾‾‾
clk __|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|‾‾|__|
t     10    30    50    70    90    110   130   150   170   190   210 

t   a   b   s_ab*   note 
10  0   1   no      assert fail (a=0)
30  1   1   yes     assert fail (a=0 preponed region)
50  1   1   yes     assert start
70  1   0   yes     assert start
90  1   1   yes     assert start, assert fail (a=1 @t=50, b=0 @t=90 preponed region)
110 0   1   no      assert start, assert pass (a=1 @t=70, b=1 @t=110)
130 1   0   yes     assert fail (a=0), assert pass (a=1 @t=90, b=1 @t=130)
150 1   0   yes     assert start, assert fail (a=1 @t=110, b=0 @t=150 preponed region)
170 1   0   yes     assert start
190 1   1   yes     assert fail (a=1 @t=150, b=0 @t=190 preponed region)

note
s_ab*: s_ab starts (a=1) or not
pay attention to started and failed time. for sequential checks, these may be different. 

*/

module tb_delay;
    bit a, b;
    bit clk;

    sequence s_ab;
        @(posedge clk) a ##2 b;
    endsequence

    assert property(s_ab)
        $display("[%0t] assertion passed!", $time);

    always #10 clk = ~clk;

    initial begin
        for (int i = 0; i < 10; i++) begin
            @(posedge clk);
            {a, b} = $random;

            $display("[%0t] a=%0b b=%0b", $time, a, b);
        end
        #20 $finish;
    end
endmodule