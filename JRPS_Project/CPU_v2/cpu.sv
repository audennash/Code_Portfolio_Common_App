module cpu #(parameter first_port = 252) (
    input cpu_run,
    input cpu_reset,
    input clk,
    input [31:0] mem_out,
    input mem_done,
    output [31:0] cpu_data,
    output [31:0] cpu_addr,
    output cpu_write,
    output cpu_req,
    output halted);

    wire set_hr;
    reg halt_ready;
    wire assert_halt;
    reg halt_reg;
    assign halted = assert_halt | halt_reg;
    reg run;
    wire flush = cpu_reset;
    always @(posedge clk) begin
        if (cpu_run) begin
            run <= (~halted);
        end else begin
            run <= 0;
        end
        if (set_hr) begin
            halt_ready <= 1;
        end
        if (assert_halt) begin
            halt_reg <= 1;
        end
    end
    always @(posedge flush) begin
        halt_reg <= 0;
        halt_ready <= 0;
    end
    initial begin
        run <= 0;
        halt_reg <= 0;
        halt_ready <= 0;
    end
    
    wire fetch_stall;
    wire issue_stall;

    wire branch_inst;
    wire [31:0] branch_addr;
    wire branch_taken;


    wire [31:0] i_addr;
    wire i_req;
    wire [31:0] inst;

    wire [31:0] mi_data;
    wire [31:0] mi_addr;
    wire mi_write;
    wire mi_req;
    wire [31:0] mi_resp;
    wire mi_req_completed;

    wire [31:0] d_out;
    wire exec = mi_req || i_req;
    wire [31:0] data_in = mi_data;
    wire [31:0] addr_in = i_req? i_addr : mi_addr;
    wire write_in = i_req? 0 : mi_write;
    wire req_completed;
    wire branch_coming;

    ifu #(32, 2**32, 64) main_ifu (.branch_coming(branch_coming), .branch_inst_set(branch_inst), .branch_addr(branch_addr), .branch_taken(branch_taken),
    .mi_req(mi_req), .d_data(data_in), .d_addr(addr_in), .d_write(write_in), .d_out(d_out), 
    .req_completed(req_completed), .issue_stall(issue_stall), .run(run), .flush(flush), .clk(clk), 
    .i_addr(i_addr), .i_req(i_req), .inst(inst), .stall(fetch_stall));

    assign mi_resp = d_out;
    assign mi_req_completed = i_req? 0 : req_completed;

    dfu #(32, 2**32, 128, first_port) main_dfu (.exec(exec), .data_in(data_in), .addr_in(addr_in), .write_in(write_in), 
    .mem_out(mem_out), .mem_done(mem_done), .i_req(i_req), .run(run), .flush(flush), .clk(clk), 
    .data_out(d_out), .req_completed(req_completed), .d_req(cpu_req), .d_data(cpu_data), .d_addr(cpu_addr), .d_write(cpu_write));


    wire [4:0] r_op1;
    wire [4:0] r_op2;
    wire [4:0] r_d;
    wire [21:0] imm;
    wire immsub;
    wire [3:0] FU_type;
    wire [3:0] FU_param;
    
    assign branch_coming = (FU_type == 10);

    decoder main_decoder (.inst(inst),
    .r_op1(r_op1), .r_op2(r_op2), .r_d(r_d), .imm(imm), .immsub(immsub),
    .FU_type(FU_type), .FU_param(FU_param));


    reg [12:0] busy;
    reg [4:0] decode_wreg [12:0];
    reg [4:0] decode_rreg1 [12:0];
    reg [4:0] decode_rreg2 [12:0];
    reg [3:0] FU_param_regs [12:0];
    reg immsub_out [12:0];
    reg [21:0] imm_out [12:0];
    wire [3:0] issue_fu;

    issuer main_issuer (.r_op1(r_op1), .r_op2(r_op2), .r_d(r_d), .imm(imm), .immsub(immsub), .FU_type(FU_type), .FU_param(FU_param),
    .busy(busy), .fetch_stall(fetch_stall), .run(run), .flush(flush), .clk(clk),
    .decode_wreg(decode_wreg), .decode_rreg1(decode_rreg1), .decode_rreg2(decode_rreg2), .FU_param_out(FU_param_regs), .immsub_out(immsub_out), .imm_out(imm_out),
    .issue_fu(issue_fu), .issue_stall(issue_stall)); 


    reg [1:0] fu_phase [12:0];
    wire [12:0] can_read;
    wire [12:0] can_write;
    wire [12:0] read_enable;
    wire [12:0] write_enable;
    reg [12:0] active;

    scoreboard #(.fu_count(13)) main_scoreboard(.decode_rreg1(r_op1), .decode_rreg2(r_op2), .decode_wreg(r_d), .issue_fu(issue_fu), .issue_stall(issue_stall),
    .fu_phase(fu_phase), .dr(decode_wreg), .run(run), .flush(flush), .clk(clk),
    .can_read(can_read), .can_write(can_write), .read_enable(read_enable), .write_enable(write_enable), .active(active));


    wire [4:0] sr1;
    wire [4:0] sr2;
    wire [4:0] dr;
    wire [31:0] wb_data;
    wire [31:0] op1;
    wire [31:0] op2;

    register_file main_rf (.r_op1(sr1), .r_op2(sr2), .r_d(dr),
    .data(wb_data), .clk(clk), .flush(flush),
    .op1(op1), .op2(op2));


    wire [31:0] op1_a [12:0];
    wire [31:0] op2_a [12:0];
    wire [12:0] use_imm_a;
    wire [21:0] imm_a [12:0];
    wire [3:0] operation_a [12:0];
    wire execute_a [12:0];
    wire [31:0] result_a [12:0];

    wire [4:0] sr1_a [12:0];
    wire [4:0] sr2_a [12:0];
    wire [4:0] dr_a [12:0];
    wire [31:0] dr_data_a [12:0];

    wire [4:0] sr1_r [12:0];
    wire [4:0] sr2_r [12:0];
    wire [4:0] dr_r [12:0];
    wire [31:0] dr_data_r [12:0];

    assign sr1 = sr1_r[12];
    assign sr2 = sr2_r[12];
    assign dr = dr_r[12];
    assign wb_data = dr_data_r[12];

    function automatic integer stall_time(input integer fu_id);
        case(fu_id)
            0 : stall_time = 0;
            1 : stall_time = 0;
            2 : stall_time = 10;
            3 : stall_time = 10;
            4 : stall_time = 30;
            5 : stall_time = 320;
            6 : stall_time = 320;
            7 : stall_time = 320;
            8 : stall_time = 320;
            9 : stall_time = 10;
            10 : stall_time = 0;
            11 : stall_time = 10;
            12 : stall_time = 0;
            default : stall_time = 10;
        endcase
    endfunction

    halter main_halter (op1_a[1], op2_a[1], use_imm_a[1], imm_a[1], operation_a[1], execute_a[1], result_a[1], set_hr);
    assign assert_halt = halt_ready && ~(|busy);

    comparator main_comparator (op1_a[2], op2_a[2], use_imm_a[2], imm_a[2], operation_a[2], execute_a[2], result_a[2]);

    logic_unit main_logic_unit (op1_a[3], op2_a[3], use_imm_a[3], imm_a[3], operation_a[3], execute_a[3], result_a[3]);

    adder adder1 (op1_a[4], op2_a[4], use_imm_a[4], imm_a[4], operation_a[4], execute_a[4], result_a[4]);

    multiplier multiplier1 (op1_a[5], op2_a[5], use_imm_a[5], imm_a[5], operation_a[5], execute_a[5], result_a[5]);

    multiplier multiplier2 (op1_a[6], op2_a[6], use_imm_a[6], imm_a[6], operation_a[6], execute_a[6], result_a[6]);

    divider divider1 (op1_a[7], op2_a[7], use_imm_a[7], imm_a[7], operation_a[7], execute_a[7], result_a[7]);

    divider divider2 (op1_a[8], op2_a[8], use_imm_a[8], imm_a[8], operation_a[8], execute_a[8], result_a[8]);

    shifter shifter1 (op1_a[9], op2_a[9], use_imm_a[9], imm_a[9], operation_a[9], execute_a[9], result_a[9]);

    loadimm loadimm1 (op1_a[10], op2_a[10], use_imm_a[10], imm_a[10], operation_a[10], execute_a[10], result_a[10]);


    memory_interface memory_interface1 (op1, op2, can_read[11], can_write[11], read_enable[11], write_enable[11], active[11],
    decode_wreg[11], decode_rreg1[11], decode_rreg2[11], FU_param_regs[11], immsub_out[11], imm_out[11],
    run, flush, clk,
    dr_data_a[11], dr_a[11], sr1_a[11], sr2_a[11], fu_phase[11], busy[11], 
    mi_req, mi_data, mi_addr, mi_write, mi_resp, mi_req_completed);
    assign sr1_r[11] = sr1_r[10] | (read_enable[11]? sr1_a[11] : 0);
    assign sr2_r[11] = sr2_r[10] | (read_enable[11]? sr2_a[11] : 0);
    assign dr_r[11] = dr_r[10] | (write_enable[11]? dr_a[11] : 0);
    assign dr_data_r[11] = dr_data_r[10] | (write_enable[11]? dr_data_a[11] : 0);

    branch_handler branch_handler1 (op1_a[12], op2_a[12], use_imm_a[12], imm_a[12], operation_a[12], execute_a[12], result_a[12], branch_inst, branch_addr, branch_taken, FU_type);


    genvar i;
    generate
        for (i=1; i<13; i=i+1) begin: fu_handler_array
            if (i != 11) begin
                fu_handler #(.delay(stall_time(i)), .imm_width(22)) a_handler (op1, op2, can_read[i], can_write[i], read_enable[i], write_enable[i], active[i],
                decode_wreg[i], decode_rreg1[i], decode_rreg2[i], FU_param_regs[i], immsub_out[i], imm_out[i],
                run, flush, clk,
                dr_data_a[i], dr_a[i], sr1_a[i], sr2_a[i], fu_phase[i], busy[i], op1_a[i], op2_a[i], use_imm_a[i], imm_a[i], operation_a[i], execute_a[i], result_a[i]);

                assign sr1_r[i] = sr1_r[i-1] | (read_enable[i]? sr1_a[i] : 0);
                assign sr2_r[i] = sr2_r[i-1] | (read_enable[i]? sr2_a[i] : 0);
                assign dr_r[i] = dr_r[i-1] | (write_enable[i]? dr_a[i] : 0);
                assign dr_data_r[i] = dr_data_r[i-1] | (write_enable[i]? dr_data_a[i] : 0);
            end
        end
    endgenerate

    assign sr1_r[0] = 0;
    assign sr2_r[0] = 0;
    assign dr_r[0] = 0;
    assign dr_data_r[0] = 0;
    assign fu_phase[0] = 0;
    initial begin
        busy[0] <= 0;
    end


endmodule