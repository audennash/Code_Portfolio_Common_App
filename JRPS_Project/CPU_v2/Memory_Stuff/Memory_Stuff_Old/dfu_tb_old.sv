module top_module_dfu_tb_old();
    reg clk = 0;
    always #5 clk = ~clk;

    reg mi_exec;
    reg [31:0] mi_data;
    reg [31:0] mi_addr;
    reg mi_write;
    reg [31:0] mem_out;
    wire mem_done;
    reg choose_i;
    reg run;
    reg flush;
    wire [31:0] mi_resp;
    wire req_completed;
    wire d_req;
    wire [31:0] d_data;
    wire [31:0] d_addr;
    wire d_write;

    reg [31:0] i_addr;
    reg [31:0] memory_chip [255:0];
    wire [31:0] cpu_data = d_data;
    wire [31:0] cpu_addr = choose_i? i_addr : d_addr;
    wire cpu_write = choose_i? 0 : d_write;
    wire mem_req = choose_i || d_req;
    
    reg [31:0] print_count = 0;
    //Notes:
    //get a cleaner way to track prints (time check probably)
    //figure out why req_completed is not resetting
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module);

        for (int i=0; i<32; i=i+1) begin
            memory_chip[i] <= i+10; #10;
        end

        mi_exec <= 0; mi_data <= 0; mi_addr <= 0; mi_write <= 0; 
        choose_i <= 0;
        run <= 0; flush <= 0; clk <= 0;
        #10; $display($time, " PRINTCOUNT: ", print_count, "", //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; choose_i: ", choose_i,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; req_completed: ", req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        print_count <= print_count + 1; 

        mi_exec <= 1; mi_addr <= 3;
        #10; $display($time, " PRINTCOUNT: ", print_count, //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; choose_i: ", choose_i,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; req_completed: ", req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        print_count <= print_count + 1; 

        #200;
        #10; $display($time, " PRINTCOUNT: ", print_count, //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; choose_i: ", choose_i,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; req_completed: ", req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        print_count <= print_count + 1; 

        mi_addr <= 18; //try to look at 18 here
        #10; 
        $display($time, " PRINTCOUNT: ", print_count, //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; choose_i: ", choose_i,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; req_completed: ", req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        print_count <= print_count + 1; 

        #100; $display($time, " PRINTCOUNT: ", print_count, //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; choose_i: ", choose_i,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; req_completed: ", req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        print_count <= print_count + 1; 

        #200; $display($time, " PRINTCOUNT: ", print_count, //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; choose_i: ", choose_i,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; req_completed: ", req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        print_count <= print_count + 1; 

        mi_addr <= 3;
        #40; $display($time, " PRINTCOUNT: ", print_count, //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; choose_i: ", choose_i,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; req_completed: ", req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        print_count <= print_count + 1; 
        

        $display("ICACHE CONFLICT TEST");
        mi_addr <= 4; choose_i <= 1; i_addr <= 19;
        #10; $display($time, " PRINTCOUNT: ", print_count, //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; choose_i: ", choose_i,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; req_completed: ", req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        print_count <= print_count + 1; 

        #200;
        $display($time, " PRINTCOUNT: ", print_count, //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; choose_i: ", choose_i,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; req_completed: ", req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        print_count <= print_count + 1; 

        choose_i <= 0; 
        #10; $display($time, " PRINTCOUNT: ", print_count, //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; choose_i: ", choose_i,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; req_completed: ", req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        $display(test_dfu.hit); print_count <= print_count + 1; 

        #200; 
        #10; $display($time, " PRINTCOUNT: ", print_count, //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; choose_i: ", choose_i,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; req_completed: ", req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        $display(test_dfu.hit); print_count <= print_count + 1; 

        mi_addr <= 19; 
        #10; $display($time, " PRINTCOUNT: ", print_count, //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; choose_i: ", choose_i,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; req_completed: ", req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        $display(test_dfu.hit); print_count <= print_count + 1; 

        #200; 
        #10; $display($time, " PRINTCOUNT: ", print_count, //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; choose_i: ", choose_i,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; req_completed: ", req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        $display(test_dfu.hit); print_count <= print_count + 1;

        mi_addr <= 4;
        #10; $display($time, " PRINTCOUNT: ", print_count, //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; choose_i: ", choose_i,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; req_completed: ", req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        $display(test_dfu.hit); print_count <= print_count + 1;

        mi_addr <= 19;
        #10; $display($time, " PRINTCOUNT: ", print_count, //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; choose_i: ", choose_i,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; req_completed: ", req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        $display(test_dfu.hit); print_count <= print_count + 1;

        mi_addr <= 20;
        #10; $display($time, " PRINTCOUNT: ", print_count, //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; choose_i: ", choose_i,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; req_completed: ", req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        $display(test_dfu.hit); print_count <= print_count + 1;

        $display("WRITING TEST");
        mi_write <= 1; mi_data <= 67;
        #10; $display($time, " PRINTCOUNT: ", print_count, //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; choose_i: ", choose_i,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; req_completed: ", req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        $display(test_dfu.hit); print_count <= print_count + 1;

        mi_write <= 0;
        #10; $display($time, " PRINTCOUNT: ", print_count, //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; choose_i: ", choose_i,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; req_completed: ", req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        $display(test_dfu.hit); print_count <= print_count + 1;

        mi_write <= 1;

        for (int i=0; i<4; i=i+1) begin
            mi_addr <= mi_addr + 32;
            #10;
        end

        $display("DID EVICT WORK?");
        $display($time, " PRINTCOUNT: ", print_count, //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; choose_i: ", choose_i,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; req_completed: ", req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        $display(test_dfu.dirty_evict); print_count <= print_count + 1;

        #200; $display($time, " PRINTCOUNT: ", print_count, //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; choose_i: ", choose_i,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; req_completed: ", req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        $display(test_dfu.dirty_evict); print_count <= print_count + 1;

        mi_write <= 0; mi_addr <= 20;
        #10; $display($time, " PRINTCOUNT: ", print_count, //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; choose_i: ", choose_i,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; req_completed: ", req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        $display(test_dfu.dirty_evict); print_count <= print_count + 1;

        #200;
        $display($time, " PRINTCOUNT: ", print_count, //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; choose_i: ", choose_i,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; req_completed: ", req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        $display("auxiliary test: ", "de: ", test_dfu.dirty_evict, " memreq: ", mem_req, " cpu_addr: ", cpu_addr); 
        print_count <= print_count + 1;



        $finish;
    end

    dfu_old #(32, 2**32, 128) test_dfu (mi_exec, mi_data, mi_addr, mi_write, mem_out, mem_done, choose_i, run, flush, clk, mi_resp, req_completed, d_req, d_data, d_addr, d_write);

    reg mem_done_temp;
    reg [31:0] mem_oldaddr_temp;
    reg mem_done_reset;
    assign mem_done = (~mem_done_reset) && (mem_oldaddr_temp==cpu_addr) && mem_done_temp;
    always @(posedge clk) begin
        if (mem_req) begin //remember mem_done only asserted for one cycle
            mem_done_reset <= mem_done;
            if (cpu_write) begin
                memory_chip[cpu_addr] <= #200 cpu_data;
            end
            mem_out <= #200 memory_chip[cpu_addr];
            mem_done_temp <= #200 1; 
            mem_oldaddr_temp <= #200 cpu_addr;
        end else begin
            mem_done_temp <= #200 0;
        end
    end
    always @(posedge flush) begin
        for (int i=0; i<256; i=i+1) begin
            memory_chip[i] <= 0;
        end
        mi_exec <= 0;
    end
    initial begin
        mem_done_temp <= 0;
        mem_done_reset <= 0;
    end

/*task mem_delay (input logic [31:0] cpu_addr_temp, input logic [31:0] cpu_data_temp, input logic cpu_write_temp);
    $display($time, "inside the fork: ", cpu_addr_temp, cpu_data_temp, cpu_write_temp);
    #200;
    //$display($time, " updating mem_out at address", cpu_addr);
    if (cpu_write_temp) begin
        memory_chip[cpu_addr_temp] <= cpu_data_temp;
    end
    if (cpu_addr_temp==cpu_addr) begin //remjember this will cause an invalid value to be returned on writes so be careful!!!!!
        mem_out <= memory_chip[cpu_addr_temp]; mem_done <= 1;
    end
    $display($time, "leaving the fork: ", cpu_addr_temp, cpu_data_temp, cpu_write_temp);
endtask*/
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