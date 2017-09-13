module device_regs_nofunction(address, write_en, data_in, read_en, read_data, clk, resetb);

input	[3:0]	address;
input			write_en;
input			read_en;
input	[7:0]	data_in;
output 	[7:0]	read_data;
input			clk;
input			resetb;

wire			reg0_match, reg1_match, reg2_match, reg3_match;
reg		[7:0]	reg0, reg1, reg2, reg3;
wire	[7:0]	reg0_nxt, reg1_nxt, reg2_nxt, reg3_nxt;
reg		[7:0]	read_data, read_data_nxt;

assign reg0_match = (address == 4'b0000);	// reg0 address is 0000b, if input address is the same, then match
assign reg1_match = (address == 4'b0001);
assign reg2_match = (address == 4'b0010);
assign reg3_match = (address == 4'b0011);
assign reg0_nxt = (reg0_match && write_en) ? data_in : reg0;	// if match and write_en is 1, then reg value is data_in. Otherwise reg value is original value
assign reg1_nxt = (reg1_match && write_en) ? data_in : reg1;
assign reg2_nxt = (reg2_match && write_en) ? data_in : reg2;
assign reg3_nxt = (reg3_match && write_en) ? data_in : reg3;

always @(posedge clk or negedge resetb)
	begin
		if (!resetb)	// negedge of resetb resets registers
			begin
				reg0 <= 'd0;
				reg1 <= 'd0;
				reg2 <= 'd0;
				reg3 <= 'd0;
				read_data <= 'd0;
			end
		else
			begin
				// write case
				reg0 <= reg0_nxt;		// or reg0 <= (reg0_match && write_en) ? data_in : reg0;
				reg1 <= reg1_nxt;
				reg2 <= reg2_nxt;
				reg3 <= reg3_nxt;
				// read case
				read_data <= read_data_nxt;
			end
	end
	
always @(*)
	begin
		read_data_nxt = read_data;
		
		if (read_en) 
			begin
				case(1'b1)
					reg0_match: read_data_nxt = reg0;
					reg1_match: read_data_nxt = reg1;
					reg2_match: read_data_nxt = reg2;
					reg3_match: read_data_nxt = reg3;
				endcase
			end
	end
endmodule