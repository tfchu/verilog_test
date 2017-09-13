// Design
// D flip-flop
// if reset = H, Q goes L
// On posedge of CLK (and reset = 0), Q = D
module dff (clk, reset,
  d, q, qb);
  input      clk;
  input      reset;
  input      d;
  output     q;
  output     qb;

  reg        q;

  assign qb = ~q;

  always @(posedge clk or posedge reset)
  begin
    if (reset) begin
      // Asynchronous reset when reset goes high
      q <= 1'b0;
    end else begin
      // Assign D to Q on positive clock edge
      q <= d;
    end
  end
endmodule