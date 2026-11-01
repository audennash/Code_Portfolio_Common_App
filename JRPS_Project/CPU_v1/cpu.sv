module cpu (
    input cpu_run,
    input cpu_reset,
    input clk,
    input [31:0] mem_out,
    output [31:0] cpu_data,
    output [31:0] cpu_addr,
    output cpu_write,
    output reg halted);

    wire set_halt;
    reg run;
    wire flush = cpu_reset;
    always @(posedge clk) begin
        if (cpu_run) begin
            run <= (~set_halt) && (~halted);
        end else begin
            run <= 0;
        end
        if (set_halt) begin
            halted <= 1;
        end
    end
    always @(posedge flush) begin
        halted <= 0;
    end
    initial begin
        run <= 0;
        halted <= 0;
    end
    


    wire branch_inst;
    wire [31:0] branch_addr;
    wire branch_taken;
    wire d_req;
    wire [31:0] d_addr;
    wire [31:0] i_addr;
    wire choose_i;
    wire [31:0] inst;
    wire stall;

    ifu #(32, 2**32, 64) main_ifu (.branch_inst(branch_inst), .branch_addr(branch_addr), .branch_taken(branch_taken), 
    .d_req(d_req), .d_data(cpu_data), .d_addr(d_addr), .d_write(cpu_write), .mem_out(mem_out), 
    .run(run), .flush(flush), .clk(clk),
    .i_addr(i_addr), .choose_i(choose_i), .inst(inst), .stall(stall));


    wire [4:0] r_op1;
    wire [4:0] r_op2;
    wire [4:0] r_d;
    wire [21:0] imm;
    wire immsub;
    wire [3:0] FU_type;
    wire [3:0] FU_param;
    wire FU_run;
    wire FU_reset;

    decoder main_decoder (.inst(inst), .stall(stall), .run(run),
    .r_op1(r_op1), .r_op2(r_op2), .r_d(r_d), .imm(imm), .immsub(immsub),
    .FU_type(FU_type), .FU_param(FU_param), .FU_run(FU_run));


    wire [31:0] wb_data;
    wire [31:0] op1;
    wire [31:0] op2;

    register_file main_rf (.r_op1(r_op1), .r_op2(r_op2), .r_d(r_d),
    .data(wb_data), .clk(clk), .flush(flush), .FU_run(FU_run),
    .imm(imm), .immsub(immsub),
    .op1(op1), .op2(op2));


    halter main_halter (op1, op2, imm, FU_type, FU_param, FU_run, FU_reset, set_halt);

    wire [31:0] comparator1_out;
    comparator comparator1 (op1, op2, imm, FU_type, FU_param, FU_run, FU_reset, comparator1_out);

    wire [31:0] logic_unit1_out;
    logic_unit logic_uni1 (op1, op2, imm, FU_type, FU_param, FU_run, FU_reset, logic_unit1_out);

    wire [31:0] adder1_out;
    adder adder1 (op1, op2, imm, FU_type, FU_param, FU_run, FU_reset, adder1_out);

    wire [31:0] multiplier1_out;
    multiplier multiplier1 (op1, op2, imm, FU_type, FU_param, FU_run, FU_reset, multiplier1_out);

    wire [31:0] divider1_out;
    divider divider1 (op1, op2, imm, FU_type, FU_param, FU_run, FU_reset, divider1_out);

    wire [31:0] shifter1_out;
    shifter shifter1 (op1, op2, imm, FU_type, FU_param, FU_run, FU_reset, shifter1_out);

    wire [31:0] loadimm1_out;
    loadimm loadimm1 (op1, op2, imm, FU_type, FU_param, FU_run, FU_reset, loadimm1_out);

    wire [31:0] mem_wb;
    memory_interface memory_interface1 (op1, op2, imm, FU_type, FU_param, FU_run, FU_reset, i_addr, choose_i, mem_out, d_req, d_addr, cpu_data, cpu_addr, cpu_write, mem_wb);

    branch_handler branch_handler1 (op1, op2, imm, FU_type, FU_param, FU_run, FU_reset, branch_inst, branch_addr, branch_taken);


    assign wb_data = comparator1_out | logic_unit1_out | adder1_out | multiplier1_out | divider1_out | shifter1_out | loadimm1_out | mem_wb;


endmodule