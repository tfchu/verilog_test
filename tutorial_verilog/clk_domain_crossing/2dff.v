/**
EDA playground
https://www.edaplayground.com/x/wzPx

2 DFF synchronizer design for CDC (clock domain crossing)
- provide 1~2 cycle delay depending on when data input is set, e.g. CPU interrupt reading

**/

module dff_sync2(
   input clk,
   input rstn,
   input d,
   output q_synced
);
    reg sync_flop1;
    reg sync_flop2;
    
    /*
    2 D-flipflops
    d -> |dff| -> sync_flop1 -> |dff| -> sync_flop2
                t1        t2        t3        t4
    clk     ____|‾‾‾‾|____|‾‾‾‾|____|‾‾‾‾|____|‾‾‾‾|____ ...
    rst     ____|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾ ...
    d       _______________|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾ ...
    sflop1  ________________________|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾ ...
    q_synced__________________________________|‾‾‾‾‾‾‾‾‾ ...

    t           t1  t2  t3  t4
    d           0   0   1   1
    sync_flop1  0   0   1   1       // d at posedge clk
    sync_flop2  0   0   0   1       // sync_flop1 at posedge clk
    */
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            sync_flop1 <= 1'b0;
            sync_flop2 <= 1'b0;
        end
        else begin
            sync_flop1 <= d;
            sync_flop2 <= sync_flop1;.
        end
    end
    assign q_synced = sync_flop2;
endmodule 

module dff_sync2_test;
    reg clk;
    reg rstn;
    reg d;
    wire q_synced;
    //wire q;
    //wire qb;
    
    // Instantiate design under test
    dff_sync2 DFF_SYNC (.clk(clk), .rstn(rstn), .d(d), .q_synced(q_synced));

    initial begin
        clk = 0;
        rst = 0;
    end
    
    always begin
        #5 clk = ~clk;
    end 
            
    initial begin
        // Dump waves
        $dumpfile("dump.vcd"); $dumpvars(1);
        
        // $display("Reset flop.");
            //clk = 0;
            //rst = 1;
        // d = 1'bx;
        // display;
        
        $display("Release reset.");
        #5 rstn = 1;
            
        display;
        #10 d = 1;

        //$display("Toggle clk.");
        //clk = 1;
        //display;
    end
    
    task display;
        #1 $display("d:%0h, q_synced:%0h", d, q_synced);
    endtask

endmodule