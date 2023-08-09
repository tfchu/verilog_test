/**

use foreach constraint for multi-dimensional array 

2-row (i), 5-column (j)
i/j 0   1   2   3   4
0   b   b   b   b   b
1   b   b   b   b   b

each "b" is 20-bit, index k
|4|     |3|     |2|     |1|     |0|
|3|2|1|0|3|2|1|0|3|2|1|0|3|2|1|0|3|2|1|0|

md_array = '{'{'hf0f0f, 'hf0f0f, 'hf0f0f, 'hf0f0f, 'hf0f0f}, '{'hf0f0f, 'hf0f0f, 'hf0f0f, 'hf0f0f, 'hf0f0f}} 
*/

class ABC;
    rand bit [4:0][3:0] md_array[2][5];

    constraint c_md_array {
        foreach (md_array[i]) {
            foreach (md_array[i][j]) {
                foreach (md_array[i][j][k]) {
                    if (k %2 == 0)                  // k = 4, 2, 0, so "b" = 0xF0F0F
                        md_array[i][j][k] == 'hF;
                    else
                        md_array[i][j][k] == 0;
                }
            }
        }
    }
endclass

module tb;
    initial begin
        ABC abc = new();
        abc.randomize();
        $display("md_array = %p", abc.md_array);    
    end
endmodule