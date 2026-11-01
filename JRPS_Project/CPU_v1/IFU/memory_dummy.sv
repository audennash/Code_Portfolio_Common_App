module top_module_memory_dummy(); //THIS MAY BE INCOMPATABLE WITH OTHER MODULES, PROCEED WITH CAUTION
    reg clk = 0;
    always #5 clk = ~clk;

    reg [31:0] i_addr;
    reg [31:0] d_addr;
    reg [31:0] data_in;
    reg d_write;
    reg choose_i;
    reg stall;
    reg run=0;
    reg flush;
    wire [31:0] data_out;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module);

        i_addr <= 0; d_addr <= 0; data_in <= 0; d_write <= 0; choose_i <= 0; stall <= 0; flush <= 0;
        #10; $display("i_addr: ", i_addr, "; d_addr: ", d_addr, "; data_in: ", data_in, "; d_write: ", d_write, "; choose_i: ", choose_i, 
        "; stall: ", stall, "; flush: ", flush, "; data_out: ", data_out);

        d_write <= 1;
        #10; $display("i_addr: ", i_addr, "; d_addr: ", d_addr, "; data_in: ", data_in, "; d_write: ", d_write, "; choose_i: ", choose_i, 
        "; stall: ", stall, "; flush: ", flush, "; data_out: ", data_out);
        
        data_in <= 1; d_addr <= 1;
        #10; $display("i_addr: ", i_addr, "; d_addr: ", d_addr, "; data_in: ", data_in, "; d_write: ", d_write, "; choose_i: ", choose_i, 
        "; stall: ", stall, "; flush: ", flush, "; data_out: ", data_out);

        d_write <= 0; data_in <= 1; d_addr <= 0;
        #10; $display("i_addr: ", i_addr, "; d_addr: ", d_addr, "; data_in: ", data_in, "; d_write: ", d_write, "; choose_i: ", choose_i, 
        "; stall: ", stall, "; flush: ", flush, "; data_out: ", data_out);

        d_write <= 0; data_in <= 1; i_addr <= 1; d_addr <= 0;
        #10; $display("i_addr: ", i_addr, "; d_addr: ", d_addr, "; data_in: ", data_in, "; d_write: ", d_write, "; choose_i: ", choose_i, 
        "; stall: ", stall, "; flush: ", flush, "; data_out: ", data_out);

        choose_i <= 1;
        #10; $display("i_addr: ", i_addr, "; d_addr: ", d_addr, "; data_in: ", data_in, "; d_write: ", d_write, "; choose_i: ", choose_i, 
        "; stall: ", stall, "; flush: ", flush, "; data_out: ", data_out);

        choose_i <= 0; d_write <= 1; data_in <= 2; stall <= 1;
        #10; $display("i_addr: ", i_addr, "; d_addr: ", d_addr, "; data_in: ", data_in, "; d_write: ", d_write, "; choose_i: ", choose_i, 
        "; stall: ", stall, "; flush: ", flush, "; data_out: ", data_out);

        choose_i <= 0; d_write <= 1; data_in <= 2; stall <= 0;
        #10; $display("i_addr: ", i_addr, "; d_addr: ", d_addr, "; data_in: ", data_in, "; d_write: ", d_write, "; choose_i: ", choose_i, 
        "; stall: ", stall, "; flush: ", flush, "; data_out: ", data_out);

        flush <= 1; d_write <= 0;
        #10; $display("i_addr: ", i_addr, "; d_addr: ", d_addr, "; data_in: ", data_in, "; d_write: ", d_write, "; choose_i: ", choose_i, 
        "; stall: ", stall, "; flush: ", flush, "; data_out: ", data_out);

        d_addr <= 1;
        #10; $display("i_addr: ", i_addr, "; d_addr: ", d_addr, "; data_in: ", data_in, "; d_write: ", d_write, "; choose_i: ", choose_i, 
        "; stall: ", stall, "; flush: ", flush, "; data_out: ", data_out);

        d_write <= 1; data_in <= 3;
        #10; $display("i_addr: ", i_addr, "; d_addr: ", d_addr, "; data_in: ", data_in, "; d_write: ", d_write, "; choose_i: ", choose_i, 
        "; stall: ", stall, "; flush: ", flush, "; data_out: ", data_out);

        $finish;
    end

    dummem #(32, 32) dummem_test(i_addr, d_addr, data_in, d_write, choose_i, stall, run, clk, flush, data_out);

endmodule

module dummem #(parameter width = 32, parameter depth = 32) (
    input [$clog2(depth)-1:0] i_addr,
    input [$clog2(depth)-1:0] d_addr,
    input [width-1:0] data_in,
    input d_write,
    input choose_i,
    input stall,
    input run,   
    input clk,
    input flush,
    output [width-1:0] data_out);

    wire [$clog2(depth)-1:0] mem_addr = choose_i? i_addr : d_addr;
    wire mem_write = (stall && run)? 0 : d_write;
    reg [width-1:0] memory [depth-1:0];

    always_ff @(posedge clk) begin
        if (mem_write) begin
            memory[mem_addr] <= data_in;
        end 
    end

    always_ff @(posedge flush) begin
        for (int i=0; i<depth; i=i+1) begin
            memory[i] <= 0;
        end
    end

    assign data_out = memory[mem_addr];

endmodule