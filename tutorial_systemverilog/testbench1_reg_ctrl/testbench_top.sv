/**

T=20 [Test] Starting stimulus ...
T=20 [Driver] starting ...
T=20 [Monitor] starting ...
T=30 [Driver] waiting for item ...
T=30 [Driver] addr=0xaa wr=1 wdata=0xe513 rdata=0x0
T=50 [Driver] waiting for item ...
T=50 [Driver] addr=0xaa wr=0 wdata=0x5fa7 rdata=0x0
T=50 [Monitor] addr=0xaa wr=1 wdata=0xe513 rdata=0x0
T=50 [Scoreboard] addr=0xaa wr=1 wdata=0xe513 rdata=0x0
T=50 [Scoreboard] Store addr=0xaa wr=0x1 data=0xe513
T=70 [Driver] waiting for item ...
T=90 [Monitor] addr=0xaa wr=0 wdata=0x5fa7 rdata=0xe513
T=90 [Scoreboard] addr=0xaa wr=0 wdata=0x5fa7 rdata=0xe513
T=90 [Scoreboard] PASS! addr=0xaa exp=0xe513 act=0xe513

*/

`include "interface.sv"
`include "test.sv"
module tb_top;
    reg clk;
    
    always #10 clk = ~clk;
    reg_if _if (clk);
    
    reg_ctrl u0 ( .clk (clk),
                    .addr (_if.addr),
                    .rstn(_if.rstn),
                    .sel  (_if.sel),
                    .wr (_if.wr),
                    .wdata (_if.wdata),
                    .rdata (_if.rdata),
                    .ready (_if.ready));
    
    initial begin
        test t0;
        
        clk <= 0;
        _if.rstn <= 0;
        _if.sel <= 0;
        #20 _if.rstn <= 1;
        
        t0 = new;
        t0.e0.vif = _if;
        t0.run();
        
        // Once the main stimulus is over, wait for some time
        // until all transactions are finished and then end 
        // simulation. Note that $finish is required because
        // there are components that are running forever in 
        // the background like clk, monitor, driver, etc
        #200 $finish;
    end
    
    // Simulator dependent system tasks that can be used to 
    // dump simulation waves.
    initial begin
        $dumpvars;
        $dumpfile("dump.vcd");
    end
endmodule
