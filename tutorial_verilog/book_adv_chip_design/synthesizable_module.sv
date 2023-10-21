// Top Module Comments 
/**
Copyright Notice
    Put copyright notice here 

Functionality 
    This module implements an arbiter that processes requests from 
    multiple agents and asserts grant to one of the requesting agents. It 
    works in a round-robin manner with equal fairness to all agents. After 
    getting grant, each requesting agent performs its job and asserts 
    end_transaction signal to indicate that arbiter can issue grant to the next 
    request in line. 

Author
    Mr. X
**/

// Module and Port Listing 
module arbiter (
    clk, rstb, 
    request0, request1, request2, request3, 
    end_transaction0, end_transaction1, end_transaction2, end_transaction3, 
    grand0, grant1, grant2, grant3
); 

// Inputs and Outputs Declarations 
input clk;
input rstb;
input request0;         // keep the request asserted until grant is given
input request1;
input request2;
input request3;
input end_transaction0; // indicate end of transaction
input end_transaction1;
input end_transaction2;
input end_transaction3;
output grand0;          // assert high to the requesting agent 
output grand1;
output grand2;
output grand3;

// Parameter and localparam declarations
/* Declare parameters or local parameters here. Parameters are used for 
passing values across module hierarchy. Local parameters are used locally and
not passed across modules. Ihe following localparams are used to represent
the states Of the arbiter state machine. */ 

localparam  IDLE = 3'd0, 
            GNT0 = 3'd1, 
            GNTI = 3'd2, 
            GNT2 = 3'd3, 
            GNT3 = 3'd4; 

// Registers and Wire Declarations 
/* Wires are used to declare combinational logic. However, regs are used 
declare combinational logic or storage elements (flip-flops). */
reg [2:0] arb_state, arb_state_nxt; 
reg [3:0] grant, grant_nxt; 
reg [3:0] serv_history, serv_history_nxt; 
wire  grant0, grant1, grant2, grant3; 

// Combinational Logic — assign statements 
assign {grant3, grant2, grant1, grant0} = grant; 

// Flops Inference 
always @(posedge clk or negedge rstb) begin 
    if (!rstb) begin
        arb_state <= IDLE;
        grant <= 'd0;
        serv_history <= 4'b1000;
    end else begin
        arb_state <= arb_state_nxt;
        grant <= grant_nxt;
        serv_history <= serv_history_nxt;
    end 
end

// Combinational Logic — Always block 
always @(*) begin
    arb_state_nxt = arb_state; 
    grant_nxt = grant; 
    serv_history_nxt = serv_history;
    case (arb_state)
        IDLE: begin 
            case(1'b1)
                serv_history[3]: begin 
                    if(reqeust0) begin 
                        arb_state_nxt = GNT0;
                        grant_nxt = 4'b0001;
                    end else if (request1) begin 
                        arb_state_nxt = GNT1;
                        grant_nxt = 4'b0010;
                    end else if (request2) begin 
                        arb_state_nxt = GNT2;
                        grant_nxt = 4'b0100;
                    end else if (request3) begin 
                        arb_state_nxt = GNT3;
                        grant_nxt = 4'b1000;
                    end 
                end
                serv_history[0]: begin 
                    if (request1) begin 
                        arb_state_nxt = GNT1;
                        grant_nxt = 4'b0010;
                    end else if (request2) begin 
                        arb_state_nxt = GNT2;
                        grant_nxt = 4'b0100;
                    end else if (request3) begin 
                        arb_state_nxt = GNT3;
                        grant_nxt = 4'b1000;
                    end else if (request0) begin
                        arb_state_nxt = GNT0;
                        grant_nxt = 4'b0001;                    
                    end
                end
                serv_history[1]: begin 
                    if (request2) begin 
                        arb_state_nxt = GNT2;
                        grant_nxt = 4'b0100;
                    end else if (request3) begin 
                        arb_state_nxt = GNT3;
                        grant_nxt = 4'b1000;
                    end else if (request0) begin
                        arb_state_nxt = GNT0;
                        grant_nxt = 4'b0001;                    
                    end else if (request1) begin 
                        arb_state_nxt = GNT1;
                        grant_nxt = 4'b0010;
                    end
                end
                serv_history[2]: begin 
                    if (request3) begin 
                        arb_state_nxt = GNT3;
                        grant_nxt = 4'b1000;
                    end else if (request0) begin
                        arb_state_nxt = GNT0;
                        grant_nxt = 4'b0001;                    
                    end else if (request1) begin 
                        arb_state_nxt = GNT1;
                        grant_nxt = 4'b0010;
                    end else if (request2) begin 
                        arb_state_nxt = GNT2;
                        grant_nxt = 4'b0100;
                    end
                end
                default: begin end
            endcase 
        end
        GNT0: begin
            if (end_transaction0) begin
                arb_state_nxt = IDLE;
                grant_nxt = 'd0;
                serv_history_nxt = 4'b0001;
            end
        end
        GNT1: begin
            if (end_transaction1) begin
                arb_state_nxt = IDLE;
                grant_nxt = 'd0;
                serv_history_nxt = 4'b0010;
            end
        end
        GNT2: begin
            if (end_transaction2) begin
                arb_state_nxt = IDLE;
                grant_nxt = 'd0;
                serv_history_nxt = 4'b0100;
            end
        end
        GNT3: begin
            if (end_transaction3) begin
                arb_state_nxt = IDLE;
                grant_nxt = 'd0;
                serv_history_nxt = 4'b1000;
            end
        end
        default: begin end
    endcase
end
endmodule