// verilog 1995 style parameter and port declaration
module design_ip_1995 (  addr, 
                    wdata, 
                    write, 
                    sel, 
                    rdata);

    parameter   BUS_WIDTH = 32, 
                DATA_WIDTH = 64, 
                FIFO_DEPTH = 512;

    input addr;
    input wdata;
    input write;
    input sel;
    output rdata;

    wire [BUS_WIDTH - 1 : 0] addr;
    wire [DATA_WIDTH - 1 : 0] wdata;
    reg [DATA_WIDTH - 1 : 0] rdata;

    reg [7:0] fifo [FIFO_DEPTH];

endmodule

// ANSI C style parameter and port declaration
module design_ip_ansi_c
    // module parameters
    #(
        parameter BUS_WIDTH = 32, 
        parameter DATA_WIDTH = 64, 
        parameter FIFO_DEPTH = 512
    )
    // module ports
    (   input [BUS_WIDTH - 1 : 0] addr, 
        input [DATA_WIDTH - 1 : 0] wdata, 
        input write, 
        input sel, 
        output reg [DATA_WIDTH - 1 : 0] rdata
    );

    reg [7:0] fifo [FIFO_DEPTH];

endmodule