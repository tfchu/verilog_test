/**
icarus verilog: .name cannot work

VCS
answer is TRUE
answer == TRUE is 1     // answer.name == TRUE is 0 (false)
*/
module tb;

    typedef enum { TRUE, FALSE } e_true_false_t;
    //enum {TRUE, FALSE} answer;

    initial begin
        e_true_false_t answer;
        answer = TRUE;
        $display("answer is %s", answer.name);      // or .name(), C does not have .name
        $display("answer == TRUE is %0b", answer == TRUE);
    end

endmodule