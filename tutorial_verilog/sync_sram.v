/**
sram: 
- a sram cell is 2 inverters back-to-back - one keeps the level of the other one alive
- a inverter consists of 2 trasistors, so a sram cell has 4 transistors in total 
- dram: store value in capacitors, need refresh continuously (so "dynamic" refresh)

ref: 
- https://electronics.stackexchange.com/questions/30221/sram-and-flip-flops

output
# KERNEL: 0 clk=0 dataIn=00 dataOut=xx Addr=00000000 CS=0 WE=0 RD=0         // clk toggle
# KERNEL: 10 clk=1 dataIn=00 dataOut=xx Addr=00000000 CS=0 WE=0 RD=0
# KERNEL: 20 clk=0 dataIn=00 dataOut=xx Addr=00000000 CS=0 WE=0 RD=0
...
# KERNEL: 90 clk=1 dataIn=00 dataOut=xx Addr=00000000 CS=0 WE=0 RD=0
# KERNEL: 100 clk=0 dataIn=00 dataOut=xx Addr=00000000 CS=1 WE=1 RD=0       // data write
# KERNEL: 110 clk=1 dataIn=00 dataOut=xx Addr=00000000 CS=1 WE=1 RD=0
# KERNEL: 120 clk=0 dataIn=00 dataOut=xx Addr=00000000 CS=1 WE=1 RD=0
# KERNEL: 130 clk=1 dataIn=00 dataOut=xx Addr=00000000 CS=1 WE=1 RD=0       
# KERNEL: 140 clk=0 dataIn=01 dataOut=xx Addr=00000001 CS=1 WE=1 RD=0       // data write
# KERNEL: 150 clk=1 dataIn=01 dataOut=xx Addr=00000001 CS=1 WE=1 RD=0
# KERNEL: 160 clk=0 dataIn=10 dataOut=xx Addr=00000010 CS=1 WE=1 RD=0
# KERNEL: 170 clk=1 dataIn=10 dataOut=xx Addr=00000010 CS=1 WE=1 RD=0
# KERNEL: 180 clk=0 dataIn=06 dataOut=xx Addr=00000011 CS=1 WE=1 RD=0
# KERNEL: 190 clk=1 dataIn=06 dataOut=xx Addr=00000011 CS=1 WE=1 RD=0
# KERNEL: 200 clk=0 dataIn=12 dataOut=xx Addr=00000100 CS=1 WE=1 RD=0
# KERNEL: 210 clk=1 dataIn=12 dataOut=xx Addr=00000100 CS=1 WE=1 RD=0
# KERNEL: 220 clk=0 dataIn=12 dataOut=xx Addr=00000100 CS=1 WE=1 RD=0
# KERNEL: 230 clk=1 dataIn=12 dataOut=xx Addr=00000100 CS=1 WE=1 RD=0
# KERNEL: 240 clk=0 dataIn=12 dataOut=xx Addr=00000000 CS=1 WE=0 RD=1       // data read
# KERNEL: 250 clk=1 dataIn=12 dataOut=00 Addr=00000000 CS=1 WE=0 RD=1
# KERNEL: 260 clk=0 dataIn=12 dataOut=00 Addr=00000001 CS=1 WE=0 RD=1
# KERNEL: 270 clk=1 dataIn=12 dataOut=01 Addr=00000001 CS=1 WE=0 RD=1
# KERNEL: 280 clk=0 dataIn=12 dataOut=01 Addr=00000010 CS=1 WE=0 RD=1
# KERNEL: 290 clk=1 dataIn=12 dataOut=10 Addr=00000010 CS=1 WE=0 RD=1
# KERNEL: 300 clk=0 dataIn=12 dataOut=10 Addr=00000011 CS=1 WE=0 RD=1
# KERNEL: 310 clk=1 dataIn=12 dataOut=06 Addr=00000011 CS=1 WE=0 RD=1
# KERNEL: 320 clk=0 dataIn=12 dataOut=06 Addr=00000100 CS=1 WE=0 RD=1
# KERNEL: 330 clk=1 dataIn=12 dataOut=12 Addr=00000100 CS=1 WE=0 RD=1

**/

