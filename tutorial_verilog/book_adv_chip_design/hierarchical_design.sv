module xmit_a
(
    xmit_a_in1, 
    xmit_a_in2,
    xmit_a_out1, 
    xmit_a_out2
);
    input [7:0] xmit_a_in1;
    input xmit_a_in2;
    output [7:0] xmit_a_out1;
    output xmit_a_out2;

    // synthesizable RTL code
    always @(*) begin
        // body
    end
endmodule 

module xmit_b
(
    xmit_b_in1, 
    xmit_b_in2,
    xmit_b_in3,
    xmit_b_out1, 
    xmit_b_out2
);
    input [7:0] xmit_b_in1;
    input xmit_a_in2;
    input xmit_a_in3;
    output [7:0] xmit_b_out1;
    output xmit_a_out2;

    // synthesizable RTL code
    always @(*) begin
        // body
    end
endmodule 

module rcv_c (
    rcv_c_in1, 
    rcv_c_in2, 
    rcv_c_in3, 
    rcv_c_out1, 
    rcv_c_out2, 
);
    input rcv_c_in1;
    input [7:0] rcv_c_in2;
    input rcv_c_in1;
    output [7:0] rcv_c_out1;
    output rcv_c_out2;

    // synthesizable RTL code
    always @(*) begin
        // body
    end
endmodule

module rcv_d (
    rcv_d_in1, 
    rcv_d_in2, 
    rcv_d_out1, 
    rcv_d_out2, 
    rcv_d_out3
);
    input rcv_d_in1;
    input rcv_d_in2;
    output rcv_d_out1;
    output [7:0] rcv_d_out2;
    output rcv_d_out3;

    // synthesizable RTL code
    always @(*) begin
        // body
    end
endmodule

// xmit top (transmitter top)
module xmit_top (
    xmit_top_in1, 
    xmit_top_in2, 
    xmit_top_in3, 
    xmit_top_in4,
    xmit_top_out1, 
    xmit_top_out2, 
    xmit_top_out3
); 
    input [7:0] xmit_top_in1;
    input xmit_top_in2;
    input xmit_top_in3;
    input xmit_top_in4;
    output xmit_top_out1;
    output xmit_top_out2;
    output xmit_top_out3;

    // wire declaration 
    // Declare connecting signals between modules as wires. 
    // Outputs need not be declared as wires as they are considered wires by 
    // definition. 
    wire [7:0] xmit_ab;

    /*
    modules instantiation 
    xmit_a is the module name and should exactly match the lower-level module 
    name. xmit_a_O is the instance name and can be anything but should be unique 
    within a module. Typic%dly it is named as where 'x' can be the 
    instance number 
    */ 
    xmit_a xmit_a_0 (
        .xmit_a_in1 (xmit_top_in1), 
        .xmit_a_in2 (xmit_top_in2),
        .xmit_a_out1 (xmit_ab), 
        .xmit_a_out2 (xmit_top_out3)
    );

    xmit_b xmit_b_0 (
        .xmit_b_in1 (xmit_ab), 
        .xmit_b_in2 (xmit_top_in3),
        .xmit_b_in3 (xmit_top_in4),
        .xmit_b_out1 (xmit_top_out1), 
        .xmit_b_out2 (xmit_top_out2)
    );
endmodule

module rcv_top (
    rcv_top_in1, 
    rcv_top_in2, 
    rcv_top_in3, 
    rcv_top_out1, 
    rcv_top_out2, 
    rcv_top_out3
); 
    input rcv_top_in1;
    input rcv_top_in2;
    input rcv_top_in3;
    output [7:0] rcv_top_out1;
    output rcv_top_out2;
    output rcv_top_out3;

    wire [7:0] rcv_cd1;
	wire rcv_cd2;

    /*
    modules instantiation 
    rcv_c is the module name and should exactly match the lower-level module 
    name. rcv_c_O is the instance name and can be anything but should be unique 
    within a module. Typic%dly it is named as where 'x' can be the 
    instance number 
    */ 
    rcv_c rcv_c_0 (
        .rcv_c_in1 (rcv_top_in1), 
        .rcv_c_in2 (rcv_cd1),
		.rcv_c_in3 (rcv_cd2), 
        .rcv_c_out1 (rcv_top_out1), 
        .rcv_c_out2 (rcv_top_out2)
    );

    rcv_d rcv_d_0 (
        .rcv_d_in1 (rcv_top_in1), 
        .rcv_d_in2 (rcv_top_in2),
        .rcv_d_out1 (rcv_cd1), 
        .rcv_d_out2 (rcv_cd2), 
		.rcv_d_out3 (rcv_top_out3)
    );
endmodule

module chip_top (
    ctop_in1, 
    ctop_in2, 
    ctop_in3, 
    ctop_in4, 
    ctop_in5, 
    ctop_out1, 
    ctop_out2, 
    ctop_out3, 
    ctop_out4
);
    input [7:0] ctop_in1;
    input ctop_in2;
    input ctop_in3;
    input ctop_in4;
    input ctop_in5;
    output ctop_out1;
    output ctop_out2;
    output [7:0] ctop_out3;
    output ctop_out4;

    // wire declaration
    wire xmit_top_0_s1;
    wire rcv_top_0_s1;

    // module instantiation
    xmit_top xmit_top_0 (
        .xmit_top_in1 (ctop_in1),
        .xmit_top_in2 (ctop_in2),
        .xmit_top_in3 (ctop_in3),
        .xmit_top_in4 (rcv_top_0_s1),
        .xmit_top_out1 (ctop_out1),
        .xmit_top_out2 (ctop_out2),
        .xmit_top_out3 (xmit_top_0_s1)
    );

    rcv_top rcv_top_0 (
        .rcv_top_in1 (ctop_in4),
        .rcv_top_in2 (ctop_in5),
        .rcv_top_in3 (xmit_top_0_s1),
        .rcv_top_out1 (ctop_out3),
        .rcv_top_out2 (ctop_out4),
        .rcv_top_out3 (rcv_top_0_s1),
    );
endmodule
