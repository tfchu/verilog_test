/**
[10] fifo_empty=1
"testbench.sv", 12: tb_immediate.unnamed$$_0: started at 10ns failed at 10ns
	Offending '(!fifo_empty)'
[30] fifo_empty=0
[50] fifo_empty=1
"testbench.sv", 12: tb_immediate.unnamed$$_0: started at 50ns failed at 50ns
	Offending '(!fifo_empty)'
[70] fifo_empty=0
[90] fifo_empty=1
"testbench.sv", 12: tb_immediate.unnamed$$_0: started at 90ns failed at 90ns
	Offending '(!fifo_empty)'
*/
module tb_immediate;
    bit clk;
    bit fifo_empty;

    always #10 clk = ~clk;

    always @(posedge clk) begin
        fifo_empty = ~fifo_empty;
        $display("[%0t] fifo_empty=%0d", $time, fifo_empty);
        assert(!fifo_empty);
    end

    initial begin
        #100 $finish;
    end
endmodule