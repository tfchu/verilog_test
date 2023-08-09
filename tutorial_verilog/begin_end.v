module initial_begin_end();
reg clk,reset,enable,data;

initial begin
 $monitor(
   "%g clk=%b reset=%b enable=%b data=%b", 
   $time, clk, reset, enable, data);
 #1  clk = 0;
 #10 reset = 0;
 #5  enable = 0;
 #3  data = 0;
 #1 $finish;
end

endmodule