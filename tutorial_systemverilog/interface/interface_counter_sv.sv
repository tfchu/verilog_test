/**

[0] down=0, load_en=0, load=0x0, rollover=00
[94] down=1, load_en=1, load=0xd, rollover=00
[98] down=1, load_en=1, load=0xa, rollover=00
[102] down=1, load_en=0, load=0x6, rollover=00
[106] down=1, load_en=1, load=0xb, rollover=00
[110] down=0, load_en=0, load=0xf, rollover=10110
[130] down=0, load_en=0, load=0xf, rollover=11000
[150] down=0, load_en=0, load=0xf, rollover=11010
[170] down=0, load_en=0, load=0xf, rollover=11100
[190] down=0, load_en=0, load=0xf, rollover=11111

*/

// i/f
interface counter_if
#(parameter WIDTH = 4)
(input bit clk);
    logic                   rstn;
    logic                   load_en;
    logic [WIDTH-1:0]       load;
    logic [WIDTH-1:0]       count;
    logic                   down;
    logic                   rollover;
endinterface

// counter module with parameters and connect to interface
module counter
#(  
    parameter WIDTH = 4    // nr of bits
) 
(
    counter_if cif
);

    always @(posedge cif.clk or negedge cif.rstn) begin
        if (!cif.rstn)              // reset on resn low, count set to 0
            cif.count <= 0;
        else 
            if (cif.load_en)        // set count to load if load_en
                cif.count <= cif.load;
            else begin
                if (cif.down)       // down counter, derement out on posedge of clk
                    cif.count <= cif.count - 1;
                else            // up counter, , derement out on posedge of clk
                    cif.count <= cif.count + 1;
            end
    end

    assign cif.rollover = &cif.count;   // indicate counter rolled over
endmodule

module tb;
    reg clk;
    always #10 clk = ~clk;

    // send clk into i/f
    counter_if cif0(clk);
    // counter_if #(.WIDTH(2)) cif0(clk);   // change to 2-bit
    // connect dut "counter" to i/f
    counter c0 (cif0);                      // counter c0 (.cif(cif0));
    // counter #(.WIDTH(2)) c0 (cif0);      // change to 2-bit

    initial begin
        bit load_en, down;
        bit [3:0] load;

        $monitor("[%0t] down=%0b, load_en=%0b, load=0x%0h, rollover=%0b", 
            $time, cif0.down, cif0.load_en, cif0.load, cif0.count, cif0.rollover);

        clk <= 0;
        cif0.rstn <= 0;
        cif0.load_en <= 0;
        cif0.load <= 0;
        cif0.down <= 0;

        repeat (5) @(posedge clk);
        cif0.rstn <= 1;

        for (int i = 0; i < 5; i++) begin
            int delay = $urandom_range(1, 30);
            #(delay);

            std:randomize(load, load_en, down);

            cif0.load <= load;
            cif0.load_en <= load_en;
            cif0.down <= down;
        end

        repeat (5) @(posedge clk);
        $finish;
    end

endmodule