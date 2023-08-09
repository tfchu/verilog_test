/**
VCS: sum3, sum4 not working!

sum1(3,4) = 7
sum2(3,4) = 7
fn_val(1) = 60          // (1 + 5) * 10
tmp = 1                 // tmp remains unchanged after pass-by-val
fn_ref(6) = 60          // tmp is changed after pass-by-ref, hence (6), value is still 1 when passing into fn
tmp = 6                 // tmp is changed after pass-by-ref
*/
module tb;
    initial begin
        int result, s, tmp;
        s = sum1(3, 4);
        $display("sum1(3,4) = %0d", s);

        $display("sum2(3,4) = %0d", sum2(3, 4));

        // $display("sum3(3,4) = %0d", sum3(3, 4));
        // $display("sum4(3,4) = %0d", sum4(3, 4, result));
        // $display("result = %0d", result);

        tmp = 1;
        $display("fn_val(%0d) = %0d", tmp, fn_val(tmp));
        $display("tmp = %0d", tmp);

        $display("fn_ref(%0d) = %0d", tmp, fn_ref(tmp));
        $display("tmp = %0d", tmp);
    end

    // ANCI-C return 1
    function byte sum1(int x, int y);
        sum1 = x + y;
    endfunction

    // ANCI-C return 2
    function byte sum2(int x, int y);
        return x + y;
    endfunction

    // // old style
    // function bit [7:0] sum3;
    //     intput x, y;
    //     output sum3;
    //     sum3 = x + y;
    // endfunction

    // // old style with inline argument
    // function byte sum4(intput int x, y, output int res);
    //     res = x + y + 1;
    //     return x + y;
    // endfunction

    // pass-by-val
    function int fn_val(int a);
        a = a + 5;
        return a * 10;
    endfunction

    // pass-by-ref
    function int fn_ref(ref int a);
        a = a + 5;
        return a * 10;
    endfunction    
endmodule