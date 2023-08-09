/**
soft constraints give the solver flexibility to use the constraints with higher priority if there're conflicts

if both in-class constraints and inline user constraints are hard, then compiler shows error due to conflicts

abc.data = 2
abc.data = 2
abc.data = 2
abc.data = 2
abc.data = 2
*/

class ABC;
    rand bit [3:0] data;

    constraint c_data {
        soft data >= 4;     // constraint "c_data" to be soft, not just >= 4
        data <= 12;
    }
endclass

module tb_soft;
    ABC abc;

    initial begin
        abc = new();
        for (int i = 0; i < 5; i++) begin
            abc.randomize() with {
                data == 2;  // this in-line constraint overwrites soft constraint, so data equals 2
            };
            $display("abc.data = %0d", abc.data);
        end
    end
endmodule

