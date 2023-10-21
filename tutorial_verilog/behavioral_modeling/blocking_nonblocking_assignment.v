/**
non-blocking

RHS is captured, then assigned at the end of timestep
**/

module tb;
  int a = 0, b = 1;
  
  initial begin
    a <= b;     // b = 1 is captured
    b <= a;     // a = 0 is captured
    
    $display("%0d %0d", a, b);  // 0 1 (no change)
    #1;
    $display("%0d %0d", a, b);  // 1 0 (assign at the end of timestep)
  end
endmodule

/**
blocking

each statement is executed one after the other
**/
module tb;
  int a = 0, b = 1;
  
  initial begin
    a = b;          // a = 1
    b = a;          // b = a = 1
    
    $display("%0d %0d", a, b);      // 1 1
    #1;
    $display("%0d %0d", a, b);      // 1 1 (the same)
  end
endmodule