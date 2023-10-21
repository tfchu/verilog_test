/**
[x +: y]: indexed part select, start from bit x, total legth y bits

output
byte0: af, byte1: be,byte2: ad, byte3: de

note. using dword[0:7] in $display causes compile error, need to use [7:0]
**/

module m;

    reg [31:0] dword = 32'hdeadbeaf;
    reg [7:0] byte0;
    reg [7:0] byte1;
    reg [7:0] byte2;
    reg [7:0] byte3;

    assign byte0 = dword[0 +: 8];    // Same as dword[7:0]
    assign byte1 = dword[8 +: 8];    // Same as dword[15:8]
    assign byte2 = dword[16 +: 8];   // Same as dword[23:16]
    assign byte3 = dword[24 +: 8]; 

    initial begin
        $display("byte0: %0h, byte1: %0h,byte2: %0h, byte3: %0h", byte0, byte1, byte2, byte3);
    end

endmodule