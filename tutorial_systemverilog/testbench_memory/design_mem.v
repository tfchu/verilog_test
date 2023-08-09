/**

*/
module memory
    #(  
    parameter ADDR_WIDTH = 2,
    parameter DATA_WIDTH = 8
    )
    (
        input clk,
        input reset,
        
        //control signals
        input [ADDR_WIDTH-1:0]  addr,
        input                   wr_en,
        input                   rd_en,
        
        //data signals
        input  [DATA_WIDTH-1:0] wdata,
        output [DATA_WIDTH-1:0] rdata
    ); 
    
    reg [DATA_WIDTH-1:0] rdata;
    
    //Memory, entire memory range store in array mem
    reg [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH];

    //Reset, set the mem array value to 8h'FF (default reset value)
    always @(posedge reset) 
        for(int i=0;i<2**ADDR_WIDTH;i++) mem[i]=8'hFF;
    
    // Write data to Memory
    always @(posedge clk) 
        if (wr_en)    mem[addr] <= wdata;   // if wr_en, store data

    // Read data from memory
    always @(posedge clk)
        if (rd_en) rdata <= mem[addr];      // if rd_en, load data

endmodule