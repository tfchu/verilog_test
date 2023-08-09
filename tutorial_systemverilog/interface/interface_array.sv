/**
array of interface

<i/f_name> <i/f_instance> [n:0]();
*/

interface my_if();
    reg         gnt;
    reg         ack;
    reg [7:0]   irq;
endinterface

module my_design(my_if mif, input logic clk);
    always @(posedge clk)
        if (mif.ack)
            mif.gnt <= 1;
endmodule

module tb;
    reg         clk;

    my_if       if0();              // 1 i/f
    my_if       ifarr [3:0]();      // i/f array

    my_design   design_top(.mif(if0), .clk(clk));
    my_design   md0(.mif(ifarr[0]), .clk(clk));
    my_design   md1(.mif(ifarr[1]), .clk(clk));
    my_design   md2(.mif(ifarr[2]), .clk(clk));
    my_design   md3(.mif(ifarr[3]), .clk(clk));
endmodule