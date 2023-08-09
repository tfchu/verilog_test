/**
VCS

module tb_unique_if;
x is neither 3 or 5

Warning-[RT-NCMUIF] No condition matches in statement
testbench.sv, 14
  No condition matches in 'unique if' statement. 'else' statement is missing 
  for the last 'else if' block, inside tb, at time 0ns.

module tb_priority_if;
x is neither 3 or 5

Warning-[RT-NCMPRIF] No condition matches in statement
testbench.sv, 16
  No condition matches in 'priority if' statement. 'else' statement is missing
  for the last 'else if' block, inside tb_priority_if, at time 0ns.

*/

module tb_unique_if;
    int x = 4;

    initial begin
        // unique-if with else, no error
        unique if (x == 3)
            $display("x is %0d", x);
        else if (x == 5)
            $display("x is %0d", x);
        else
            $display("x is neither 3 or 5");

        // unique-if without else, error is thrown
        unique if (x == 3)
            $display("x is %0d", x);
        else if (x == 5)
            $display("x is %0d", x);
    end
endmodule

module tb_priority_if;
    int x = 4;

    initial begin
        // priority-if with else, no error
        priority if (x == 3)
            $display("x is %0d", x);
        else if (x == 5)
            $display("x is %0d", x);
        else
            $display("x is neither 3 or 5");

        // priority-if without else, error is thrown
        priority if (x == 3)
            $display("x is %0d", x);
        else if (x == 5)
            $display("x is %0d", x);
    end
endmodule