// design
/** 
8 addresses x 8-bit data = 64 bits SRAM

addr[7:0] -|‾‾‾‾‾‾‾‾‾‾|- dout [7:0]
din[7:0]  -|          |
clk       -|          |
cs        -|          |
rd        -|          |
we        -|__________|
**/
module syncRAM 
#(
    parameter ADR   = 8,
    parameter DAT   = 8    // DEPTH = DATA bits, remove DPTH
    //parameter DPTH  = 8
) 
( 
    dataIn,
    dataOut,
    Addr, 
    CS, 
    WE, 
    RD, 
    Clk
);

//ports
input [DAT-1:0] dataIn;         // 8-bit data in
output reg [DAT-1:0] dataOut;   // 8-bit data out
input [ADR-1:0] Addr;           // 8-bit address
input CS, WE, RD, Clk;

//internal variables
//reg [DAT-1:0] SRAM [DPTH-1:0];    
reg [DAT-1:0] SRAM [DAT-1:0];   // replace DPTH with DAT

// logic
/**
            |        | (read data)
clk __|‾‾|__|‾‾|__|‾‾|__|‾‾|__
cs  __|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
we  __|‾‾‾‾‾‾‾‾|______________
rd  ___________|‾‾‾‾‾‾‾‾‾‾‾‾‾‾
din _____|‾‾‾‾‾|______________
do  ______________|‾‾‾‾|______
            |(write data)

**/
always @ (posedge Clk) begin
    if (CS == 1'b1) begin
        if (WE == 1'b1 && RD == 1'b0) begin
            SRAM [Addr] = dataIn;
        end
        else if (RD == 1'b1 && WE == 1'b0) begin
            dataOut = SRAM [Addr]; 
        end
        else;
        end
    else;
    end
endmodule

// tb
`timescale 1ns / 1ps

module syncRAM_tb;
    // Inputs
    reg [7:0] dataIn;
    reg [7:0] Addr;
    reg CS;
    reg WE;
    reg RD;
    reg Clk;
    
    // Outputs
    wire [7:0] dataOut;

    // Instantiate the Unit Under Test (UUT)
    syncRAM uut (
        .dataIn(dataIn), 
        .dataOut(dataOut), 
        .Addr(Addr), 
        .CS(CS), 
        .WE(WE), 
        .RD(RD), 
        .Clk(Clk)
    );

    always #10 Clk = ~Clk;

    initial begin
        $dumpfile("dump.vcd"); $dumpvars(1);
        $monitor("%g clk=%b dataIn=%h dataOut=%h Addr=%b CS=%b WE=%b RD=%b", $time, Clk, dataIn, dataOut, Addr, CS, WE, RD);
        
        // Initialize Inputs
        dataIn  = 8'h0;
        Addr  = 8'h0;
        CS  = 1'b0;
        WE  = 1'b0;
        RD  = 1'b0;
        Clk  = 1'b0;
        // Wait 100 ns for global reset to finish
        #100;

        // write operation
        dataIn  = 8'h0;
        Addr  = 8'h0;
        CS  = 1'b1;
        WE  = 1'b1;
        RD  = 1'b0;
        
        #20;
        dataIn  = 8'h0;
        Addr  = 8'h0;
        #20;
        dataIn  = 8'h1;
        Addr  = 8'h1;
        #20;
        dataIn  = 8'h10;
        Addr  = 8'h2;
        #20;
        dataIn  = 8'h6;
        Addr  = 8'h3;
        #20;
        dataIn  = 8'h12;
        Addr  = 8'h4;

        // read operation
        #40;
        Addr  = 8'h0;
        WE  = 1'b0;
        RD  = 1'b1;
        #20;
        Addr   = 8'h1;
        #20;
        Addr   = 8'h2;
        #20;
        Addr   = 8'h3;
        #20;
        Addr   = 8'h4;

        #10 $finish;
    end
endmodule