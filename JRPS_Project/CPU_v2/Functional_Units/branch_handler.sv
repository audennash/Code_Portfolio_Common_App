module top_module_branch_handler(); //a few quirks due to rehaul, logic seems to work fine
    reg clk=0;
	always #5 clk = ~clk;

    reg [31:0] op1;
    reg [31:0] op2;
    reg [21:0] imm;
    reg [3:0] FU_type;
    reg [3:0] FU_param;
    reg FU_run;
    reg FU_reset;
    wire branch_inst;
    wire [31:0] branch_addr;
    wire branch_taken;
    wire [31:0] result;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module);

        op1 <= 0; op2 <= 0; imm <= 0; FU_type <= 0; FU_param <= 0; FU_run <= 1; FU_reset <= 0; #10;
        $display("op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param[1:0], "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, 
        " ||| branch_inst: ", branch_inst, "; branch_addr: ", branch_addr, "; branch_taken: ", branch_taken);


        $display("TESTING val10 addr46");
        FU_type = 10; op1 <= 10; op2 <= 46; imm <= 7; imm[21] <= 1;
        FU_param <= 2'b00; #10;
        $display("BRZ | op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param[1:0], "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, 
        " ||| branch_inst: ", branch_inst, "; branch_addr: ", branch_addr, "; branch_taken: ", branch_taken);
        FU_param <= 2'b01; #10;
        $display("BRNZ | op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param[1:0], "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, 
        " ||| branch_inst: ", branch_inst, "; branch_addr: ", branch_addr, "; branch_taken: ", branch_taken);
        FU_param <= 2'b10; #10;
        $display("JUMP | op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param[1:0], "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, 
        " ||| branch_inst: ", branch_inst, "; branch_addr: ", branch_addr, "; branch_taken: ", branch_taken);


        $display("TESTING val11 addr46");
        op1 <= 11;
        FU_param <= 2'b00; #10;
        $display("BRZ | op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param[1:0], "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, 
        " ||| branch_inst: ", branch_inst, "; branch_addr: ", branch_addr, "; branch_taken: ", branch_taken);
        FU_param <= 2'b01; #10;
        $display("BRNZ | op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param[1:0], "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, 
        " ||| branch_inst: ", branch_inst, "; branch_addr: ", branch_addr, "; branch_taken: ", branch_taken);
        FU_param <= 2'b10; #10;
        $display("JUMP | op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param[1:0], "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, 
        " ||| branch_inst: ", branch_inst, "; branch_addr: ", branch_addr, "; branch_taken: ", branch_taken);


        $display("NO RUN");
        FU_run <= 0;
        FU_param <= 2'b00; #10;
        $display("BRZ | op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param[1:0], "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, 
        " ||| branch_inst: ", branch_inst, "; branch_addr: ", branch_addr, "; branch_taken: ", branch_taken);
        FU_param <= 2'b01; #10;
        $display("BRNZ | op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param[1:0], "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, 
        " ||| branch_inst: ", branch_inst, "; branch_addr: ", branch_addr, "; branch_taken: ", branch_taken);
        FU_param <= 2'b10; #10;
        $display("JUMP | op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param[1:0], "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, 
        " ||| branch_inst: ", branch_inst, "; branch_addr: ", branch_addr, "; branch_taken: ", branch_taken);

        $finish;
    end

    branch_handler test_bh (op1, op2, ,imm, FU_param, FU_run, result, branch_inst, branch_addr, branch_taken);

endmodule

module branch_handler (
    input [31:0] op1,
    input [31:0] op2,
    input use_imm,
    input [21:0] imm,
    input [3:0] operation,
    input execute,
    output [31:0] result,
    output branch_inst,
    output [31:0] branch_addr,
    output branch_taken,
    input [3:0] FU_type);

    wire [31:0] base_addr = operation[1]? op1 : op2;
    wire [21:0] imm_to_sum = operation[1]? imm : {5'b00000, imm[16:0]};
    wire value_for_comparison = operation[0]? ~op1[0] : op1[0];
    wire taken_if_branch_inst = operation[1]? 1'b1 : value_for_comparison;

    assign result = 0;
    assign branch_inst = execute;
    assign branch_addr = base_addr + imm_to_sum;
    assign branch_taken = (FU_type == 10)? taken_if_branch_inst : 0;
endmodule