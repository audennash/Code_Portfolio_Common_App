module top_module_fu_handler_tb ();
    reg clk=0;
	always #5 clk = ~clk;


    reg [31:0] sr1_data;
    reg [31:0] sr2_data;
    reg can_read; 
    reg can_write;
    reg read_enable;
    reg write_enable;
    reg active;
    reg [4:0] decode_wreg;
    reg [4:0] decode_rreg1;
    reg [4:0] decode_rreg2;
    reg [3:0] FU_param;
    reg immsub;
    reg [21:0] imm;
    reg run;
    reg flush;

    wire [31:0] dr_data;
    wire [4:0] dr;
    wire [4:0] sr1;
    wire [4:0] sr2;
    reg [1:0] phase;
    reg busy;
    reg [31:0] o1;
    reg [31:0] o2;
    wire [3:0] operation;
    wire execute;

    reg [31:0] execution_result;


    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module);

        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | o1: %0d", o1, "; o2: %0d", o2, "; operation: %b", operation, "; execute: %0d", execute);

        decode_wreg <= 3; decode_rreg1 <= 1; decode_rreg2 <= 2; FU_param <= 4'b1001; immsub <= 0; imm <= 308; run <= 1; flush <= 0; #10;
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | o1: %0d", o1, "; o2: %0d", o2, "; operation: %b", operation, "; execute: %0d", execute);

        active <= 1; #10;
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | o1: %0d", o1, "; o2: %0d", o2, "; operation: %b", operation, "; execute: %0d", execute);

        can_read <= 1; #10;
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | o1: %0d", o1, "; o2: %0d", o2, "; operation: %b", operation, "; execute: %0d", execute);

        read_enable <= 1; sr1_data <= 11; sr2_data <= 12; #10;
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | o1: %0d", o1, "; o2: %0d", o2, "; operation: %b", operation, "; execute: %0d", execute);

        $display("begin wait time"); can_write <= 1; read_enable <= 0; sr1_data <= 69; sr2_data <= 420;
        for (int i=0; i<4; i=i+1) begin
            #10; $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
            " | phase: %b", phase, "; busy: ", busy, 
            " | o1: %0d", o1, "; o2: %0d", o2, "; operation: %b", operation, "; execute: %0d", execute);
        end
        execution_result <= 13;
        #10; $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
            " | phase: %b", phase, "; busy: ", busy, 
            " | o1: %0d", o1, "; o2: %0d", o2, "; operation: %b", operation, "; execute: %0d", execute);

        #10; 
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | o1: %0d", o1, "; o2: %0d", o2, "; operation: %b", operation, "; execute: %0d", execute);

        write_enable <= 1; #10;
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | o1: %0d", o1, "; o2: %0d", o2, "; operation: %b", operation, "; execute: %0d", execute);

        active <= 0; can_read <= 0; write_enable <= 0; can_write <= 0; #10;
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | o1: %0d", o1, "; o2: %0d", o2, "; operation: %b", operation, "; execute: %0d", execute);

        $display("IMM TEST");
        active <= 1; immsub <= 1; imm <= {1'b1, {5{1'b0}}, 2'b11, {14{1'b0}} }; #10; 
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | o1: %0d", o1, "; o2: %0d", o2, "; operation: %b", operation, "; execute: %0d", execute);

        can_read <= 1; #10;
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | o1: %0d", o1, "; o2: %0d", o2, "; operation: %b", operation, "; execute: %0d", execute);

        read_enable <= 1; #10;
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | o1: %0d", o1, "; o2: %0d", o2, "; operation: %b", operation, "; execute: %0d", execute);

        read_enable <= 0; #10;
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | o1: %0d", o1, "; o2: %0d", o2, "; operation: %b", operation, "; execute: %0d", execute);


        $finish;
    end

    fu_handler #(50, 15) test_fu (sr1_data, sr2_data, 
    can_read, can_write, read_enable, write_enable, active, 
    decode_wreg, decode_rreg1, decode_rreg2, 
    FU_param, immsub, imm, 
    run, flush, clk, 
    dr_data, dr, sr1, sr2, 
    phase, busy, o1, o2, ,operation, execute, execution_result);
    
endmodule