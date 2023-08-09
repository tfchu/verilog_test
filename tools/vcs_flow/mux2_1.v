module mux2_1 ( out, in0, in1, sel ) ;

   input  [3:0] in0, in1;
   input  sel;

   output [3:0] out;

   // All the real work gets done here in the assign.
   assign       out = sel ? in1 : in0;

endmodule // mux2_1