`timescale 1ns/10ps
`include "device_regs_nofunction.v"

module testbench_top();

reg		[3:0]	address_tb;
reg		[7:0]	wrdata_tb;
reg				write_en_tb, read_en_tb;
reg				clk_tb, resetb;
wire	[7:0]	rddata_tb;

parameter		CLKTB_HALF_PERIOD = 5;
parameter		RST_DEASSERT_DLY = 100;

parameter		REG0_OFFSET = 4'b0000, 
				REG1_OFFSET = 4'b0001, 
				REG2_OFFSET = 4'b0010, 
				REG3_OFFSET = 4'b0011;

// generate clk_tb				
initial begin
	clk_tb = 1'b0;
	forever begin
		#CLKTB_HALF_PERIOD clk_tb = ~clk_tb; 	//100MHz
	end
end

// generate resetb
initial begin
	resetb					 = 1'b0;
	#RST_DEASSERT_DLY resetb = 1'b1;
end

// init variabled
initial begin
	address_tb 	= 'b0;
	wrdata_tb 	= 'b0;
	write_en_tb = 1'b0;
	read_en_tb 	= 1'b0;
end

// DUT init
device_regs_nofunction	device_regs_nofunction_0
	(
	.clk		(clk_tb), 
	.resetb		(resetb), 
	.address	(address_tb), 
	.write_en	(write_en_tb), 
	.read_en	(read_en_tb), 
	.data_in	(wrdata_tb), 
	.read_data	(rddata_tb)
	);
	
// write task
task reg_write;
	input	[3:0]	address_in;
	input	[7:0] 	data_in;
	
	begin
		@(posedge clk_tb);
			#1 address_tb = address_in;
		@(posedge clk_tb);
			#1 write_en_tb = 1'b1;
			wrdata_tb = data_in;
		@(posedge clk_tb);
			#1;
			write_en_tb		= 1'b0;
			address_tb		= 4'hF;
			wrdata_tb		= 4'h0;
	end
endtask

// read task
task reg_read;
	input	[3:0]	address_in;
	input	[7:0]	expected_data;
	begin
		@(posedge clk_tb);
			#1 address_tb = address_in;
		@(posedge clk_tb);
			#1 read_en_tb = 1'b1;
		@(posedge clk_tb);
			#1 read_en_tb	= 1'b0;
			address_tb		= 4'hF;
		@(posedge clk_tb);
			if (expected_data === rddata_tb)
				$display("data matches: expected_data = %h, actual_data = %h", expected_data, rddata_tb);
			else
				$display("ERROR: data mismatch:expected_data = %h, actual_data = %h", expected_data, rddata_tb);
	end
endtask

initial
	begin
		$dumpfile("testbench_top.vcd");		// create vcd to be viewed with GTKWave
		$dumpvars(0, testbench_top);
		
		#1000;
		reg_write	(REG0_OFFSET, 8'hA5);
		reg_read	(REG0_OFFSET, 8'hA5);
		reg_write	(REG1_OFFSET, 8'hA6);
		reg_read	(REG1_OFFSET, 8'hA6);
		reg_write	(REG2_OFFSET, 8'hA7);
		reg_read	(REG2_OFFSET, 8'hA7);
		reg_write	(REG3_OFFSET, 8'hA8);
		reg_read	(REG3_OFFSET, 8'hA8);
		
		$finish;
	end
endmodule