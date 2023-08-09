/*
// https://www.youtube.com/watch?v=RDtGyHfP_eQ
$ vcs -Mupdate -Rpp -v alu.v tb_alu.v -o test -full64 -debug_all
$ ./test -gui   // open dve

- DVE Hierarchy view
Hierarchy               Variable
+tb_alu (tb_alu)        i[3:0] (integer), ALU_outt[7:0] (Wire), Carry_outt (Wire), At[7:0] (Reg), Bt[7:0] (Reg), selectt[3:0] (Reg), clkt (Reg)
    test_unit(alu)      A[7:0]      Wire (Port In)
                        B[7:0]      Wire (Port In)
                        select[3:0] Wire (Port In)
                        clk         Wire (Port In)
                        ALU_out[7:0] Wire (Port Out)
                        Carry_out   Wire (Port Out)
                        tmp[8:0]    Wire
                        ALU_reulst[7:0] Reg

Variable symbols
Wire (Port In): [>-
Wire (Port Out): -[>
Wire: like waveform
Reg: []

- Schematic
right-click on tb_alu/show schematic: this shows tb_alu driving alu
double-click on alu, this show the schematic of alu (4 input - clk, select, A, B, 2 output - ALK_out, Carry_out)

[tb_alu]        [alu]
At      ---     A
Bt      ---     B
selectt ---     select
clkt    ---     select

- waveform
right-click on tb_alu/Add To Waves/New Wave View, this show waveform with all tb_alu variables (signals)
in wave view, click on "start/continue" (down arrow), then "stop"

clkt            +   -   *   /
selectt[3:0]    0   1   2   3   ...
At              10  10  10  10
Bt              2   2   2   2
ALU_outt[7:0]   12  8   20  5   ...

note. tb_alu set At = 10, Bt = 2

- Output (tchu added $display)
A= 10, B=  2
[                   0] selectt=0000 output=  x
[                  10] selectt=0001 output= 12
[                  20] selectt=0010 output=  8
[                  30] selectt=0011 output= 20
[                  40] selectt=0100 output=  5
[                  50] selectt=0101 output= 20
[                  60] selectt=0110 output=  5
[                  70] selectt=0111 output= 20
[                  80] selectt=1000 output=  5
[                  90] selectt=1001 output=  2
[                 100] selectt=1010 output= 10
[                 110] selectt=1011 output=  8
[                 120] selectt=1100 output=253
[                 130] selectt=1101 output=245
[                 140] selectt=1110 output=247
[                 150] selectt=1111 output=  1
*/

`timescale 1ns/1ps

module tb_alu;
    //output
    reg[7:0] At, Bt;
    reg[3:0] selectt;
    reg clkt;
    //input
    wire[7:0] ALU_outt;
    wire Carry_outt;

    integer i;
    // test "alu.v", name it as "test_unit"
    alu test_unit(.A(At), .B(Bt), .select(selectt), .clk(clkt), .ALU_out(ALU_outt), .Carry_out(Carry_outta));

    initial begin
        forever begin
            // 0 (#1) 1 (#1) 0 (#1) 1 ...
            clkt = 0;
            #1
            clkt = 1;
            #1
            clkt = 0;
        end
        // same as above, toggle clkt
        // clkt = 0;
        // forever begin
        //     #1 clkt = ~clkt;
        // end
    end

    initial begin
        $dumpfile("dump.vcd"); $dumpvars;
        At = 8'd10;         // decimal 10
        Bt = 8'd02;         // decimal 2
        selectt = 4'd0;
        $display($sformatf("A=%d, B=%d", At, Bt));

        for(i=0; i<=15; i=i+1)
        begin
            selectt = i;
            $display($sformatf("[%t] selectt=%b output=%d", $time, selectt, ALU_outt));
            #10;
        end
    end

endmodule