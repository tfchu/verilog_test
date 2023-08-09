/* 
module tb;

myFIFO[0] = 0x0
myFIFO[1] = 0x0
myFIFO[2] = 0x0
myFIFO[3] = 0x0
myFIFO[4] = 0x0
myFIFO[5] = 0xfacecafe
myFIFO[6] = 0x0
myFIFO[7] = 0x0
myArray[0][0] = 0x0
myArray[0][1] = 0x0
myArray[0][2] = 0x0
myArray[1][0] = 0x0
myArray[1][1] = 0x7
myArray[1][2] = 0x0
bit_arr[0] = 0          // use [7:0]
bit_arr[1] = 1
bit_arr[2] = 0
bit_arr[3] = 0
bit_arr[4] = 0
bit_arr[5] = 1
bit_arr[6] = 0
bit_arr[7] = 1

bit_arr[0] = 1          // use [0:7]
bit_arr[1] = 0
bit_arr[2] = 1
bit_arr[3] = 0
bit_arr[4] = 0
bit_arr[5] = 0
bit_arr[6] = 1
bit_arr[7] = 0
*/

module tb;

    /* array */
    int myFIFO[0:7];    // 1-D array
    int urFIFO[8];      // equivalent to above

    int myArray [2][3]; // 2-D array

    bit [7:0] bit_arr;  // bit array, [7:0] data starts from MSB, [0:7] data start from LSB

    initial begin
        myFIFO[5] = 32'hface_cafe;
        myArray[1][1] = 7;
        bit_arr = 8'hA2;        // 1010_0010b

        // loop 1-D array
        foreach (myFIFO[i])
            $display("myFIFO[%0d] = 0x%0h", i, myFIFO[i]);

        // loop 2-D array
        foreach (myArray[i,j])
                $display("myArray[%0d][%0d] = 0x%0d", i, j, myArray[i][j]);

        // loop bit array
        for (int i = 0; i < $size(bit_arr); i++) begin
            $display("bit_arr[%0d] = %0b", i, bit_arr[i]);
        end
    end

endmodule

/**
cannot use monitor

'=: assignment
=: concatenate

(1) a1='{1, 2, 3} , a2='{0, 0, 0, 0, 0, 0, 0, 0, 0} 
(2) Unpacked array of type 'int$[1:9]' can't be assigned by multiple 
  concatenation operator {3 {a1}}
  However, repeat assignment pattern can be assigned to unpacked arrays. Add a
  ' before the multiple concatenation operator to convert it to a valid 
  assignment pattern.
(3) Assignment pattern is illegal due to: Assignment Pattern is incomplete, all 
  fields must be assigned.
(4) a1='{1, 2, 3} , a2='{1, 2, 3, 4, 5, 6, 1, 2, 3} 
(5) a1='{1, 2, 3} , a2='{1, 1, 1, 1, 1, 1, 1, 1, 1} 
(6) Unpacked array of type 'int$[1:9]' can't be assigned by multiple 
  concatenation operator {9 {1}}
  However, repeat assignment pattern can be assigned to unpacked arrays. Add a
  ' before the multiple concatenation operator to convert it to a valid 
  assignment pattern.
*/
module tb_assign_concat;
    int a1[1:3];
    int a2[1:9];

    initial begin
        // (1)
        a1 = '{1, 2, 3};
        $display("a1=%p, a2=%p", a1, a2);
        // (2)
        a2 = {3{a1}};
        $display("a1=%p, a2=%p", a1, a2);
        // (3)
        a2 = '{3{a1}};
        $display("a1=%p, a2=%p", a1, a2);
        // (4)
        a2 = {a1, 4, 5, 6, a1};
        $display("a1=%p, a2=%p", a1, a2);
        // (5)
        a2 = '{9{1}};
        $display("a1=%p, a2=%p", a1, a2);
        // (6)
        a2 = {9{1}};
        $display("a1=%p, a2=%p", a1, a2);
    end
endmodule