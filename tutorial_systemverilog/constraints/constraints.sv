/**

iter=0, min=5, typ=6, max=12, fixed=5, ins=3, inv_ins=0, dist_e=1, dist_s=1
iter=1, min=9, typ=10, max=11, fixed=5, ins=6, inv_ins=8, dist_e=1, dist_s=3
iter=2, min=4, typ=9, max=12, fixed=5, ins=5, inv_ins=1, dist_e=10, dist_s=5
iter=3, min=7, typ=8, max=10, fixed=5, ins=5, inv_ins=1, dist_e=14, dist_s=9
iter=4, min=5, typ=6, max=12, fixed=5, ins=4, inv_ins=12, dist_e=11, dist_s=3
iter=5, min=5, typ=6, max=7, fixed=5, ins=3, inv_ins=9, dist_e=3, dist_s=2
iter=6, min=4, typ=7, max=8, fixed=5, ins=4, inv_ins=9, dist_e=4, dist_s=2
iter=7, min=4, typ=5, max=7, fixed=5, ins=6, inv_ins=10, dist_e=12, dist_s=0
iter=8, min=7, typ=9, max=11, fixed=5, ins=5, inv_ins=8, dist_e=8, dist_s=1
iter=9, min=5, typ=6, max=12, fixed=5, ins=6, inv_ins=7, dist_e=13, dist_s=2

*/

class my_class;
    rand bit [3:0] min, typ, max;
    rand bit [3:0] fixed;
    rand bit [3:0] ins, inv_ins;
    rand bit [3:0] dist_e, dist_s;  // equal (:=), slash (:/)

    constraint my_range {
        3 < min;                    // min, typ, max range limit
        typ < max; typ > min;
        max < 14;
    }

    constraint c_fixed {
        fixed == 5;                 // fixed must equal 5, NOT assign =
    }

    constraint c_ins {
        ins inside {[3:6]};         // "ins" must be inside 3, 4, 5, 6
    }

    constraint c_inv_ins {
        !(inv_ins inside {[3:6]});  // "inv_ins" must NOT be inside 3, 4, 5, 6
    }

    constraint c_dist_e {                           // weight
        dist_e dist {0:=20, [1:5]:=50, [6:15]:=20}; // 0: 20, 1 ~ 5: 50 each, 6 ~ 15: 20 each, total weight = 1 * 20 + 5 * 50 + 10 * 20 = 470
    }

    constraint c_dist_s {                           // weight
        dist_s dist {0:/20, [1:5]:/60, [6:15]:/20}; // 0: 20, 1 ~ 5: 12 each (total 50), 6 ~ 15: 2 each (total 20), total weight = 100
    }

    function string display(int i);
        return $sformatf("iter=%0d, min=%0d, typ=%0d, max=%0d, fixed=%0d, ins=%0d, inv_ins=%0d, dist_e=%0d, dist_s=%0d", i, min, typ, max, fixed, ins, inv_ins, dist_e, dist_s);
    endfunction

endclass

module tb_constraint;
    my_class mc;

    initial begin
        mc = new();
        for (int i = 0; i < 10; i++) begin
            mc.randomize();
            $display(mc.display(i));
        end
    end

endmodule