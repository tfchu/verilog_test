/*
demo
https://www.youtube.com/watch?v=Av9PbO3corw&list=PLqsyARCuPNKE0JnY4T8j2kjNtfdpCyMRL&index=5

- files (original)
    ripple_tb.v
    rippleaddr.v
    fulladdr.v

- open DVE: same as demo 1
    $ vcs -Mupdate -RPP -v rippleaddr.v fulladdr.v ripple_tb.v -o vcs -full64 -debug_all -cm line+tgl+fsm+cond  // cm are added
    $ ./vcs -gui                    // open DVE
    $ ./vcs -cm line+tgl+fsm+cond   // used to run VCS coverage metrics, create vcs.vdb, and goes to ucli
    ucli% help                      // check help
    ucli% resume
    ucli% run
    $ dve -covdir vcs.vdb/ -full64  // show the coverage of Line, Toggle, FSM and Condition (specified in -cm)


- DVE Hierarchy view: instance (module)
+rippleaddr_tb          // testbench module name (rippleadder_tb), NOT file name (ripple_tb.v)
    +uut (ripplemod)    // design module name (ripplemod), NOT desing file name (rippleaddr.v)
        a1 (fulladd)    // design module name (fulladd), NOT design file name (fulladdr.v)
        a2 (fulladd)
        ...
        a8 (fulladd)

- some DVE features
    - edit source code
    right-click on any module in the hierarchy/Edit Source (selected module) or Edit Parent (its parent module, including testbench)
    - breakpoint
    opne source code, and click left-hand side of the code to enable breakpoint
    DVE/Simulator/Breakpoints, it shows all breakpoints, can be saved to a .tcl file

*/
module rippleadder_tb();
reg [7:0] a;
reg [7:0] b;
reg cin;
wire [7:0] sum;
wire cout;

// port connection 
ripplemod uut ( // module "ripplemod" instantiated with name "uut", in another module "rippleadder_tb"
    .a(a),      // signal "a" (1st) in ripplemod is connected to "a" in this module
    .b(b),      // signal "b" (1st) in ripplemod is connected to "b" in this module
    .cin(cin),  // ...
    .sum(sum),  // ...
    .cout(cout) // ...
);    
initial begin
    #10 a=8'b00000001; b=8'b00000001; cin = 1'b0;
    #10 a=8'b00000001; b=8'b00000001; cin = 1'b1;
    #10 a=8'b00000010; b=8'b00000011; cin = 1'b0;
    #10 a=8'b10000001; b=8'b10000001; cin = 1'b0;
    #10 a=8'b00011001; b=8'b00110001; cin = 1'b0;
    #10 a=8'b00000011; b=8'b00000011; cin = 1'b1;
    #10 a=8'b11111111; b=8'b00000001; cin = 1'b0;
    #10 a=8'b11111111; b=8'b00000000; cin = 1'b1;
    #10 a=8'b11111111; b=8'b11111111; cin = 1'b0;
    #10 $stop;
end
endmodule