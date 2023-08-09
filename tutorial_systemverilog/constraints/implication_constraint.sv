/**
implication "->" and if-else are equivalent. 2 ways to specify conditional statements. 

abc_im mode = 0xa, mode_en = 0x1; abc_if mode = 0xc, mode_en = 0x0
abc_im mode = 0xa, mode_en = 0x1; abc_if mode = 0xc, mode_en = 0x0
abc_im mode = 0xd, mode_en = 0x0; abc_if mode = 0x1, mode_en = 0x0
abc_im mode = 0x5, mode_en = 0x1; abc_if mode = 0x1, mode_en = 0x0
abc_im mode = 0x0, mode_en = 0x1; abc_if mode = 0x9, mode_en = 0x1
abc_im mode = 0x4, mode_en = 0x0; abc_if mode = 0x1, mode_en = 0x0
abc_im mode = 0x0, mode_en = 0x1; abc_if mode = 0xd, mode_en = 0x0
abc_im mode = 0xf, mode_en = 0x1; abc_if mode = 0x7, mode_en = 0x1
abc_im mode = 0xe, mode_en = 0x0; abc_if mode = 0x2, mode_en = 0x0
abc_im mode = 0xe, mode_en = 0x0; abc_if mode = 0xe, mode_en = 0x0

*/

// use implication "->" for constraint
class ABC_implication;
    rand bit [3:0] mode;
    rand bit mode_en;

    constraint c_mode {
        mode inside {[4'h5:4'hB]} -> mode_en == 1;  // mode_en is 1 if mode is 0x5 ~ 0xB. so if mode is NOT 0x5 ~ 0xB, mode_en can be any random value. 
    }
endclass

// use if-else for constraint
class ABC_if;
    rand bit [3:0] mode;
    rand bit mode_en;

    constraint c_mode {
        if (mode inside {[4'h5:4'hB]})              // mode_en is 1 if mode is 0x5 ~ 0xB. so if mode is NOT 0x5 ~ 0xB, mode_en can be any random value. 
            mode_en == 1;
        else {                                      // using if allows "else"
            mode_en == 0;                           // constraint is classified as declarative code, use curly braces {} instead of begin ... end
        }
    }
endclass

module tb;
    initial begin
        ABC_implication abc_im = new();
        ABC_if abc_if = new();

        for (int i = 0; i < 10; i++) begin
            abc_im.randomize();
            abc_if.randomize();
            $display("abc_im mode = 0x%0h, mode_en = 0x%0h; abc_if mode = 0x%0h, mode_en = 0x%0h", abc_im.mode, abc_im.mode_en, abc_if.mode, abc_if.mode_en);
        end
    end
endmodule