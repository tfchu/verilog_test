// Verilog model: User-defined Primitive
primitive example_3_5(D, A, B, C);

   output D;
   input  A, B, C;

   // Truth table for D = f(A, B, C) = sum(0, 2, 4, 6, 7)
   table
      // A B C : D
      0 0 0 : 1;
      0 0 1 : 0;
      0 1 0 : 1;
      0 1 1 : 0;
      1 0 0 : 1;
      1 0 1 : 0;
      1 1 0 : 1;
      1 1 1 : 1;
   endtable
      
endprimitive
