module top_module_geq ();
	reg clk=0;
	always #5 clk = ~clk;  // Create clock with period=10
	initial `probe_start;   // Start the timing diagram

	//`probe(clk);        // Probe signal "clk"

	// A testbench
    reg [3:0] a = 4'b0000;
    reg [3:0] b = 4'b0000;
    reg tc = 0;
    
    wire usout;
    wire tcout;
    wire out = tc? tcout: usout;
    
	initial begin
        #10; $display ("a: %b", a, ", b: %b", b, ", tc: %b", tc, "; out: %b", out);
        a<= 4'b1010; b <= 4'b1001; #10; $display ("a: %b", a, ", b: %b", b, ", tc: %b", tc, "; out: %b", out);
        a<= 4'b0110; #10; $display ("a: %b", a, ", b: %b", b, ", tc: %b", tc, "; out: %b", out);
        a<= 4'b1010; b <= 4'b1011; #10; $display ("a: %b", a, ", b: %b", b, ", tc: %b", tc, "; out: %b", out);
        tc<=1; a<=4'b0000; b<= 4'b0000; #10; $display ("a: %b", a, ", b: %b", b, ", tc: %b", tc, "; out: %b", out);
        a<= 4'b1010; b <= 4'b1001; #10; $display ("a: %b", a, ", b: %b", b, ", tc: %b", tc, "; out: %b", out);
        a<= 4'b0110; #10; $display ("a: %b", a, ", b: %b", b, ", tc: %b", tc, "; out: %b", out);
        a<= 4'b1010; b <= 4'b1011; #10; $display ("a: %b", a, ", b: %b", b, ", tc: %b", tc, "; out: %b", out);
		//$display ("Hello world! The current time is (%0d ps)", $time);
		#50 $finish;            // Quit the simulation
	end

    geq #(.n(4), .tc(0)) geq_us_test (a,b,usout);
    geq #(.n(4), .tc(1)) geq_tc_test (a,b,tcout);

endmodule

module geq #(parameter n=1, parameter tc=0) (
    input [n-1:0] a,
    input [n-1:0] b,
    output out);
    
    wire [n-1:0] a_prime = {tc? ~a[n-1]: a[n-1], a[n-2:0]};
    wire [n-1:0] b_prime = {tc? ~b[n-1]: b[n-1], b[n-2:0]};
    
    wire [n:0] same_above;
    assign same_above[n] = 1;
    wire [n-1:0] zeroit;
    assign out=~(|zeroit);
    
    genvar i;
    generate
        for (i=n-1; i>=0; i--) begin: bitwise_checker
            assign same_above[i] = (~(a_prime[i]^b_prime[i]))&same_above[i+1];
            assign zeroit[i] = b_prime[i]&(~a_prime[i])&same_above[i+1];
        end
    endgenerate
        
endmodule