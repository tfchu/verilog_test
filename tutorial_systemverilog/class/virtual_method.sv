/**
child instance invoking A()

output for each case
- case 1: parent virtual A(), virtual B()
    - child does not override
        # KERNEL: parent A
        # KERNEL: parent B    
    - child overrides B() - special case, child overrides virtual method B, child B() is called
        # KERNEL: parent A
        # KERNEL: child B    
- case 2: parent virtual A(), non-virtual B()
    - child does not override
        # KERNEL: parent A
        # KERNEL: parent B
    - child overrides B()
        # KERNEL: parent A
        # KERNEL: parent B
*/


class parent;
    virtual function void A;
        $display("parent A");
        B();
    endfunction
    function void B;
        $display("parent B");
    endfunction
endclass

class child extends parent;
    //function void B;
    //    $display("child B");
    //endfunction
endclass

module tb;
  child c;
  initial begin
    c = new();
    c.A();
  end
endmodule