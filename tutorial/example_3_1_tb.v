// Verilog test bench for example_3_1
`timescale 1ns/100ps
`include "example_3_1.v"

module example_3_1_tb;

   wire A, B, C, D, E;
   integer k=0;

   assign {A,B,C} = k;
   example_3_1 the_circuit(A, B, C, D, E);

   initial begin

      $dumpfile("example_3_1.vcd");
      $dumpvars(0, example_3_1_tb);

      for (k=0; k<8; k=k+1)
        #10 $display("done testing case %d", k);

      $finish;

   end

endmodule
