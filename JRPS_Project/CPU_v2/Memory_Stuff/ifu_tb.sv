module top_module_ifu_tb();
    reg clk = 0;
    always #5 clk = ~clk;

    reg branch_inst = 0;
    reg [31:0] branch_addr = 0;
    reg branch_taken = 0;
    reg mi_req = 0;
    reg issue_stall = 0;
    reg run = 0;
    reg flush = 0;
    
    reg next_run = 0;

    reg [31:0] d_data = 0;
    reg [31:0] d_addr = 0;
    reg d_write = 0;
    reg [31:0] d_out = 0;
    reg req_completed = 0;

    
    wire [31:0] i_addr;
    wire i_req;
    wire [31:0] inst;
    wire fetch_stall;
    
    reg [31:0] mem_temp [255:0];

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module);

        for (int i=0; i<32; i=i+1) begin
            mem_temp[i] <= i+10;
        end
    
        #10; d_data <= 0; d_addr <= 0; mi_req <= 0; d_write <= 0; next_run <= 1; issue_stall <= 0;
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "||| d_out: ", d_out, "; req_completed: ", req_completed); //test incrementation


        $display("INCREMENTATION TEST");
        for (int i=0; i<10; i=i+1) begin
            #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
            d_out <= mem_temp[i_addr]; 
            #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
            req_completed <= 1;
            #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed, "DONE?");
            req_completed <= 0;
        end
        
        $display("STALL DUE TO mi_req TEST");
        mi_req <= 1;
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        req_completed <= 0; 
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        req_completed <= 1;
        #1; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        #9; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        req_completed <= 0;
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        mi_req <= 0;
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        mi_req <= 1;
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        req_completed <= 1; d_out <= mem_temp[i_addr]; 
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        req_completed <= 0; mi_req <= 0;

        $display("POST-STALL INCREMENTATION TEST");
        for (int i=0; i<3; i=i+1) begin
            #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
            d_out <= mem_temp[i_addr]; 
            #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
            req_completed <= 1;
            #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed, "DONE?");
            req_completed <= 0;
        end

        $display("RUN OFF TEST");
        next_run <= 0;
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        next_run <= 1;
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);

        $display("BRANCHING -- BNT -- TEST");
        branch_inst <= 1; branch_addr <= 18;
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        req_completed <= 1; d_out <= mem_temp[i_addr];
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        req_completed <= 0;
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        $display("BRANCHING -- BT -- TEST");
        branch_taken <= 1; 
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        req_completed <= 1; d_out <= mem_temp[i_addr];
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        req_completed <= 0;
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        req_completed <= 1; d_out <= mem_temp[i_addr];
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        branch_addr <= 2; req_completed <= 0;
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);

        $display("CACHE USE TEST");
        branch_inst <= 0; branch_taken <= 0;
        for (int i=0; i<10; i=i+1) begin
            #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
            d_out <= mem_temp[i_addr]; 
            #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
            req_completed <= 1;
            #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed, "DONE?");
            req_completed <= 0;
        end
        

        $display("MIWRITE TEST");
        mi_req <= 1; d_addr <= 23; d_data <=67; d_write <= 0; 
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        req_completed <= 1; d_out <= 69;
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        req_completed <= 0; d_write <= 1; 
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        req_completed <= 1; d_write <= 0; d_out <= mem_temp[i_addr];
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        req_completed <= 0; d_write <= 1; d_addr <= 24;
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        req_completed <= 1; d_write <= 0; mem_temp[d_addr] <= d_data;
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        req_completed <= 0; 
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        req_completed <= 1; d_out <= mem_temp[i_addr];
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        branch_addr <= 2; branch_inst <= 1; branch_taken <= 1; req_completed <= 0;
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        d_write <= 1; d_addr <= 3; d_data <= 71; branch_inst <= 0; branch_taken <= 0;
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);

        $display("ISSUE STALL TEST");
        issue_stall <= 1; mi_req <= 0; d_write <= 0;
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);
        issue_stall <= 0;
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst,  "; fetch_stall: ", fetch_stall, "||| i_req: ", i_req, "; d_out: ", d_out, "; req_completed: ", req_completed);


        /*#10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out);
        mi_req <= 1;
        $display("stall due to dreq test");
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out); //test stalling
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out);
        mi_req <= 0;
        $display("post-stall incrementation test");
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out); //test post-stall incrementation
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out);
        next_run <= 0;
        $display("run off test");
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out); //test when run is off
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out);
        next_run <= 1; branch_inst <= 1; branch_addr <= 2;
        $display("branching -- branch not taken -- test"); 
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out); //test branching (not taken)
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out);
        branch_taken <= 1;
        $display("branching -- branch taken -- test"); 
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out); //test branching (taken)
        branch_inst <= 0; branch_taken <= 0; mi_req <= 0;
        $display("loop again -- d_req 0 -- test"); 
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out);
        mi_req <= 1;
        $display("loop again -- d_req 1 -- test"); 
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out);
        branch_inst <= 1; branch_taken <= 1;
        $display("go back");
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out);
        branch_inst <= 0; branch_taken <= 0;
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out);
        $display("data overwrite test");
        mi_req <= 1; d_data <= 15; d_addr <= 5; d_write <= 1;
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out);
        mi_req <= 0; d_write <= 0;
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out);
        next_run <= 0;
        $display("turned off test");
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out);
        #10; $display("pc: ", test_ifu.pc, "; inst: ", inst, "; fetch_stall: ", fetch_stall, "; d_out: ", d_out);*/

        $finish;
    end

    ifu #(32, 2**32, 64) test_ifu (branch_inst, branch_addr, branch_taken, mi_req, d_data, d_addr, d_write, d_out, req_completed, issue_stall, run, flush, clk, 
    i_addr, i_req, inst, fetch_stall);

    always @(posedge clk) begin
        run <= next_run;
    end
    always @(posedge flush) begin
        branch_inst <= 0;
        branch_addr <= 0;
        branch_taken <= 0;
        mi_req <= 0;
        d_data <= 0;
        d_addr <= 0;
        d_write <= 0;
        d_out <= 0;
        req_completed <= 0;
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