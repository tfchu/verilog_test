// Verilog test bench for example_3_4
`timescale 1ns/100ps
`include "example_3_4.v"

module example_3_4_tb;

   wire A, B, C, D, E, F;
   integer k=0;

   assign {A,B,C,D} = k;
   example_3_4 the_circuit(E, F, A, B, C, D);

   initial begin

      $dumpfile("example_3_4.vcd");
      $dumpvars(0, example_3_4_tb);

      for (k=0; k<16; k=k+1)
        #10 $display("done testing case %d", k);

      $finish;

   end 

endmodule

      
               
