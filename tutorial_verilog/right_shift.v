/**
check logic diagram of logical right shift operation
out: 1f

yosys: in, rs -> $shr (logic shift cell) -> out
**/

module dut
(
    input [7:0] in, 
    input [3:0] rs,
    output [7:0] out
);
    assign out = in >> rs;
endmodule

// behave differently, need #1 $display in tb to show correct result, why? 
// yosys also shows extra buffer: out -> buffer -> tmp 
// waveforms show no difference
module dut2
(
    input [7:0] in, 
    input [3:0] rs,
    output [7:0] out
);
    reg [7:0] tmp;
    always @*
        tmp = in >> rs;
    assign out = tmp;
endmodule

module tb;
    logic [7:0] in;
    logic [7:0] out;
    int rs;
    
    dut d
    (
        .in(in), .rs(rs), .out(out)
    );
    
    initial begin
        $dumpfile("dump.vcd"); $dumpvars(1);
        in = 8'hff;
        rs = 3;
        $display("out: %0h", out);
        $finish;
    end
endmodule