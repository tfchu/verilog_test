/**
when a non-static constraint is turned off, it affect only the calling instance
when a static constraint is turned off (constraint_mode(0)), it affects ALL instances

obj1.a = 9, obj2.a = 11
obj1.a = 12, obj2.a = 15
obj1.a = 13, obj2.a = 15
obj1.a = 11, obj2.a = 13
obj1.a = 8, obj2.a = 6
*/

class ABC;
    rand bit [3:0] a;

    constraint c1 {
        a > 5;
    }

    static constraint c2 {
        a < 12;                     // c1 + c2 limits a to 6, 7, 8, 9, 10, 11
    }
endclass

module tb;
    initial begin
        ABC obj1 = new;
        ABC obj2 = new;

        obj1.c2.constraint_mode(0); // turn off a static constraint, affecting both obj1, obj2

        for (int i = 0; i < 5; i++) begin
            obj1.randomize();
            obj2.randomize();
            $display("obj1.a = %0d, obj2.a = %0d", obj1.a, obj2.a);
        end
    end
endmodule