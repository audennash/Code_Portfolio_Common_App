module top_module_memory_interface ();
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
    reg mi_exec;
    reg [31:0] mi_data;
    reg [31:0] mi_addr;
    reg mi_write;
    
    reg [31:0] mi_resp;
    reg mi_req_completed;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module);

        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | mi_exec: ", mi_exec, "; mi_data: %0d", mi_data, "; mi_addr: %0d", mi_addr, "; mi_write: ", mi_write,
        " ||| mi_resp: %0d", mi_resp, "; mi_req_completed: ", mi_req_completed);

        decode_wreg <= 3; decode_rreg1 <= 1; decode_rreg2 <= 2; FU_param[0] <= 1; immsub <= 0; imm <= 308; run <= 1; flush <= 0; #10;
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | mi_exec: ", mi_exec, "; mi_data: %0d", mi_data, "; mi_addr: %0d", mi_addr, "; mi_write: ", mi_write,
        " ||| mi_resp: %0d", mi_resp, "; mi_req_completed: ", mi_req_completed);

        active <= 1; #10;
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | mi_exec: ", mi_exec, "; mi_data: %0d", mi_data, "; mi_addr: %0d", mi_addr, "; mi_write: ", mi_write,
        " ||| mi_resp: %0d", mi_resp, "; mi_req_completed: ", mi_req_completed);

        can_read <= 1; #10;
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | mi_exec: ", mi_exec, "; mi_data: %0d", mi_data, "; mi_addr: %0d", mi_addr, "; mi_write: ", mi_write,
        " ||| mi_resp: %0d", mi_resp, "; mi_req_completed: ", mi_req_completed);

        read_enable <= 1; sr1_data <= 11; sr2_data <= 12; #10;
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | mi_exec: ", mi_exec, "; mi_data: %0d", mi_data, "; mi_addr: %0d", mi_addr, "; mi_write: ", mi_write,
        " ||| mi_resp: %0d", mi_resp, "; mi_req_completed: ", mi_req_completed);

        $display("begin wait time"); can_write <= 1; read_enable <= 0; sr1_data <= 69; sr2_data <= 420;
        for (int i=0; i<4; i=i+1) begin
            #10; $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | mi_exec: ", mi_exec, "; mi_data: %0d", mi_data, "; mi_addr: %0d", mi_addr, "; mi_write: ", mi_write,
        " ||| mi_resp: %0d", mi_resp, "; mi_req_completed: ", mi_req_completed);
        end
        mi_req_completed <= 1; mi_resp <= 13; #10;
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | mi_exec: ", mi_exec, "; mi_data: %0d", mi_data, "; mi_addr: %0d", mi_addr, "; mi_write: ", mi_write,
        " ||| mi_resp: %0d", mi_resp, "; mi_req_completed: ", mi_req_completed);

        mi_req_completed <= 0; mi_resp <= 18; #10;
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | mi_exec: ", mi_exec, "; mi_data: %0d", mi_data, "; mi_addr: %0d", mi_addr, "; mi_write: ", mi_write,
        " ||| mi_resp: %0d", mi_resp, "; mi_req_completed: ", mi_req_completed);

        write_enable <= 1; #10;
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | mi_exec: ", mi_exec, "; mi_data: %0d", mi_data, "; mi_addr: %0d", mi_addr, "; mi_write: ", mi_write,
        " ||| mi_resp: %0d", mi_resp, "; mi_req_completed: ", mi_req_completed);

        active <= 0; can_read <= 0; write_enable <= 0; can_write <= 0; #10;
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | mi_exec: ", mi_exec, "; mi_data: %0d", mi_data, "; mi_addr: %0d", mi_addr, "; mi_write: ", mi_write,
        " ||| mi_resp: %0d", mi_resp, "; mi_req_completed: ", mi_req_completed);

        FU_param[0] <= 0; immsub <= 1; imm <= {1'b1, {5{1'b0}}, 2'b11, {14{1'b0}} }; #10; 
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | mi_exec: ", mi_exec, "; mi_data: %0d", mi_data, "; mi_addr: %0d", mi_addr, "; mi_write: ", mi_write,
        " ||| mi_resp: %0d", mi_resp, "; mi_req_completed: ", mi_req_completed);

        active <= 1; #10;
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | mi_exec: ", mi_exec, "; mi_data: %0d", mi_data, "; mi_addr: %0d", mi_addr, "; mi_write: ", mi_write,
        " ||| mi_resp: %0d", mi_resp, "; mi_req_completed: ", mi_req_completed);

        can_read <= 1; #10;
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | mi_exec: ", mi_exec, "; mi_data: %0d", mi_data, "; mi_addr: %0d", mi_addr, "; mi_write: ", mi_write,
        " ||| mi_resp: %0d", mi_resp, "; mi_req_completed: ", mi_req_completed);

        #10;
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | mi_exec: ", mi_exec, "; mi_data: %0d", mi_data, "; mi_addr: %0d", mi_addr, "; mi_write: ", mi_write,
        " ||| mi_resp: %0d", mi_resp, "; mi_req_completed: ", mi_req_completed);
        
        read_enable <= 1; #10;
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | mi_exec: ", mi_exec, "; mi_data: %0d", mi_data, "; mi_addr: %0d", mi_addr, "; mi_write: ", mi_write,
        " ||| mi_resp: %0d", mi_resp, "; mi_req_completed: ", mi_req_completed);

        read_enable <= 0; #10;
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | mi_exec: ", mi_exec, "; mi_data: %0d", mi_data, "; mi_addr: %0d", mi_addr, "; mi_write: ", mi_write,
        " ||| mi_resp: %0d", mi_resp, "; mi_req_completed: ", mi_req_completed);

        #50; mi_req_completed <= 1; mi_resp <= 67; #10;
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | mi_exec: ", mi_exec, "; mi_data: %0d", mi_data, "; mi_addr: %0d", mi_addr, "; mi_write: ", mi_write,
        " ||| mi_resp: %0d", mi_resp, "; mi_req_completed: ", mi_req_completed);

        mi_req_completed <= 0; mi_resp <= 689; #10;
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | mi_exec: ", mi_exec, "; mi_data: %0d", mi_data, "; mi_addr: %0d", mi_addr, "; mi_write: ", mi_write,
        " ||| mi_resp: %0d", mi_resp, "; mi_req_completed: ", mi_req_completed);

        can_write <= 1; #10;
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | mi_exec: ", mi_exec, "; mi_data: %0d", mi_data, "; mi_addr: %0d", mi_addr, "; mi_write: ", mi_write,
        " ||| mi_resp: %0d", mi_resp, "; mi_req_completed: ", mi_req_completed);

        write_enable <= 1; active <= 0; can_read <= 0; #10;
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | mi_exec: ", mi_exec, "; mi_data: %0d", mi_data, "; mi_addr: %0d", mi_addr, "; mi_write: ", mi_write,
        " ||| mi_resp: %0d", mi_resp, "; mi_req_completed: ", mi_req_completed);

        #10;
        $display($time, " dr_data: %0d", dr_data, "; dr: %0d", dr, "; sr1: %0d", sr1, "; sr2: %0d", sr2, 
        " | phase: %b", phase, "; busy: ", busy, 
        " | mi_exec: ", mi_exec, "; mi_data: %0d", mi_data, "; mi_addr: %0d", mi_addr, "; mi_write: ", mi_write,
        " ||| mi_resp: %0d", mi_resp, "; mi_req_completed: ", mi_req_completed);


        $finish;
    end
    
    memory_interface test_mi (sr1_data, sr2_data, 
    can_read, can_write, read_enable, write_enable, active, 
    decode_wreg, decode_rreg1, decode_rreg2, 
    FU_param, immsub, imm, 
    run, flush, clk, 
    dr_data, dr, sr1, sr2, 
    phase, busy,
    mi_exec, mi_data, mi_addr, mi_write, mi_resp, mi_req_completed);

