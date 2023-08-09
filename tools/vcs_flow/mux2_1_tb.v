/*
demonstrate argument file filelist usage. see filelist for explanations

output
# KERNEL: time=    0 ns, in0=0000, in1=0000, sel=0, out=0000
# KERNEL: time=   20 ns, in0=0110, in1=1001, sel=0, out=0110
# KERNEL: time=   40 ns, in0=0110, in1=1001, sel=1, out=1001
*/

`timescale 1ns/10ps

// Here is the testbench proper:
module mux2_1_testbench ( ) ;
    // Test bench gets wires for all dut outputs:
    wire [3:0]		out;			// From dut of mux2_1.v

    // Regs for all dut inputs:
    reg [3:0]		in0;			// To dut of mux2_1.v
    reg [3:0]		in1;			// To dut of mux2_1.v
    reg			sel;			// To dut of mux2_1.v

    mux2_1 dut (// (dut means device under test)
            // Outputs
            .out			(out[3:0]),
            // Inputs
            .in0			(in0[3:0]),
            .in1			(in1[3:0]),
            .sel			(sel));

    initial
        begin
        // First setup up to monitor all inputs and outputs
        $monitor ("time=%5d ns, in0=%b, in1=%b, sel=%b, out=%b", $time, in0, in1, sel, out);

        // First initialize all registers
        in0 = 4'b0;
        in1 = 4'b0;
        sel = 1'b0;
	
        #10;  // space things out on 10ns boundaries to see
	            // results easier in VirSim
	
        // At this point we should have a 4'b0 coming out out because
        // it is selecting in0 and in0 is 0b0	
        if (out != 4'b0) begin
        $display("ERROR 1: Out is not equal to 0'b0");
        $finish;
        end

        #10;
        in0 = 4'b0110;
        in1 = 4'b1001;
        sel = 1'b0;
        #10;

        // We should now have 0110 on the output
        if (out != 4'b0110) begin
        $display("ERROR 2: Output is not equal to 4'b0110");
        $finish;
        end

        #10;
	    sel = 1'b1;
	
        #10;
		
        // Now we are selecting in1 so we should see its value on the
        // output
        if (out != 4'b1001) begin
        $display("ERROR 3: Output is not equal to 4'b1001");
        $finish;
        end
	
        #10;
	
	    sel = 1'b0; // This is only there to force a space in the
	                // output so the wave trace is more easily read.

        // We got this far so all tests passed.
        $display("All tests completed successfully\n\n");
        $finish;
    end


   // This is to create a dump file for offline viewing.
   initial
     begin
        $dumpfile ("mux2_1.dump");
        $dumpvars (0, mux2_1_testbench);
     end // initial begin
endmodule // mux2_1_testbench