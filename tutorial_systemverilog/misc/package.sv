/**
a package encompasses definitions, properties, functions/tasks, ... in one space, so they can be reused

module tb_pkg;
my_signal = GREEN
common() is called


module tb_conflict;
bw1 = BLACK, wb = BLACK
*/

package my_pkg;
    typedef enum bit [1:0] {RED, YELLOW, GREEN} signal_t;
    typedef enum bit {BLACK, WHITE} bw_t;               // BLACK = 0, WHITE = 1
    typedef struct {
        bit [3:0] sig_id;
        bit active;
        bit [1:0] timeout;
    } sig_param_t;
    function common(); 
        $display("common() is called");
    endfunction
endpackage

// import the package
import my_pkg::*;               // :: scope resolution operator
                                // * import everything

typedef enum bit {WHITE, BLACK} wb_t;   // intentional conflict, BLACK = 1, WHITE = 0

class my_class;
    signal_t my_sig;
endclass

module tb_pkg;
    my_class mc;

    initial begin
        mc = new();
        mc.my_sig = GREEN;      // from my_pkg
        $display("my_signal = %s", mc.my_sig.name());
        common();               // from my_pkg
    end    
endmodule

// conflict test
module tb_conflict;
    initial begin
        //bw_t bw = BLACK;            // BLACK from local (1), VCS does NOT allow this assignment, compiler error
        bw_t bw1 = my_pkg::BLACK;   // BLACK from the package (0)
        wb_t wb = BLACK;            // BLACK from local (1)
        $display("bw1 = %s, wb = %s", bw1, wb);
    end    
endmodule