/**
use $cast as a task

money = QUARTER
money = DIME
*/

typedef enum { 
    PENNY = 1, 
    NICKEL = 5, 
    DIME = 10, 
    QUARTER = 25, 
    DOLLAR = 100
} cent_t;

module tb;
    cent_t my_cent;

    initial begin
        $cast(my_cent, 10 + 5 + 10);                // $cast() as a task
        $display("money = %s", my_cent.name());

        if ($cast(my_cent, 5 + 5))                  // $cast() as a function
            $display("money = %s", my_cent.name()); 
    end
endmodule