/**
note: logic requires icarus verilog 0.10.0 to run

"logic"
(blocking =)
my_data = 4'hB;
time: 0, my_data=0xx en=x
time: 0, my_data=0xb en=x
time: 1, my_data=0xb en=1
1 2                #1
|_|________________|
1: 1st $display runs, my_data has no value. my_data = 4'hB so my_data now has value (slightly after 1st $display). 
2: "="" is blocking so after the assignment, 2nd $display runs afterward. my_data has value so en is drive but not shown yet (assign en = my_data[0];). #1 starts. 
#1: at #1, 3rd display, now both my_data and en has value

(non-blocking <=)
my_data <= 4'hB;            
time: 0, my_data=0xx en=x
time: 0, my_data=0xx en=x
time: 1, my_data=0xb en=1
1                 #1
|_________________|
1: 1st starts, my_data <= 4'hB, 2nd $display starts, #1 starts. 1st two $display has no value for my_data
#1: at #1, 3rd $display runs. now both my_data and en have values. 

"reg, wire" (Same)
my_data = 4'hB;
time: 0, my_data=0xx en=x
time: 0, my_data=0xb en=x
time: 1, my_data=0xb en=1

my_data <= 4'hB;
time: 0, my_data=0xx en=x
time: 0, my_data=0xx en=x
time: 1, my_data=0xb en=1
*/

`timescale 1ns/1ps

module tb;
    logic[3:0] my_data;     // or reg[3:0] my_data;
    logic en;               // or wire en;

    initial begin
        // $dumpfile("dump.vcd");   // for waveform
        // $dumpvars(1);
        $display("time=%g, my_data=0x%0h en=%0b", $time, my_data, en);  // %t for time is better org'ed
        my_data = 4'hB;
        $display("time=%g, my_data=0x%0h en=%0b", $time, my_data, en);
        #1;
        $display("time=%g, my_data=0x%0h en=%0b", $time, my_data, en);
        #1;
        $finish;
    end

    assign en = my_data[0];

endmodule