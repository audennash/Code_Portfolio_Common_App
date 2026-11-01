module top_module_fsm ();
	reg clk=0;
	always #5 clk = ~clk;  // Create clock with period=10
	initial `probe_start;   // Start the timing diagram

	//`probe(clk);        // Probe signal "clk"

	// A testbench

    reg [1:0] din=2'b00;
    reg [3:0] dout;
    wire [3:0] sc_in;
    wire [5:0] sc_out;
    
	initial begin
        #1; $display("din: %b", din, "; dout: %b", dout);
        #9; din <= 2'b11; #5; $display("din: %b", din, "; dout: %b", dout);
        #5; din <= 2'b01; #5; $display("din: %b", din, "; dout: %b", dout);
		#50 $finish;            // Quit the simulation
	end
	
    sample_combo sc (sc_in, sc_out);
    fsm #(.in_width(2), .out_width(4), .state_width(2)) sample_fsm (din, sc_out, clk, dout, sc_in);
endmodule

module sample_combo (
    input [3:0] in,
    output [5:0] out);
    
    assign out [3:0] = ~in;
    assign out [4] = |in;
    assign out [5] = ∈
    
endmodule
    


module fsm #(parameter in_width, parameter out_width, parameter state_width)(
    input [in_width-1:0] data_in,
    input [out_width+state_width-1:0] update_in,
    input clk,
    output reg [out_width-1:0] data_out,
    output reg [in_width+state_width-1:0] update_out);
    
 	reg [state_width-1:0] state;
    
    initial begin
        state=0;
        //$display("state: %b", state);
    end
    
    /*always @(*) begin
        $display("COMBO UPDATE || update_in: %b", update_in);
    end*/
    
    always @(posedge clk) begin
        state <= update_in[state_width-1:0];
        //$display("state: %b", state);
        //$display("UPDATE IN CLOCK || s: %b", state, ", ui: %b", update_in, ", uo: %b", update_out, ", do: %b", data_out);
    end 
    
    assign update_out = {data_in,state};
    assign data_out = update_in [out_width+state_width-1:state_width];

endmodule