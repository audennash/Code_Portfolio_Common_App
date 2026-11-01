module top_module_arbiter ();
    reg clk=0;
	always #5 clk = ~clk;

    reg [31:0] sources;
    wire [31:0] chosen;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module);

        sources <= 0;
        #1; $display($time, " sources: %b", sources, "; chosen: %b", chosen, " ||| pass: %b", test_ab1.pass, "; current: %b", test_ab1.current);
        #9;

        sources <= 5'b10110;
        #1; $display($time, " sources: %b", sources, "; chosen: %b", chosen, " ||| pass: %b", test_ab1.pass, "; current: %b", test_ab1.current);
        #9;

        #1; $display($time, " sources: %b", sources, "; chosen: %b", chosen, " ||| pass: %b", test_ab1.pass, "; current: %b", test_ab1.current);
        #9;

        #1; $display($time, " sources: %b", sources, "; chosen: %b", chosen, " ||| pass: %b", test_ab1.pass, "; current: %b", test_ab1.current);
        #9;

        #1; $display($time, " sources: %b", sources, "; chosen: %b", chosen, " ||| pass: %b", test_ab1.pass, "; current: %b", test_ab1.current);
        #9;

        #1; $display($time, " sources: %b", sources, "; chosen: %b", chosen, " ||| pass: %b", test_ab1.pass, "; current: %b", test_ab1.current);
        #9;

        sources <= 7'b1100000;
        #1; $display($time, " sources: %b", sources, "; chosen: %b", chosen, " ||| pass: %b", test_ab1.pass, "; current: %b", test_ab1.current);
        #9;

        $finish;
    end

    arbiter_core #(32) test_ab1 (sources, clk, chosen);

endmodule


module arbiter_core #(parameter sources)(
    input [sources-1:0] requested,
    input clk,
    output [sources-1:0] chosen);

    reg [sources-1:0] current;
    wire [sources-1:0] pass;

    genvar i;
    generate
        for (i=0; i<sources; i=i+1) begin : circle_of_sources
            wire pp = pass[(i+sources-1)%sources];
            assign pass[i] = (pp && ~requested[i]) || current[i];
            assign chosen[i] = pp && requested[i];
            always @(posedge clk) begin
                current[i] <= chosen[i] || (current[i] && pp);
            end
            initial begin
                if (i==0) begin
                    current[i] <= 1;
                end else begin
                    current[i] <= 0;
                end
            end
        end
    endgenerate
endmodule