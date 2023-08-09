/**
module parameters - like function parameters

parameters are generally constants, initialized during module instantiation, or use #defparam to change it later in test bench

*/

// counter module with parameters
module counter
#(  
    parameter N = 2,    // nr of bits
    parameter DOWN = 0  // up or down counter, default up
) 
(
    input                   clk,
    input                   rstn, 
    input                   en,
    output reg [N-1 : 0]    out
);

    always @(posedge clk) begin
        if (!rstn) begin        // reset (Active low), when low, out set to 0
            out <= 0;
        end else begin
            if (en)             // enable
                if (DOWN)       // DOWN counter
                    out <= out - 1;
                else            // UP counter
                    out <= out + 1;
            else                // disable
                out <= out;
        end
    end
endmodule

// this module includes a 2-bit up counter
module design_top_2b_up
(
    input clk, 
    input rstn,
    input en,
    output [1:0] out
);

    // instantiate a 2-bit up counter
    counter #(.N(2)) u0 (
        .clk(clk),
        .rstn(rstn),
        .en(en)
    );

endmodule

// this module includes a 4-bit down counter
module design_top_4b_down
(
    input clk, 
    input rstn,
    input en,
    output [3:0] out
);

    // instantiate a 4-bit down counter
    counter #(.N(4), .DOWN(1)) u0 (
        .clk(clk),
        .rstn(rstn),
        .en(en)
    );

endmodule