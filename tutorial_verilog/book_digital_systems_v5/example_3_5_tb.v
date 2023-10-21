// Verilog test bench for example_3_5
`timescale 1ns/100ps
`include "example_3_5.v"

module example_3_5_tb;

   wire A, B, C, D;
   integer k=0;

   assign {A,B,C} = k;
   example_3_5 the_circuit(D, A, B, C);

   initial begin

      $dumpfile("example_3_5.vcd");
      $dumpvars(0, example_3_5_tb);

      for (k=0; k<8; k=k+1)
        #10 $display("done testing case %d", k);

      $finish;

   end 

endmodule 
