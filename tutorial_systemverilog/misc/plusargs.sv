/**
both $test$plusargs and $value$plusargs search the list of plusargs
- $test$plusargs does not need a value
- $value$plusargs can extract the value, arg=value (no space before and after =)

module tb_test;
EDA Playground run options
+STANDBY

STANDBY argument is found
STAND argument is found
S argument is found

module tb_value;
EDA Playground run options
+STRING="Joey"      STRING with quote has a value "Joey"
+STRING=Joey        STRING with quote has a value Joey
+NUMBER=123         NUMBER with %0d has a value 123     // note, both %0d, %0h use %0d in $display()
                    NUMBER with %0h has a value 7b

comiler option 
+define+RUNTIME_ERR         // define a macro
and run option
+STRING=Joey

STRING with quote has a value Joey
STRING with %0d has a value 
*/

module tb_test;
    initial begin
        if ($test$plusargs("STANDBY"))              // is "STANDBY" in the plusargs list -> yes
            $display("STANDBY argument is found");
        if ($test$plusargs("standby"))              // is "STANDBY" in the plusargs list -> no, as case-sensitive
            $display("standby argument is found");
        if ($test$plusargs("STAND"))                // is "STAND" in the plusargs list -> yes, STAND is part of STANDBY
            $display("STAND argument is found");    
        if ($test$plusargs("S"))                    // is "S" in the plusargs list -> yes, S is part of STANDBY
            $display("S argument is found");      
    end
endmodule

module tb_value;
    initial begin
        string var1, var2;
        bit [31:0] data;

        if ($value$plusargs("STRING=%s", var1))         // match +STRING="Joey"
            $display("STRING with FS has a value %s", var1);
        // if ($value$plusargs("STRING=", var1))
        //     $display("STRING without FS has a value %s", var1);
        if ($value$plusargs("NUMBER=%0d", data))        // match +NUMBER=123
            $display("NUMBER with %%0d has a value %0d", data);         
        if ($value$plusargs("NUMBER=%0h", data))        // match +NUMBER=123
            $display("NUMBER with %%0h has a value %0d", data);  
    `ifdef RUNTIME_ERR
        if ($value$plusargs("STRING=%d", var2))
            $display("STRING with %%0d has a value %s", var2);
    `endif
    end
endmodule