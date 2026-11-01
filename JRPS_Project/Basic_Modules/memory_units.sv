module top_module_memory_units ();
	reg clk=0;
	always #5 clk = ~clk;  // Create clock with period=10
	initial `probe_start;   // Start the timing diagram

	//`probe(clk);        // Probe signal "clk"

	// A testbench
    reg [3:0] in = 4'b0001;
    reg [3:0] addr = 4'b0000;
    reg load = 0;
    reg flush = 0;
    reg [3:0] out;
	initial begin
        
        #10; $display("in: %b", in, "; addr: %b", addr, "; load: ", load, "; flush: %b", flush, "; out: %b", out, "; time: ", $time);
        in <= 4'b1110; addr <= 4'b0011; load <= 0; flush <= 0;
        
        #10; $display("in: %b", in, "; addr: %b", addr, "; load: ", load, "; flush: %b", flush, "; out: %b", out, "; time: ", $time);
        in <= 4'b1011; addr <= 4'b1001; load <= 1; flush <= 0;
        
        #10; $display("in: %b", in, "; addr: %b", addr, "; load: ", load, "; flush: %b", flush, "; out: %b", out, "; time: ", $time);
        in <= 4'b1111; addr <= 4'b0011; load <= 1; flush <= 0;
        
        #10; $display("in: %b", in, "; addr: %b", addr, "; load: ", load, "; flush: %b", flush, "; out: %b", out, "; time: ", $time);
        in <= 4'b1001; addr <= 4'b1100; load <= 0; flush <= 1;
        
        #10; $display("in: %b", in, "; addr: %b", addr, "; load: ", load, "; flush: %b", flush, "; out: %b", out, "; time: ", $time);
        in <= 4'b0011; addr <= 4'b0011; load <= 0; flush <= 0;
        
        #10; $display("in: %b", in, "; addr: %b", addr, "; load: ", load, "; flush: %b", flush, "; out: %b", out, "; time: ", $time);
        in <= 4'b0011; addr <= 4'b1011; load <= 0; flush <= 0;
        
        #10; $display("in: %b", in, "; addr: %b", addr, "; load: ", load, "; flush: %b", flush, "; out: %b", out, "; time: ", $time);
        in <= 4'b0011; addr <= 4'b1111; load <= 1; flush <= 0;
        
        #10; $display("in: %b", in, "; addr: %b", addr, "; load: ", load, "; flush: %b", flush, "; out: %b", out, "; time: ", $time);
        
		#50 $finish;            // Quit the simulation
	end
	
    regfile #(12, 4) testreg (in,addr,load,flush, clk,out);

endmodule

module regfile #(parameter depth=1, parameter width=1)(
    input [width-1:0] in,
    input [( (depth>1)? $clog2(depth)-1 : 0):0] addr,
    input load,
    input flush,
    input clk,
    output [width-1:0] out);
    
    localparam tind = $clog2(depth)-1;
    localparam tpind = (depth>2)? tind : 1;
    localparam sd = 2**tind;
    
    if (depth != 1) begin
        wire [width-1:0] big_out;
        wire [width-1:0] little_out;
        wire [width-1:0] little_outp;
        wire topind = addr[tind];
        assign out = topind? little_out : big_out;
        regfile #(sd, width) big_subfile (in, addr[tpind-1:0], (~topind) & load, flush, clk, big_out);
        regfile #(depth-sd, width) little_subfile (in, addr[tpind-1:0], topind & load, flush, clk, little_outp);
        
        if (sd/(depth-sd)>1) begin
            assign little_out = ( addr[ tind-1 : (tind-(sd/(depth-sd)-1)) ] == {(sd/(depth-sd)-1){1'b0}} )? little_outp : {(width){1'bz}};
        end else begin
            assign little_out = little_outp;
        end
        
    end else begin
        register #(width) single_reg (in, load, flush, clk, out);
    end
    
endmodule

module register #(parameter n=1) (
    input [n-1:0] in,
    input load,
    input flush,
    input clk,
    output [n-1:0] out);
	
    wire [n-1:0] newvalue;
    wire [n-1:0] outtemp;
    assign newvalue = load ? in : out;
    assign out = flush? 0 : outtemp;
    dff dff_field [n-1:0] (newvalue, clk, outtemp);
    
endmodule
    
module dff (
    input in,
    input clk,
    output reg out);
    
    initial begin
        out=0;
    end
    
    always @(posedge clk) begin
    	out <= in;
    end
endmodule