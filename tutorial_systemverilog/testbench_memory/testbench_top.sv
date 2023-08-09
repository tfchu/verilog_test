/**

// include monitor and scoreboard
--------- [DRIVER] Reset Started ---------
--------- [DRIVER] Reset Ended ---------
--------- [Trans] post_randomize ------
	 addr  = 0	 wr_en = 1	 wdata = 6b
-----------------------------------------
--------- [Trans] post_randomize ------
	 addr  = 0	 rd_en = 1
-----------------------------------------
--------- [Trans] post_randomize ------
	 addr  = 1	 wr_en = 1	 wdata = 7e
-----------------------------------------
--------- [Trans] post_randomize ------
	 addr  = 1	 rd_en = 1
-----------------------------------------
--------- [Trans] post_randomize ------
	 addr  = 2	 wr_en = 1	 wdata = 85
-----------------------------------------
--------- [Trans] post_randomize ------
	 addr  = 2	 rd_en = 1
-----------------------------------------
--------- [Trans] post_randomize ------
	 addr  = 3	 wr_en = 1	 wdata = fb
-----------------------------------------
--------- [Trans] post_randomize ------
	 addr  = 3	 rd_en = 1
-----------------------------------------
--------- [Trans] post_randomize ------
	 addr  = 0	 wr_en = 1	 wdata = 52
-----------------------------------------
--------- [Trans] post_randomize ------
	 addr  = 0	 rd_en = 1
-----------------------------------------
--------- [DRIVER-TRANSFER: 0] ---------
	ADDR = 0 	WDATA = 6b
-----------------------------------------
--------- [DRIVER-TRANSFER: 1] ---------
	ADDR = 0 	RDATA = 6b
-----------------------------------------
--------- [DRIVER-TRANSFER: 2] ---------
	ADDR = 1 	WDATA = 7e
-----------------------------------------
--------- [DRIVER-TRANSFER: 3] ---------
[SCB-PASS] Addr = 0,
 	   Data :: Expected = 6b Actual = 6b
	ADDR = 1 	RDATA = 7e
-----------------------------------------
--------- [DRIVER-TRANSFER: 4] ---------
	ADDR = 2 	WDATA = 85
-----------------------------------------
--------- [DRIVER-TRANSFER: 5] ---------
	ADDR = 2 	RDATA = 85
-----------------------------------------
--------- [DRIVER-TRANSFER: 6] ---------
	ADDR = 3 	WDATA = fb
-----------------------------------------
--------- [DRIVER-TRANSFER: 7] ---------
[SCB-PASS] Addr = 1,
 	   Data :: Expected = 7e Actual = 7e
	ADDR = 3 	RDATA = fb
-----------------------------------------
--------- [DRIVER-TRANSFER: 8] ---------
	ADDR = 0 	WDATA = 52
-----------------------------------------
--------- [DRIVER-TRANSFER: 9] ---------
	ADDR = 0 	RDATA = 52
-----------------------------------------
[SCB-PASS] Addr = 2,
 	   Data :: Expected = 85 Actual = 85
[SCB-PASS] Addr = 3,
 	   Data :: Expected = fb Actual = fb
[SCB-PASS] Addr = 0,
 	   Data :: Expected = 52 Actual = 52

*/
`include "interface.sv"
`include "random_test.sv"
 
module tbench_top;
   
    //clock and reset signal declaration
    bit clk;
    bit reset;
    
    //clock generation
    always #5 clk = ~clk;
    
    //reset Generation
    initial begin
        reset = 1;
        #5 reset =0;
    end
    
    //creatinng instance of interface, inorder to connect DUT and testcase
    mem_intf intf(clk,reset);
    
    //Testcase instance, interface handle is passed to test as an argument
    test t1(intf);
    
    //DUT instance, interface signals are connected to the DUT ports
    memory DUT (
        .clk(intf.clk),
        .reset(intf.reset),
        .addr(intf.addr),
        .wr_en(intf.wr_en),
        .rd_en(intf.rd_en),
        .wdata(intf.wdata),
        .rdata(intf.rdata)
    );
    
    //enabling the wave dump
    initial begin
        $dumpfile("dump.vcd"); $dumpvars;
    end

endmodule