endmodule

module memory_interface #(parameter imm_width = 17) (
    input [31:0] sr1_data, input [31:0] sr2_data, //from regfile
    input can_read, input can_write, input read_enable, input write_enable, input active,//from scoreboard
    input reg [4:0] decode_wreg, input reg [4:0] decode_rreg1, input reg [4:0] decode_rreg2, //from decoder
    input reg [3:0] FU_param, input reg immsub, input reg [21:0] imm, //from decoder (part 2)
    input run, input flush, input clk, //from cpu main
    output [31:0] dr_data, output [4:0] dr, output [4:0] sr1, output [4:0] sr2, //to rf
    output reg [1:0] phase, output reg busy, //to scoreboard/decode file
    output mi_exec, output [31:0] mi_data, output [31:0] mi_addr, output mi_write, input [31:0] mi_resp, input mi_req_completed); //very important it gets a little difference here you interface with functional unit here
    
    assign dr = decode_wreg;
    assign sr1 = decode_rreg1;
    assign sr2 = decode_rreg2;
    
    reg execution_done;
    reg [31:0] response_store;
    assign dr_data = response_store;

    wire [3:0] operation = FU_param;
    wire execute = (phase == 2'b10) && (~execution_done);
    wire [imm_width-1:0] imm_field = imm[imm_width-1:0];
    reg [31:0] op1;
    reg [31:0] op2;

    always @(posedge clk) begin
        if (can_read && (phase==2'b00)) begin
            phase <= 2'b01; //read permitted, so await read
            busy <= 1;
        end else if (read_enable && (~execution_done)) begin
            phase <= 2'b10; //read enabled, so execute
            if (phase != 2'b10) begin
                op1 <= sr1_data;
                op2 <= sr2_data;
            end
        end else if ((mi_req_completed || execution_done) && (phase==2'b10)) begin
            response_store <= execution_done? response_store : mi_resp;
            execution_done <= 1;
            if (can_write) begin
                phase <= 2'b11;
            end
        end else if (write_enable) begin
            phase <= 2'b00; //write enabled, so write
            busy <= 0; //we're done
            execution_done <= 0;
            response_store <= 0;
        end
    end
    always @(posedge flush) begin //MAKE SURE TO FLUSH FROM DISPATCHER
        phase <= 0;
        busy <= 0;
        op1 <= 0;
        op2 <= 0;
        execution_done <= 0;
        response_store <= 0;
    end
    initial begin
        phase <= 0;
        busy <= 0;
        op1 <= 0;
        op2 <= 0;
        execution_done <= 0;
        response_store <= 0;
    end

    wire [31:0] base_addr = operation[0]? op2 : op1;
    
    assign mi_exec = execute;
    assign mi_addr = base_addr + imm_field[16:0];
    assign mi_data = op1;
    assign mi_write = operation[0];

endmodule

/*module top_module_memory_interface ();
    reg clk=0;
	always #5 clk = ~clk;

    reg [31:0] op1;
    reg [31:0] op2;
    reg [21:0] imm;
    reg [3:0] FU_type;
    reg [3:0] FU_param;
    reg FU_run;
    reg FU_reset;
    reg [31:0] i_addr;
    reg choose_i;
    wire d_req;
    wire [31:0] d_addr;
    wire [31:0] cpu_data;
    wire [31:0] cpu_addr;
    wire cpu_write;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module);

        op1 <= 0; op2 <= 0; imm <= 0; FU_type <= 0; FU_param <= 0; FU_run <= 0; FU_reset <= 0; i_addr <= 0; choose_i <= 0; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: ", FU_type, "; FU_param: ", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        "; i_addr: %0d", i_addr, "; choose_i: ", choose_i, 
        " ||| d_req: ", d_req, "; d_addr: %0d", d_addr, "; cpu_data: %0d", cpu_data, "; cpu_addr: %0d", cpu_addr, "; cpu_write: ", cpu_write);


        $display("TARGET/RUN/STORE TEST"); //target FU test
        FU_param[0] <= 1; FU_run <= 1; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: ", FU_type, "; FU_param: ", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        "; i_addr: %0d", i_addr, "; choose_i: ", choose_i, 
        " ||| d_req: ", d_req, "; d_addr: %0d", d_addr, "; cpu_data: %0d", cpu_data, "; cpu_addr: %0d", cpu_addr, "; cpu_write: ", cpu_write);

        FU_type <= 9; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: ", FU_type, "; FU_param: ", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        "; i_addr: %0d", i_addr, "; choose_i: ", choose_i, 
        " ||| d_req: ", d_req, "; d_addr: %0d", d_addr, "; cpu_data: %0d", cpu_data, "; cpu_addr: %0d", cpu_addr, "; cpu_write: ", cpu_write);

        FU_param[0] <= 0; #10
       $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: ", FU_type, "; FU_param: ", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        "; i_addr: %0d", i_addr, "; choose_i: ", choose_i, 
        " ||| d_req: ", d_req, "; d_addr: %0d", d_addr, "; cpu_data: %0d", cpu_data, "; cpu_addr: %0d", cpu_addr, "; cpu_write: ", cpu_write);

        FU_run <= 0; FU_param[0] <= 1; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: ", FU_type, "; FU_param: ", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        "; i_addr: %0d", i_addr, "; choose_i: ", choose_i, 
        " ||| d_req: ", d_req, "; d_addr: %0d", d_addr, "; cpu_data: %0d", cpu_data, "; cpu_addr: %0d", cpu_addr, "; cpu_write: ", cpu_write);

        //store: op1 src, op2 addr
        //load: op1 addr
        $display("ADDR COMPUTATION TEST"); //address computation test
        FU_run <= 1; op1 <= 1; op2 <= 2; imm <= 5; i_addr <= 3; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: ", FU_type, "; FU_param: ", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        "; i_addr: %0d", i_addr, "; choose_i: ", choose_i, 
        " ||| d_req: ", d_req, "; d_addr: %0d", d_addr, "; cpu_data: %0d", cpu_data, "; cpu_addr: %0d", cpu_addr, "; cpu_write: ", cpu_write);

        FU_param[0] <= 0; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: ", FU_type, "; FU_param: ", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        "; i_addr: %0d", i_addr, "; choose_i: ", choose_i, 
        " ||| d_req: ", d_req, "; d_addr: %0d", d_addr, "; cpu_data: %0d", cpu_data, "; cpu_addr: %0d", cpu_addr, "; cpu_write: ", cpu_write);

        choose_i <= 1; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: ", FU_type, "; FU_param: ", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        "; i_addr: %0d", i_addr, "; choose_i: ", choose_i, 
        " ||| d_req: ", d_req, "; d_addr: %0d", d_addr, "; cpu_data: %0d", cpu_data, "; cpu_addr: %0d", cpu_addr, "; cpu_write: ", cpu_write);

        FU_param[0] <= 1; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: ", FU_type, "; FU_param: ", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        "; i_addr: %0d", i_addr, "; choose_i: ", choose_i, 
        " ||| d_req: ", d_req, "; d_addr: %0d", d_addr, "; cpu_data: %0d", cpu_data, "; cpu_addr: %0d", cpu_addr, "; cpu_write: ", cpu_write);

        $finish;
    end
    
    memory_interface test_mi (op1, op2, imm, FU_type, FU_param, FU_run, FU_reset, i_addr, choose_i, ,d_req, d_addr, cpu_data, cpu_addr, cpu_write,);

endmodule*/