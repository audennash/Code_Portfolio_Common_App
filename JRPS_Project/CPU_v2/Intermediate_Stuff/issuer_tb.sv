module top_module_issuer_tb ();
    reg clk=0;
	always #5 clk = ~clk;


    reg [4:0] r_op1;
    reg [4:0] r_op2;
    reg [4:0] r_d;
    reg [21:0] imm;
    reg immsub;
    reg [3:0] FU_type;
    reg [3:0] FU_param;
    reg [12:0] busy;
    reg fetch_stall;
    reg run;
    reg flush;

    wire [4:0] decode_wreg [12:0];
    wire [4:0] decode_rreg1 [12:0];
    wire [4:0] decode_rreg2 [12:0];
    wire [3:0] FU_param_out [12:0];
    wire immsub_out [12:0];
    wire [21:0] imm_out [12:0];
    wire [3:0] issue_fu;
    wire issue_stall;


    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module);

        print_fu_regs(); 

        run <= 1; fetch_stall <= 0; flush <= 0; r_op1 <= 6; r_op2 <= 7; r_d <= 8; FU_type <= 1; busy <= 0; #10;
        print_fu_regs(); 
        
        busy[1] <= 1; r_op1 <= 9; r_op2 <= 10; #10;
        print_fu_regs();

        busy[1] <= 0; #10;
        print_fu_regs();

        FU_type <= 2; fetch_stall <= 1; #10;
        print_fu_regs();

        FU_type <= 6; fetch_stall <= 0; r_op1 <= 1; r_op2 <= 2; r_d <= 3; #10;
        print_fu_regs();

        r_op1 <= 3; r_op2 <= 4; r_d <= 5; busy[issue_fu] <= 1; #10;
        print_fu_regs();

        busy[issue_fu] <= 1; r_op1 <= 6; r_op2 <= 7; r_d <= 8; #10;
        print_fu_regs();

        busy[7] <= 0; #10;
        print_fu_regs();

        FU_type <= 12; r_op1 <= 4; r_op2 <= 11; r_d <= 12; #10;
        print_fu_regs();

        flush <= 1; #10;
        print_fu_regs();

        $finish;
    end

    function void print_fu_regs();
        $display("\n%0d", $time);
        $write("decode_wregs: ");
        for (int i=0; i<13; i=i+1) begin
            $write(decode_wreg[i], " ");
        end
        $write("\ndecode_rregs1: ");
        for (int i=0; i<13; i=i+1) begin
            $write(decode_rreg1[i], " ");
        end
        $write("\ndecode_rregs2: ");
        for (int i=0; i<13; i=i+1) begin
            $write(decode_rreg2[i], " ");
        end
        $write("\nFU_params_out: ");
        for (int i=0; i<13; i=i+1) begin
            $write(decode_rreg2[i], " ");
        end
        $write("\nimmsubs_out: ");
        for (int i=0; i<13; i=i+1) begin
            $write(decode_rreg2[i], " ");
        end
        $write("\nimms_out: ");
        for (int i=0; i<13; i=i+1) begin
            $write(decode_rreg2[i], " ");
        end
        $display("\nissue_fu: ", issue_fu, "\nissue_stall: ", issue_stall);
    endfunction

    issuer test_issuer (r_op1, r_op2, r_d, imm, immsub, FU_type, FU_param,
    busy, fetch_stall,
    run, flush, clk,
    decode_wreg, decode_rreg1, decode_rreg2, FU_param_out, immsub_out, imm_out,
    issue_fu,
    issue_stall);
    
endmodule