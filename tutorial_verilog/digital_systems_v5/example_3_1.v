// Verilog model of circuit of Figure 3.35 in Digital Systems 5th ed. 

module example_3_1(A, B, C, D, E);
   
   output D, E;
   input  A, B, C;
   wire   w1;

   and G1(w1, A, B);
   not G2(E, C);
   or  G3(D, w1, E);

endmodule

     
