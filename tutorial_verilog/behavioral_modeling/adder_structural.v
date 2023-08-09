module Full_Adder_Structural_Verilog( 
    input X1, X2, Cin, 
    output S, Cout
);  
    wire a1, a2, a3;    
    xor u1(a1,X1,X2);
    and u2(a2,X1,X2);
    and u3(a3,a1,Cin);
    or u4(Cout,a2,a3);
    xor u5(S,a1,Cin); 
endmodule  

`timescale 10ns/ 10ps;
module Testbench_structural_adder();
    reg A,B,Cin;
    wire S,Cout;  
    //Verilog code for the structural full adder 
    Full_Adder_Structural_Verilog structural_adder(
        .X1(A),
        .X2(B),
        .Cin(Cin),
        .S(S),
        .Cout(Cout) 
    );

    initial begin
        A = 0;
        B = 0;
        Cin = 0;
        #10;
        A = 0;
        B = 0;
        Cin = 1;
        #10;  
        A = 0;
        B = 1;
        Cin = 0;
        #10;
        A = 0;
        B = 1;
        Cin = 1;
        #10;
        A = 1;
        B = 0;
        Cin = 0;
        #10;
        A = 1;
        B = 0;
        Cin = 1;
        #10;
        A = 1;
        B = 1;
        Cin = 0;
        #10;  
        A = 1;
        B = 1;
        Cin = 1;
        #10;  
    end
endmodule 