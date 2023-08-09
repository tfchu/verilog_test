/**
// APB I/F
interface apb_if (input pclk);
    logic [31:0]    paddr;
    logic [31:0]    pwdata;
    logic [31:0]    prdata;
    logic           penable;
    logic           pwrite;
    logic           psel;
endinterface



*/

// interface
interface my_bus (input clk);
    logic [7:0] data;
    logic       enable;

    // define port directions
    modport test_bench (
        input data, clk, 
        output enable
    );

    modport dut (
        output data, 
        input enable, clk
    );
endinterface //my_bus

// DUT, connect DUT to I/F
module dut (my_bus bus_if);
    always @(posedge bus_if.clk)
    if (bus_if.enable)
        bus_if.data <= bus_if.data + 1;
    else
        bus_if.data <= 0;
endmodule

// test bench
module tb_if;
    bit clk;                // local variable clk
    always #10 clk = ~clk;  // toggle clk every #10
    my_bus bus_if(clk);     // instantiate i/f with "clk"
    dut dut0(bus_if.dut);   // instantiate dut, use dut port direction of the i/f

    initial begin
        $dumpfile("dump.vcd");      // dump waveform
        $dumpvars;
        bus_if.enable <= 0;         // #0, i/f enable to 0
        #10 bus_if.enable <= 1;     // #10, i/f enable to 1
        #40 bus_if.enable <= 0;     // #50, i/f enable to 0
        #20 bus_if.enable <= 1;     // #70, i/f enable to 1
        #100 $finish;               // #170, finish
    end
endmodule

