/**
module tb_simple_sample;
[40] mode=0x0 xfg=0x1
[80] mode=0x1 xfg=0x3
[120] mode=0x1 xfg=0x5
[160] mode=0x1 xfg=0x2
[200] mode=0x1 xfg=0x5
[240] mode=0x2 xfg=0x5
[280] mode=0x1 xfg=0x4
[320] mode=0x1 xfg=0x6
[360] mode=0x1 xfg=0x2
[400] mode=0x1 xfg=0x7
Coverage = 75.00 %      // tchu: mode has 2 bits (4 possible values), our test covers 0, 1, 2, so 75% is covered
*/


// simple case with sample()
module tb_simple_sample;
    bit [1:0] mode;
    bit [2:0] cfg;

    bit clk;
    always #20 clk = ~clk;

    covergroup cg;                  // original: covergroup cg @(posedge clk);
        coverpoint mode;            // the point (variable) to cover (in report)
    endgroup

    // cg
    cg my_cg;

    initial begin
        my_cg = new();              // instantiate cg

        for (int i = 0; i < 10; i++) begin
            @(negedge clk);
            mode = $random;
            cfg = $random;
            $display("[%0t] mode=0x%0h cfg=0x%0h", $time, mode, cfg);
        end
    end

    // pull coverage report
    initial begin
        #500 $display("Coverage = %0.2f %%", my_cg.get_coverage()); // original get_inst_coverage() reports 0% (VCS), not sure why? but Aldec reports correctly
        $finish;
    end

    always @(posedge clk) begin
        cg.sample();
    end
endmodule