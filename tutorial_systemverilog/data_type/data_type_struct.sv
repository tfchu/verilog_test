/**
icarus verilog 0.10.0 coredump

VCS
wallet = '{coins:5, dollars:19.75}
wallet = '{coins:1, dollars:9.75}
wallet = '{coins:0, dollars:0}
wallet = '{coins:1, dollars:2}

*/

/* struct */
typedef struct {
    int coins;
    real dollars;
} s_money;

s_money wallet;

struct {
    int A, B, C;
} ABC = '{3{1}};            // all to 1
    
module tb;

    initial begin
        wallet = '{5, 19.75};                   // assign by order
        $display("wallet = %p", wallet);
        wallet = '{coins: 1, dollars: 9.75};    // assign by name
        $display("wallet = %p", wallet);
        wallet = '{default: 0};                 // assign all to 0
        $display("wallet = %p", wallet);
        wallet = s_money'{int: 1, dollars: 2};  // assign by type
        $display("wallet = %p", wallet);

        // s_money purse[1:0] = '{'{2, 4.25}, '{7, 1.5}};  // array, assign by order, not working    
        // $display("wallet[0] = %p", wallet[0]);
        // $display("wallet[1] = %p", wallet[1]);
    end

    //initial 
    //$monitor("wallet = %p", wallet);      // cannot use monitor
endmodule