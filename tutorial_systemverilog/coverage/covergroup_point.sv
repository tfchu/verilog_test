/**

demo covergroup, coverpoint

module tb_simple;
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

87.5% if changing coverpoint to 
coverpoint mode[1:0];   // 1st coverpoint: same as above, 75% covered
coverpoint mode[0];     // 2nd coverpoint: possible values = 0, 1, all (100%) covered
so average = (100 + 75) / 2 % = 87.5%

module tb_complex;
[40] mode=0x0 cfg=0x1
[80] mode=0x1 cfg=0x3
[120] mode=0x1 cfg=0x5
[160] mode=0x1 cfg=0x2
[200] mode=0x1 cfg=0x5
[240] mode=0x2 cfg=0x5
[280] mode=0x1 cfg=0x4
[320] mode=0x1 cfg=0x6
[360] mode=0x1 cfg=0x2
[400] mode=0x1 cfg=0x7
Coverage = 90.62 %


cp_mode : coverpoint mode;              // 75% same as above
cp_cfg_10 : coverpoint cfg[1:0];        // 4 possible values (00b (0x4), 01b (0x1), 10b (0x2), 11b (0x3)), all covered so 100%
cp_cfg_lsb : coverpoint cfg[0];         // 2 possible values (0, 1), all covered so 100% 
cp_sum : coverpoint (mode + cfg);       // mode (75%) and cfg (7/8 = 87.5%, 0 not covered), average = 81.25

*/

module tb_simple;
    bit [1:0] mode;
    bit [2:0] cfg;

    bit clk;
    always #20 clk = ~clk;

    covergroup cg @(posedge clk);   // sample the covergroup at posedge of clk
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
endmodule



module tb_complex;
    bit [1:0] mode;
    bit [2:0] cfg;

    bit clk;
    always #20 clk = ~clk;

    covergroup cg @(posedge clk);   // sample the covergroup at posedge of clk
        cp_mode : coverpoint mode;            // named coverpoint
        cp_cfg_10 : coverpoint cfg[1:0];
        cp_cfg_lsb : coverpoint cfg[0];
        cp_sum : coverpoint (mode + cfg);
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
        #500 $display("Coverage = %0.2f %%", my_cg.get_coverage()); // original get_inst_coverage() reports 0%, not sure why? 
        $finish;
    end
endmodule