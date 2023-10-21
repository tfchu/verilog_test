module ff_infer_dedicated_reset (clk, rstn);
    input clk, rstn; 

    reg [1:0] cnter;
    wire [1:0] cnter_nxt;

    assign cnter_nxt = (cnter == 2'b11) ? 2'b00 : (cnter + 1'b1);

    always @(posedge clk or negedge rstn) begin
        // dedicated reset 
        if (!rstn)
            cnter <= 'd0;
        else
            cnter <= cnter_nxt;
    end
endmodule

module ff_infer_no_dedicated_reset (clk, rst_cnter);
    input clk, rst_cnter;

    reg [1:0] cnter, cnter_nxt;

    assign cnter_nxt = rst_cnter ? 2'b00 : ((cnter == 2'b11) ? 2'b00 : (cnter + 1));

    always @(posedge clk) begin
        cnter <= cnter_nxt;
    end
endmodule