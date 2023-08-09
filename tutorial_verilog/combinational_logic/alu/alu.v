module alu(
    input [7:0] A, B, 
    input [3:0] select, 
    input clk, 
    output [7:0] ALU_out, 
    output Carry_out
);
reg [7:0] ALU_result;
wire [8:0] tmp;

assign ALU_out = ALU_result;
assign tmp = {1'b0, A} + {1'b0, B};
assign Carry_out = tmp[8];

always @(posedge clk)
begin
    case (select)
        4'b0000:
            ALU_result = A + B;         // add
        4'b0001:
            ALU_result = A - B;         // subtract
        4'b0010:
            ALU_result = A * B;         // multiply
        4'b0011:
            ALU_result = A / B;         // division
        4'b0100:
            ALU_result = A << 1;        // left shift
        4'b0101:
            ALU_result = A >> 1;        // right shift
        4'b0110:
            ALU_result = {A[6:0], A[7]};    // rotate left
        4'b0111:
            ALU_result = {A[0], A[7:1]};    // rotate right
        4'b1000:
            ALU_result = A & B;         // AND
        4'b1001:
            ALU_result = A | B;         // OR
        4'b1010:
            ALU_result = A ^ B;         // XOR
        4'b1011:
            ALU_result = ~(A & B);      // NAND
        4'b1100:
            ALU_result = ~(A | B);      // NOR
        4'b1101:
            ALU_result = ~(A ^ B);      // XNOR
        4'b1110:
            ALU_result = (A > B)?8'd1:8'd0;     // greater than 
        4'b1111:
            ALU_result = (A == B)?8'd1:8'd0;    // equal
        default:
            ALU_result = A + B;         // default
    endcase
end
endmodule