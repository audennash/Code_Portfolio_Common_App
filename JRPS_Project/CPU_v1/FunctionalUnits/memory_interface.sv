module top_module_memory_interface ();
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

endmodule

module memory_interface (
    input [31:0] op1,
    input [31:0] op2,
    input [21:0] imm,
    input [3:0] FU_type,
    input [3:0] FU_param,
    input FU_run,
    input FU_reset,
    input [31:0] i_addr,
    input choose_i,
    input [31:0] mem_out,
    output d_req,
    output [31:0] d_addr,
    output [31:0] cpu_data,
    output [31:0] cpu_addr,
    output cpu_write,
    output [31:0] mem_wb);

    wire [31:0] base_addr = FU_param[0]? op2 : op1;
    
    wire write_if_FU = FU_param[0] & FU_run;
    wire am_i_FU = (FU_type == 9);

    assign d_req = (FU_type == 9);
    assign d_addr = base_addr + imm[16:0];

    assign cpu_data = op1;
    assign cpu_addr = choose_i? i_addr : d_addr;
    assign cpu_write = write_if_FU && d_req;

    assign mem_wb = mem_out & {(32){d_req}};
    
endmodule