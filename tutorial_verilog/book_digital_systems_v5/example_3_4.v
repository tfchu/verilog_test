// Verilog model: Circuit with boolean expressions
module example_3_4(E, F, A, B, C, D);
   
   output E, F;
   input  A, B, C, D;

   assign E = A || (B && C) || ((!B) && D);
   assign F = ((!B) && C) || (B && (!C) && (!D));

endmodule
