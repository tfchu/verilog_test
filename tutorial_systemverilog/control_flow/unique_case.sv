/**
VCS
x is neither 3 or 5

*/
module tb_unique_case;
    int x = 4;

    initial begin
        // unique-if with else, no error
        unique case(x)
            3: $display("x is %0d", x);
            5: $display("x is %0d", x);
            default: $display("x is neither 3 or 5");
        endcase
    end
endmodule