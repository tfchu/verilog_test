/**
a FIFO (i/f) can only be 
- pushed when fifo is not full
- popped when fifo is not empty
- any violation is captured in immediate assertion

[0] push=1 full=1 pop=0 empty=1             // push into full fifo: fail, no pop
"design.sv", 5: tb.md0.a_push: started at 10ns failed at 10ns
	Offending '(!_if.full)'
[FAIL] push when fifo is full

[10] push=1 full=0 pop=1 empty=1            // push into not full fifo: pass, pop from empty fifo: fail
[PASS] push when fifo is not full
"design.sv", 13: tb.md0.a_pop: started at 30ns failed at 30ns
	Offending '(!_if.empty)'
[FAIL] pop when fifo is empty

[30] push=1 full=1 pop=1 empty=0            // push into a full fifo: fail, pop from a non-empty fifo: pass
"design.sv", 5: tb.md0.a_push: started at 50ns failed at 50ns
	Offending '(!_if.full)'
[FAIL] push when fifo is full
[PASS] pop when fifo is not empty

[50] push=0 full=0 pop=1 empty=1            // no push, pop from an empty fifo: fail
"design.sv", 13: tb.md0.a_pop: started at 70ns failed at 70ns
	Offending '(!_if.empty)'
[FAIL] pop when fifo is empty

[70] push=0 full=1 pop=1 empty=1            // no push, pop from an empty fifo: fail
"design.sv", 13: tb.md0.a_pop: started at 90ns failed at 90ns
	Offending '(!_if.empty)'
[FAIL] pop when fifo is empty
*/

module my_design (my_if _if);
    always @(posedge _if.clk) begin
        if (_if.push) begin
            a_push: assert(!_if.full) begin                     // immediate assertion
                $display("[PASS] push when fifo is not full");
            end else begin
                $display("[FAIL] push when fifo is full");
            end
        end

        if (_if.pop) begin
            a_pop: assert(!_if.empty) begin                     // immediate assertion
                $display("[PASS] pop when fifo is not empty");  // _if.empty = 0, so !_if.empty = 1 (true)
            end else begin
                $display("[FAIL] pop when fifo is empty");
            end
        end
    end
endmodule

interface my_if(input bit clk);
    logic push;
    logic pop;
    logic empty;
    logic full;
endinterface

module tb;
    bit clk;
    always #10 clk <= ~clk;

    my_if _if(clk);
    my_design md0(.*);

    initial begin
        for (int i = 0; i < 5; i++) begin
            //_if.randomize();      // does NOT work!!
            _if.pop <= $random;
            _if.push <= $random;
            _if.empty <= $random;
            _if.full <= $random;
            $strobe("[%0t] push=%0b full=%0b pop=%0b empty=%0b ", $time, _if.push, _if.full, _if.pop, _if.empty);
            @(posedge clk);
        end
        #10 $finish;
    end
endmodule