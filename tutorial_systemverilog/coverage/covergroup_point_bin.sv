/**
# KERNEL: [40] mode=0x0 cfg=0x1
# KERNEL: [80] mode=0x1 cfg=0x3
# KERNEL: [120] mode=0x1 cfg=0x5
# KERNEL: [160] mode=0x1 cfg=0x2
# KERNEL: [200] mode=0x1 cfg=0x5
# KERNEL: [240] mode=0x2 cfg=0x5
# KERNEL: [280] mode=0x1 cfg=0x4
# KERNEL: [320] mode=0x1 cfg=0x6
# KERNEL: [360] mode=0x1 cfg=0x2
# KERNEL: [400] mode=0x1 cfg=0x7
# KERNEL: Coverage = 66.67 %

note. 
- 1st bin is mode = 0, 100% covered
- 2nd bin is mode = 1, 100% covered
- 3rd bin is mode = 3, not covered (0%)
- average is (100 + 100 + 0) / 3 % = 66.67%

 */

module tb_simple;
    bit [1:0] mode;
    bit [2:0] cfg;

    bit clk;
    always #20 clk = ~clk;

    covergroup cg @(posedge clk);   // sample the covergroup at posedge of clk
      coverpoint mode {
        bins featureA = {0};
        bins featureB = {1};
        bins featureC = {3};
      }
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