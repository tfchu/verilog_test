/**

array = '{'ha, 'h0, 'h0, 'h6, 'h4} 
*/
class ABC;
    rand bit [3:0] array [5];

    constraint c_sum {
        array.sum() with (int'(item)) == 20;    // sum of array items equals 20, int'() is cast operator, "item" is keyword for array items
    }
endclass

module tb;
    initial begin
        ABC abc = new();
        abc.randomize();
        $display("array = %p", abc.array);    
    end
endmodule