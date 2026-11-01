module top_module_mux_and_dmux ();
	reg clk=0;
	always #5 clk = ~clk;  // Create clock with period=10
	initial `probe_start;   // Start the timing diagram

	//`probe(clk);        // Probe signal "clk"

	// A testbench
    reg [3:0] a=4'b1011;
    reg [3:0] b=4'b1100;
    reg [3:0] aout, bout;
    reg sel=0;
    wire [3:0] out;
	initial begin
        #10; $display("sel: ", sel, "; out: %b", out, "; aout: %b", aout, "; bout: %b", bout); sel <= 1;
        #10; $display("sel: ", sel, "; out: %b", out, "; aout: %b", aout, "; bout: %b", bout);
		$display ("Hello world! The current time is (%0d ps)", $time);
		#50 $finish;            // Quit the simulation
	end

    mux #(4) testmux (a,b,sel,out);   // Sub-modules work too.
    dmux #4 testdmux (out,sel,aout,bout);

endmodule

module dmux #(parameter n=1)(
    input [n-1:0] in,
    input sel,
    output [n-1:0] aout,
    output [n-1:0] bout);
    
    wire acomp={n{!sel}};
    wire bcomp={n{sel}};
    
    and a_and [n-1:0] (aout,acomp,in);
    and b_and [n-1:0] (bout, bcomp, in);
    
endmodule

module mux #(parameter n=1) (
    input [n-1:0] a,
    input [n-1:0] b,
    input sel,
    output [n-1:0] out);
    
    wire acomp={n{!sel}};
    wire bcomp={n{sel}};
    wire [n-1:0] acor, bcor;
    
    and a_and [n-1:0] (acor,acomp,a);
    and b_and [n-1:0] (bcor, bcomp,b);
    or outor [n-1:-0] (out,acor,bcor);
    
endmodule

