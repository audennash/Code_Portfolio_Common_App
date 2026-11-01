module top_module_basic_gates ();
	reg clk=0;
	always #5 clk = ~clk;  // Create clock with period=10
	initial `probe_start;   // Start the timing diagram

	//`probe(clk);        // Probe signal "clk"

	// A testbench
    reg [3:0] a=4'b0000;
    reg b=0;
    wire out;
    wire outnor;
    wire outxnor;
    //`probe(a);
    //`probe(b);
	initial begin
        #10; a <= 4'b1001; $display("in: %b", a, "; out: %b", out);
		#10; a <= 4'b1010; $display("in: %b", a, "; out: %b", out);
        #10; a <= 4'b1011; $display("in: %b", a, "; out: %b", out);
        #10; a <= 4'b1100; $display("in: %b", a, "; out: %b", out);
        #10; a <= 4'b1101; $display("in: %b", a, "; out: %b", out);
        #10; a <= 4'b1110; $display("in: %b", a, "; out: %b", out);
        #10; a <= 4'b1111; $display("in: %b", a, "; out: %b", out);
        #10; $display("in: %b", a, "; out: %b", out);
		$display ("Hello world! The current time is (%0d ps)", $time);
		#50 $finish;            // Quit the simulation
	end
    audenand #(4) testorway (a, out);

endmodule


module audenxnor (
    input a,
    input b,
    output out);
    
    wire xorout;
    audenxor innerxor (a,b, xorout);
    audennot outnot (xorout, out);

endmodule


module audennor (
    input a,
    input b,
    output out);
    
    wire [1:0] in;
    assign in={a,b};
    wire orout;
    audenor inneror (in,orout);
    audennot outnot (orout, out);

endmodule


module audenxor (
    input a,
    input b,
    output out);
    
    wire orout;
    wire nandout;
    wire [1:0] in;
    assign in={a,b};
    audenor inneror (in,orout);
    nand innernand (nandout,a,b);
    wire [1:0] andin={orout,nandout};
    audenand outand (andin, out);

endmodule

    
module audenor #(parameter ways=2) (
    input [ways-1:0] in,
    output out);
    
    wire notaout;
    wire notbout;
    wire subout;
    
    if (ways!=2) begin
        audenor #(ways-1) subor(in[ways-2:0], subout);
        wire [1:0] smallin;
        assign smallin = {in[ways-1], subout};
        audenor outor(smallin, out);
    end else begin
        audennot nota(in[1], notaout);
        audennot notb(in[0], notbout);
   		nand nandgate(out, notaout, notbout);
    end
    
endmodule

    
module audenand #(parameter ways=2) (
    input [ways-1:0] in,
	output out);
    
    wire nandout;
    wire subout;
    
    if (ways!=2) begin
        audenand #(ways-1) suband (in[ways-2:0], subout);
        wire [1:0] smallin = {in[ways-1],subout};
        audenand outand(smallin, out);
    end else begin
    	nand nandgate(nandout, in[1], in[0]);
        audennot notgate(nandout, out);
    end
endmodule

    
module audennot(
    input in,
    output out);
    
    nand nandgate(out, in, in);
    
endmodule