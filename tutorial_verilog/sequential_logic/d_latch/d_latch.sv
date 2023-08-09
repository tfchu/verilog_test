/**
D latch
- truth table
    E D Q Qn
    0 0 Q Qn (latch previous value)
    0 1 Q Qn (latch previous value)
    1 0 0 1
    1 1 1 0

    E (en): 
    - 1: enable D to go to Q
    - 0: latch Q/Qn values
    D (data)
    Q (output)
    Qn (output compliment)

- tb output
    # KERNEL: [                   0] en=0 d=0 q=0
    # KERNEL: [                  11] en=1 d=0 q=0 (q <= d)
    # KERNEL: [                  18] en=0 d=0 q=0
    # KERNEL: [                  19] en=0 d=1 q=0
    # KERNEL: [                  20] en=1 d=1 q=1 (q <= d)
    # KERNEL: [                  25] en=1 d=0 q=0 (q <= d)
    # KERNEL: [                  27] en=0 d=0 q=0
    # KERNEL: [                  32] en=0 d=1 q=0
    # KERNEL: [                  33] en=1 d=1 q=1 (q <= d)
    # KERNEL: [                  34] en=1 d=0 q=0 (q <= d)
**/

module d_latch (
    input d, 
    input en, 
    input rstn, 
    output reg q
);
    always @ (en or rstn or d) begin
        if (!rstn)
            q <= 0;
        else begin
            if (en)
                q <= d;
        end
    end
endmodule

module tb_d_latch;
    reg d;
    reg en;
    reg rstn;
    reg q;
    reg [2:0] delay;
    reg [1:0] delay2;
    integer i;

    d_latch dl0 (.d (d), .en (en), .rstn (rstn), .q (q));

    initial begin
        $dumpfile("dump.vcd"); $dumpvars;
      	$monitor ("[%t] en=%0b d=%0b q=%0b", $time, en, d, q);

        d <= 0;
        en <= 0;
        rstn <= 0;

        #10 rstn <= 1;

        for (i = 0; i < 5; i++) begin
            delay = $random;
            delay2 = $random;
          	#(delay2) en <= ~en;
            #(delay) d <= i;
        end
    end
endmodule