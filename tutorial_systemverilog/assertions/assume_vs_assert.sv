/**
demo SVA assert vs assume (from synopsys SVA training)

output
"testbench.sv", 34: tb.no_imp: started at 1ns failed at 1ns
	Offending '(behavior == 'h00000084)'
"testbench.sv", 34: tb.no_imp: started at 3ns failed at 3ns
	Offending '(behavior == 'h00000084)'
"testbench.sv", 34: tb.no_imp: started at 5ns failed at 5ns
	Offending '(behavior == 'h00000084)'
"testbench.sv", 34: tb.no_imp: started at 7ns failed at 7ns
	Offending '(behavior == 'h00000084)'
"testbench.sv", 34: tb.no_imp: started at 9ns failed at 9ns
	Offending '(behavior == 'h00000084)'
"testbench.sv", 34: tb.no_imp: started at 11ns failed at 11ns
	Offending '(behavior == 'h00000084)'
"testbench.sv", 35: tb.with_imp: started at 11ns failed at 11ns
	Offending '(behavior == 'h00000084)'

**/

module tb;
    bit rst = 0;
    bit clk = 0;
    int activation_signal = 0;
    int behavior;
    int cfg;
        
    always #1 clk <= !clk;
    
    initial begin
        #10;
        activation_signal <= !activation_signal;
        cfg <= 'h42;
        #10;
        rst <= !rst;
        #10;
        $finish;
    end
  
    initial begin
        $dumpfile("dump.vcd"); $dumpvars;
    end
  
    always @(posedge clk) begin
        if (rst)
            behavior <=0;
        else
        behavior = cfg+cfg;
    end
        
    with_imp_assume: assume property (@(posedge clk) disable iff (rst) activation_signal |-> cfg == 'h42);
          
    no_imp: assert property (@(posedge clk) disable iff (rst) behavior == 'h84);
    with_imp: assert property (@(posedge clk) disable iff (rst) activation_signal |-> behavior == 'h84);   
endmodule