/**
https://circuitfever.com/logic-gates-verilog-code

compare structural modeling, data flow modeling and behavioural modeling
NOT, AND, OR, NAND, NOR, XOR, XNOR

all generate the same schematics
**/

// NOT gate
// structural modeling
module not_gate_s(a,y);
    input a;
    output y;

    not(y,a);
endmodule

// data flow modeling
module not_gate_d(a,y);
    input a;
    output y;

    assign y = ~a;
endmodule

// behavioural modeling
module not_gate_b(a,y);
    input a;
    output reg y;

    always @ (a)
        y = ~a;     
endmodule

// AND gate
// structural modeling
module and_gate_s(a,b,y);
    input a,b;
    output y;

    and(y,a,b);      
endmodule

// data flow modeling
module and_gate_d(a,b,y);
    input a,b;
    output y;

    assign y = a & b;
endmodule

// behavioural modeling
module and_gate_b(a,b,y);
    input a;
    output y;

    always @ (a,b)
        y = a & b;   
endmodule

// OR gate
// Structural modeling
module or_gate_s(a,b,y);
    input a,b;
    output y;

    or(y,a,b);   
endmodule

// data flow modeling
module or_gate_d(a,b,y);
    input a,b;
    output y;

    assign y = a | b;              
endmodule

// behavioural modeling
module or_gate_b(a,b,y);
    input a;
    output y;

    always @ (a,b)
        y = a | b;        
endmodule

// NAND gate
module nand_gate_s(a,b,y);
    input a,b;
    output y;

    nand(y,a,b);      
endmodule

// data flow modeling
module nand_gate_d(a,b,y);
    input a,b;
    output y;

    assign y = ~(a & b);    
endmodule

// behavioural modeling
module nand_gate_b(a,b,y);
    input a;
    output reg y;

    always @ (a,b)
    y = ~(a & b);   
endmodule

// NOR
Structural modeling
    module nor_gate_s(a,b,y);
    input a,b;
    output y;

    nor(y,a,b);
endmodule

// data flow modeling
module nor_gate_d(a,b,y);
    input a,b;
    output y;

    assign y = ~(a | b);  
endmodule

// behavioural modeling
module nor_gate_b(a,b,y);
    input a;
    output reg y;

    always @ (a,b)
    y = ~(a | b);
endmodule

// XOR
// Structural modeling
module xor_gate_s(a,b,y);
    input a,b;
    output y;

    xor(y,a,b);
endmodule

// data flow modeling
module xor_gate_d(a,b,y);
    input a,b;
    output y;

    assign y = a ^ b;
endmodule

// behavioural modeling
module xor_gate_b(a,b,y);
    input a;
    output reg y;

    always @ (a,b)
    y = a ^ b;
endmodule

// XNOR
// Structural modeling
module xnor_gate_s(a,b,y);
    input a,b;
    output y;

    xnor(y,a,b);
endmodule

// data flow modeling
module xnor_gate_d(a,b,y);
    input a,b;
    output y;

    assign y = ~(a ^ b);
endmodule

// behavioural modeling
module xor_gate_b(a,b,y);
    input a;
    output reg y;

    always @ (a,b)
    y = ~(a ^ b);
endmodule