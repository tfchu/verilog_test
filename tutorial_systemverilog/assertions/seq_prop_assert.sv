/**

[0] a=0 b=1 c=0 d=0
[10] a=0 b=0 c=0 d=1
"testbench.sv", 30: tb_assert.unnamed$$_3: started at 10ns failed at 10ns
	Offending 'a'
[30] a=1 b=0 c=0 d=1
"testbench.sv", 30: tb_assert.unnamed$$_3: started at 30ns failed at 30ns
	Offending 'a'
[50] a=0 b=0 c=1 d=1
[70] a=1 b=1 c=0 d=1
"testbench.sv", 30: tb_assert.unnamed$$_3: started at 70ns failed at 70ns
	Offending 'a'
"testbench.sv", 30: tb_assert.unnamed$$_3: started at 50ns failed at 70ns
	Offending 'b'
[90] a=1 b=1 c=0 d=1
[110] a=0 b=1 c=0 d=1
[130] a=0 b=0 c=1 d=0
"testbench.sv", 30: tb_assert.unnamed$$_3: started at 130ns failed at 130ns
	Offending 'a'
"testbench.sv", 30: tb_assert.unnamed$$_3: started at 90ns failed at 130ns
	Offending 'c'
[150] a=0 b=0 c=0 d=1
"testbench.sv", 30: tb_assert.unnamed$$_3: started at 150ns failed at 150ns
	Offending 'a'
[170] a=1 b=1 c=0 d=1
"testbench.sv", 30: tb_assert.unnamed$$_3: started at 170ns failed at 170ns
	Offending 'a'
[190] a=0 b=1 c=1 d=0
[210] a=1 b=1 c=0 d=1
"testbench.sv", 30: tb_assert.unnamed$$_3: started at 210ns failed at 210ns
	Offending 'a'
[230] a=1 b=1 c=0 d=1
"testbench.sv", 30: tb_assert.unnamed$$_3: started at 190ns failed at 230ns
	Offending 'c'
[250] a=1 b=1 c=0 d=0
[270] a=1 b=0 c=0 d=1
"testbench.sv", 30: tb_assert.unnamed$$_3: started at 230ns failed at 270ns
	Offending 'c'
[290] a=0 b=1 c=1 d=0
"testbench.sv", 30: tb_assert.unnamed$$_3: started at 270ns failed at 290ns
	Offending 'b'
"testbench.sv", 30: tb_assert.unnamed$$_3: started at 250ns failed at 290ns
	Offending 'c'
[310] a=0 b=1 c=0 d=1
"testbench.sv", 30: tb_assert.unnamed$$_3: started at 310ns failed at 310ns
	Offending 'a'
[330] a=1 b=0 c=1 d=0
"testbench.sv", 30: tb_assert.unnamed$$_3: started at 330ns failed at 330ns
	Offending 'a'
"testbench.sv", 30: tb_assert.unnamed$$_3: started at 290ns failed at 330ns
	Offending 'c'
[350] a=0 b=1 c=0 d=1
[370] a=0 b=1 c=1 d=1
"testbench.sv", 30: tb_assert.unnamed$$_3: started at 370ns failed at 370ns
	Offending 'a'
"testbench.sv", 30: tb_assert.unnamed$$_3: started at 390ns failed at 390ns
	Offending 'a'
*/

module tb_assert;
    bit a, b, c, d;
    bit clk;

    always #10 clk = ~clk;

    initial begin
        for (int i = 0; i < 20; i++) begin
            {a, b, c, d} = $random;
            $display("[%0t] a=%0d b=%0d c=%0d d=%0d", $time, a, b, c, d);
            @(posedge clk);
        end
        #10 $finish;
    end

    sequence s_ab;
        a ##1 b;        // validate that b is 1 one clk cycle after a is 1
    endsequence

    sequence s_cd;
        c ##2 d;        // validate that d is 1 two clk cycles after c is 1
    endsequence  

    property my_prop;
        @(posedge clk) s_ab ##1 s_cd;   // s_cd is 1 clk cycle after s_ab
    endproperty  

    assert property(my_prop);
    //assert property(@(posedge clk) s_ab ##1 s_cd);    // combine both property and assert
endmodule

