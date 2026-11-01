module top_module_barrel_shifter();
    reg clk=0;
	always #5 clk = ~clk;

    reg [7:0] in;
    reg [2:0] shift;
    reg right;
    reg arithmetic;
    wire [7:0] out;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module);

        in <= 0; shift <= 0; right <= 0; arithmetic <= 0; #10;
        $display("in: %b", in, "; shift: ", shift, "; right: ", right, "; arithmetic: ", arithmetic, "||| out: %b", out);

        in <= 8'b10110111; shift <= 0; right <= 0; arithmetic <= 0; #10;
        $display("in: %b", in, "; shift: ", shift, "; right: ", right, "; arithmetic: ", arithmetic, "||| out: %b", out);

        shift <= 3; right <= 0; arithmetic <= 0; #10;
        $display("in: %b", in, "; shift: ", shift, "; right: ", right, "; arithmetic: ", arithmetic, "||| out: %b", out);

        shift <= 4; #10;
        $display("in: %b", in, "; shift: ", shift, "; right: ", right, "; arithmetic: ", arithmetic, "||| out: %b", out);

        shift <= 3; arithmetic <= 1; #10;
        $display("in: %b", in, "; shift: ", shift, "; right: ", right, "; arithmetic: ", arithmetic, "||| out: %b", out);

        right <= 1; arithmetic <= 0; #10;
        $display("in: %b", in, "; shift: ", shift, "; right: ", right, "; arithmetic: ", arithmetic, "||| out: %b", out);

        arithmetic <= 1; #10;
        $display("in: %b", in, "; shift: ", shift, "; right: ", right, "; arithmetic: ", arithmetic, "||| out: %b", out);

		$finish;            
    end

    barrel_shifter #(8) test_bs (in, shift, right, arithmetic, out);

endmodule

module barrel_shifter #(parameter width=1) (
    input [width-1:0] in,
    input [$clog2(width)-1:0] shift,
    input right,
    input arithmetic,
    output [width-1:0] out
);

    localparam sw = $clog2(width);
    genvar i;

    generate
        for (i=0; i<sw; i=i+1) begin : mux_hierarchy
            wire [width-1:0] layer_in;
            wire [width-1:0] layer_out;

            if (i==0) begin
                assign layer_in = in;
            end else begin
                assign layer_in = mux_hierarchy[i-1].layer_out;
            end

            wire [width-1-2**i:0] l_upper_part = layer_in[width-1-2**i:0];
            wire [width-1:width-2**i] l_lower_part = (arithmetic)? {(2**i){1'b0}} : layer_in[width-1:width-2**i] ;           
            wire [width-1:0] l_layer_out = shift[i]? {l_upper_part, l_lower_part}: layer_in;

            wire [2**i-1:0] r_upper_part = {(2**i){arithmetic}};
            wire [width-1:2**i] r_lower_part = layer_in[width-1:2**i];
            wire [width-1:0] r_layer_out = shift[i]? {r_upper_part, r_lower_part} : layer_in;

            assign layer_out = right? r_layer_out : l_layer_out;
        end
    endgenerate

    assign out = mux_hierarchy[sw-1].layer_out;

endmodule