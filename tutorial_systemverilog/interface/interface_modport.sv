
// master-slave interface
interface ms_if (input clk);
    logic sready;           // slave ready (to access data)
    logic rstn;             // reset (active low)
    logic [1:0] addr;       // address
    logic [7:0] data;       // data

    // slave modport (port directions)
    modport slave (
        input addr, data, rstn, clk,
        output sready
    );

    // master modport (port directions)
    modport master (
        input clk, sready, rstn,
        output addr, data
    );
endinterface

/**
design - master
send transaction in pipelined format
CLK     1   2   3   4   5   6   ...
ADDR    A0  A1  A2  A3  A0  A1  ...
DATA        D0  D1  D2  D3  D4  ...
*/
module master (ms_if.master mif);
    always @(posedge mif.clk) begin
        // if reset
        if( !mif.rstn ) begin
            mif.addr <= 0;
            mif.data <= 0;
        end else begin
            if (mif.sready) begin
                mif.addr <= mif.addr + 1;
                mif.data <= (mif.addr * 4);     // data is address * 4
            end else begin
                mif.addr <= mif.addr;
                mif.data <= mif.data;
            end
        end
    end
endmodule

/**
design - slave

*/
module slave (ms_if.slave sif);
    reg [7:0]   reg_a;      // A0 (address 0) value
    reg [7:0]   reg_b;      // A1 value
    reg         reg_c;      // A2 value
    reg [3:0]   reg_d;      // A3 value
    reg         dly;
    reg [3:0]   addr_dly;

    always @(posedge sif.clk) begin
        if (! sif.rstn ) begin
            addr_dly <= 0;
        end else begin
            addr_dly <= sif.addr;
        end
    end

    always @(posedge sif.clk) begin
        if (! sif.rstn ) begin
            reg_a <= 0;
            reg_b <= 0;
            reg_c <= 0;
            reg_d <= 0;
        end else begin
            case (addr_dly)
                0: reg_a <= sif.data;
                1: reg_b <= sif.data;
                2: reg_c <= sif.data;
                3: reg_d <= sif.data;
            endcase
        end
    end

    assign sif.sready = ~(sif.addr[1] & sif.addr[0]) | ~dly;

    always @(posedge sif.clk) begin
        if (! sif.rstn ) begin
            dly <= 1;
        end else begin
            dly <= sif.sready;
        end
    end    
endmodule

/**
design - top (tie master and slave at a top level)
*/
module d_top (ms_if tif);
    master m0 (tif.master);
    slave s0 (tif.slave);
endmodule

/**
tb
*/
module tb;
    reg clk;
    always #10 clk = ~clk;

    ms_if if0(clk);
    d_top d0 (if0);

    initial begin
        $dumpfile("dump.vcd");      // waveform
      	$dumpvars;
        clk <= 0;                   // init clk to 0, if not set, then clk = x so it won't toggle
        if0.rstn <= 0;              // reset the ports
        repeat (5) @ (posedge clk); // wait until 5 posedge of clk
        if0.rstn <= 1;              // then deassert the reset

        repeat (20) @ (posedge clk);// wait another 20 posedge of clk
        $finish;                    // stop tb 
    end
endmodule