/**
# KERNEL: q[          0] = 8'b10101010
# KERNEL: q[          1] = 8'b01010101
# KERNEL: q[          0] = 8'b01010101
# KERNEL: q[          1] = 8'b10101010
**/
module tb();
    //bit clk;
    bit [7:0] q[$];
    bit [7:0] temp;

    //always #5 clk = ~clk;

    initial begin
        q.push_back(8'b10101010);
        q.push_back(8'b01010101);
        // before
        print(q);
        // reverse bit order for each byte in q
        foreach(q[i]) begin
            temp = {<<1{q[i]}};
            q[i] = temp;
        end
        // after
        print(q);

    end
    
    function void print(bit [7:0] q[$]);
        foreach(q[i]) begin
            $display("q[%d] = 8'b%b", i, q[i]);
        end
    endfunction
endmodule