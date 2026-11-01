module top_module_ifu_tb();
    reg clk = 0;
    always #5 clk = ~clk;


    reg branch_inst = 0;
    reg [15:0] branch_addr = 0;
    reg branch_taken = 0;

    reg d_req = 0;
    reg [31:0] d_data = 0;
    reg [15:0] d_addr = 0;
    reg d_write = 0;

    reg run = 0;

    wire [15:0] i_addr;
    wire choose_i;
    wire [31:0] mem_out;

    wire [31:0] inst;
    wire stall;

    reg flush = 0;
    reg next_run = 0;
    

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module);

        #10; next_run <= 0; d_req <= 1; d_write <= 1; //insert instructions
        #10; d_data <= 0; d_addr <= 0;
        #10; d_data <= 4'b0001; d_addr <= 4'b0001;
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);
        #10; d_data <= 4'b0010; d_addr <= 4'b0010;
        #10; d_data <= 4'b0011; d_addr <= 4'b0011;
        #10; d_data <= 4'b0100; d_addr <= 4'b0100;
        #10; d_data <= 4'b0101; d_addr <= 4'b0101;
        #10; d_data <= 4'b0110; d_addr <= 4'b0110;
        #10; d_data <= 4'b0111; d_addr <= 4'b0111;
        #10; d_data <= 4'b1000; d_addr <= 4'b1000;
        #10; d_data <= 4'b1001; d_addr <= 4'b1001;
    
        #10; d_data <= 0; d_addr <= 0; d_req <= 0; d_write <= 0; next_run <= 1;
        $display("incrementation test");
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out); //test incrementation
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);
        d_req <= 1;
        $display("stall due to dreq test");
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out); //test stalling
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);
        d_req <= 0;
        $display("post-stall incrementation test");
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out); //test post-stall incrementation
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);
        next_run <= 0;
        $display("run off test");
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out); //test when run is off
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);
        next_run <= 1; branch_inst <= 1; branch_addr <= 2;
        $display("branching -- branch not taken -- test"); 
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out); //test branching (not taken)
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);
        branch_taken <= 1;
        $display("branching -- branch taken -- test"); 
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out); //test branching (taken)
        branch_inst <= 0; branch_taken <= 0; d_req <= 0;
        $display("loop again -- d_req 0 -- test"); 
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);
        d_req <= 1;
        $display("loop again -- d_req 1 -- test"); 
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);
        branch_inst <= 1; branch_taken <= 1;
        $display("go back");
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);
        branch_inst <= 0; branch_taken <= 0;
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);
        $display("data overwrite test");
        d_req <= 1; d_data <= 15; d_addr <= 5; d_write <= 1;
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);
        d_req <= 0; d_write <= 0;
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);
        next_run <= 0;
        $display("turned off test");
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; stall: ", stall, "; mem_out: ", mem_out);

        $finish;
    end

    ifu #(32, 2**16, 64) test_ifu (branch_inst, branch_addr, branch_taken, d_req, d_data, d_addr, d_write, mem_out, run, flush, clk, 
    i_addr, choose_i, inst, stall);
    dummem #(32, 32) mem_for_test (i_addr, d_addr, d_data, d_write, choose_i, stall, run, clk, flush, mem_out);
    
    always @(posedge clk) begin
        run <= next_run;
    end
    always @(posedge flush) begin
        branch_inst <= 0;
        branch_addr <= 0;
        branch_taken <= 0;
        d_req <= 0;
        d_data <= 0;
        d_addr <= 0;
        d_write <= 0;
    end

endmodule

/* next steps:
- get some food now
- dog out at 7
- work until 9
- then do streaks
- reward: eat dinner
- then domestic work
- finish w/ final dog outing
*/