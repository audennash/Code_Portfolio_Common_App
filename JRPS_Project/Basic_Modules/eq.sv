module top_module_eq ();
	reg clk=0;
	always #5 clk = ~clk;  // Create clock with period=10
	initial `probe_start;   // Start the timing diagram

	//`probe(clk);        // Probe signal "clk"

	// A testbench
    reg [3:0] a=4'b0101;
    reg [3:0] b=4'b0101;
    wire comp;
	initial begin
        #10; $display("a: %b", a, ", b: %b", b, "; comp: ", comp);
        a <= 4'b1001; b <= 4'b0010; #10; $display("a: %b", a, ", b: %b", b, "; comp: ", comp);
        a <= 4'b0000; b <= 4'b0000; #10; $display("a: %b", a, ", b: %b", b, "; comp: ", comp);
		#50 $finish;            // Quit the simulation
	end
	
    eq #(4) comparator (a,b,comp);

endmodule

module eq #(parameter n=1) (
    input [n-1:0] a,
    input [n-1:0] b,
    output equal);
    
    wire [n-1:0] bb_comp;
    xnor bit_xnor [n-1:0] (bb_comp, a, b);
    assign equal = &bb_comp;
    
endmodule
