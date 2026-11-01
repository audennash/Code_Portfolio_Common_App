module top_module_counter ();
	reg clk=0;
	always #5 clk = ~clk;  // Create clock with period=10
	initial `probe_start;   // Start the timing diagram

	//`probe(clk);        // Probe signal "clk"

	// A testbench

  	reg run=0;
    reg reset=0;
    reg [2:0] count;
    reg done;
    
	initial begin
        run <= 1; #10; $display("count: %b", count, ", done: ", done);
        #10; $display("count: %b", count, ", done: ", done);
        #10; $display("count: %b", count, ", done: ", done);
        #10; $display("count: %b", count, ", done: ", done);
        run <=0 ; #10; $display("ru0 | count: %b", count, ", done: ", done);
        reset <= 1; #10; $display("re1 | count: %b", count, ", done: ", done);
        run <= 1; reset <= 0; #10 $display("ru1 re0 | count: %b", count, ", done: ", done);
        #10; $display("count: %b", count, ", done: ", done);
        #10; $display("count: %b", count, ", done: ", done);
        #10; $display("count: %b", count, ", done: ", done);
        #10; $display("count: %b", count, ", done: ", done);
        #10; $display("count: %b", count, ", done: ", done);
        #10; $display("count: %b", count, ", done: ", done);
        #10; $display("count: %b", count, ", done: ", done);
        #50; $finish;
	end
	
    incrementer #(8) inctest (run, reset, clk, count, done);
    
endmodule

module incrementer #(parameter max) (
    input run,
    input reset,
    input clk, 
    output [$clog2(max)-1:0] count,
    output reg done);
    
    reg [$clog2(max)-1:0] next_count;
	assign count = reset ? 0: next_count;
    
    initial begin
        next_count = 0;
        done = 0;
    end
    
    always @(posedge clk) begin
        next_count <= count;
        if (next_count==max-1) begin
            done <= 1;
        end else begin
            if (run) begin
                next_count <= next_count+1;
            end
        end
        //$display ("nc: %b", next_count);
    end

endmodule
