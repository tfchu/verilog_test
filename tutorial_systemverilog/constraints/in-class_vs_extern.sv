/**
constraint can be defined in 2 ways
1. in-class
2. external (implicit or explicit with "extern")
both have the same effect

module tb_constraint;
ABC: 3 ~ 6
abc mode = 0x3
abc mode = 0x3
abc mode = 0x5
abc mode = 0x6
abc mode = 0x3

DEF: 3 ~ 6
def mode = 0x3
def mode = 0x3
def mode = 0x5
def mode = 0x5
def mode = 0x6

module tb_disable_c;
abc constraint is disabled
abc mode = 0x5              // after disabling the constraint, mode can be any value among 0x0 ~ 0xF
abc mode = 0xe
abc mode = 0x6
abc mode = 0xc
abc mode = 0xc

*/
class ABC;
    rand bit [3:0] mode;

    // in-class constraint
    constraint c_mode {
        mode > 2;
        mode <= 6;
    }
endclass

class DEF;
    rand bit [3:0] mode;

    // external constraint
    constraint c_implicit;          // implicit (no extern)
    extern constraint c_explicit;   // explicit (extern)
endclass
constraint DEF::c_implicit {
    mode > 2;
};
constraint DEF::c_explicit {
    mode <= 6;
};

module tb_constraint;

    ABC abc;
    DEF def;

    initial begin
        abc = new();
        for (int i = 0; i < 5; i++) begin
            abc.randomize();
            $display("abc mode = 0x%0h", abc.mode);
        end
    end

    initial begin
        def = new();
        for (int i = 0; i < 5; i++) begin
            def.randomize();
            $display("def mode = 0x%0h", def.mode);
        end
    end
endmodule

// disable constraint with constraint_mode()
module tb_disable_c;
    ABC abc;

    initial begin
        abc = new();
        abc.c_mode.constraint_mode(0);            // disable the constraint

        if (abc.c_mode.constraint_mode())
            $display("abc constraint is enabled");
        else
            $display("abc constraint is disabled");

        for (int i = 0; i < 5; i++) begin
            abc.randomize();
            $display("abc mode = 0x%0h", abc.mode);
        end
    end
endmodule