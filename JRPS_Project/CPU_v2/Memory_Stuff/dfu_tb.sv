module top_module_dfu_tb ();
    reg clk = 0;
    always #5 clk = ~clk;

    reg mi_exec;
    reg [31:0] mi_data;
    reg [31:0] mi_addr;
    reg mi_write;
    reg i_req;
    reg [31:0] i_addr;
    reg run;
    reg flush;

    wire [31:0] data_out;
    wire req_completed;
    wire d_req;
    wire [31:0] d_data;
    wire [31:0] d_addr;
    wire d_write;
    wire [31:0] mi_resp;
    wire mi_req_completed;
    
    wire [31:0] mem_out;
    wire mem_done;
    
    reg [31:0] print_count = 0;

    wire exec = mi_exec || i_req;
    wire [31:0] data_in = mi_data;
    wire [31:0] addr_in = i_req? i_addr : mi_addr;
    wire write_in = i_req? 0 : mi_write;
    assign mi_resp = data_out;
    assign mi_req_completed = i_req? 0 : req_completed;
    //Notes:
    //get a cleaner way to track prints (time check probably)
    //figure out why req_completed is not resetting
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module);

        for (int i=0; i<32; i=i+1) begin
            test_memory.memory_chip[i] <= i+10; #10;
        end

        mi_exec <= 0; mi_data <= 0; mi_addr <= 0; mi_write <= 0; 
        i_req <= 0;
        run <= 0; flush <= 0;
        #10; $display($time, " PRINTCOUNT: ", print_count, "", //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; i_req: ", i_req,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; mi_req_completed: ", mi_req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        print_count <= print_count + 1; 

        mi_exec <= 1; mi_addr <= 1; run <= 1;
        #10; $display($time, " PRINTCOUNT: ", print_count, "", //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; i_req: ", i_req,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; mi_req_completed: ", mi_req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        print_count <= print_count + 1; 

        #210; $display($time, " PRINTCOUNT: ", print_count, "", //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; i_req: ", i_req,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; mi_req_completed: ", mi_req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        print_count <= print_count + 1; 

        mi_addr <= 0;
        #220; $display($time, " PRINTCOUNT: ", print_count, "", //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; i_req: ", i_req,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; mi_req_completed: ", mi_req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        print_count <= print_count + 1; 

        mi_addr <= 1;
        #10; $display($time, " PRINTCOUNT: ", print_count, "", //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; i_req: ", i_req,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; mi_req_completed: ", mi_req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        print_count <= print_count + 1;

        mi_addr <= 2; mi_data <= 67; mi_write <= 1;
        #10; $display($time, " PRINTCOUNT: ", print_count, "", //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; i_req: ", i_req,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; mi_req_completed: ", mi_req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        print_count <= print_count + 1;

        $display("TESTING EVICTION!!");
        for (int i=0; i<4; i=i+1) begin
            mi_addr <= mi_addr + 32; mi_data <= i;
            #10;
        end
        
        mi_write <= 0;
        #10; $display($time, " PRINTCOUNT: ", print_count, "", //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; i_req: ", i_req,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; mi_req_completed: ", mi_req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        $display(test_dfu.dirty_evict, test_dfu.wb_done); print_count <= print_count + 1;

        #210; $display($time, " PRINTCOUNT: ", print_count, "", //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; i_req: ", i_req,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; mi_req_completed: ", mi_req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        $display(test_dfu.dirty_evict, test_dfu.wb_done); print_count <= print_count + 1;

        #210; $display($time, " PRINTCOUNT: ", print_count, "", //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; i_req: ", i_req,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; mi_req_completed: ", mi_req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        $display(test_dfu.dirty_evict, test_dfu.wb_done); print_count <= print_count + 1;

        mi_addr <= 34;
        #10; $display($time, " PRINTCOUNT: ", print_count, "", //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; i_req: ", i_req,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; mi_req_completed: ", mi_req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        $display(test_dfu.dirty_evict, test_dfu.wb_done); print_count <= print_count + 1;
        
        #10; 
        mi_addr <= 2;
        #210; $display($time, " PRINTCOUNT: ", print_count, "", //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; i_req: ", i_req,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; mi_req_completed: ", mi_req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        $display(test_dfu.dirty_evict, test_dfu.wb_done); print_count <= print_count + 1;

        #240; $display($time, " PRINTCOUNT: ", print_count, "", //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; i_req: ", i_req,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; mi_req_completed: ", mi_req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n");
        $display(test_dfu.dirty_evict, test_dfu.wb_done); print_count <= print_count + 1;
        
        $display("IFU INTERFACE TEST");
        i_req <= 1; i_addr <= 30;
        #10; $display($time, " PRINTCOUNT: ", print_count, "", //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; i_req: ", i_req,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; mi_req_completed: ", mi_req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n",
        "||| addr_in :", addr_in, "; req_completed: ", req_completed);
        $display(test_dfu.dirty_evict, test_dfu.wb_done); print_count <= print_count + 1;
        #200; $display($time, " PRINTCOUNT: ", print_count, "", //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; i_req: ", i_req,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; mi_req_completed: ", mi_req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n",
        "||| addr_in :", addr_in, "; req_completed: ", req_completed);
        $display(test_dfu.dirty_evict, test_dfu.wb_done); print_count <= print_count + 1;

        i_addr <= 98;
        #10; $display($time, " PRINTCOUNT: ", print_count, "", //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; i_req: ", i_req,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; mi_req_completed: ", mi_req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n",
        "||| addr_in :", addr_in, "; req_completed: ", req_completed);
        $display(test_dfu.dirty_evict, test_dfu.wb_done); print_count <= print_count + 1;

        #10; $display($time, " PRINTCOUNT: ", print_count, "", //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; i_req: ", i_req,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; mi_req_completed: ", mi_req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n",
        "||| addr_in :", addr_in, "; req_completed: ", req_completed);
        $display(test_dfu.dirty_evict, test_dfu.wb_done); print_count <= print_count + 1;

        $display("FLUSHTEST");
        i_req <= 0; mi_addr <= 98;
        #10; $display($time, " PRINTCOUNT: ", print_count, "", //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; i_req: ", i_req,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; mi_req_completed: ", mi_req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n",
        "||| addr_in :", addr_in, "; req_completed: ", req_completed);
        $display(test_dfu.dirty_evict, test_dfu.wb_done); print_count <= print_count + 1;

        flush <= 1;
        #10; $display($time, " PRINTCOUNT: ", print_count, "", //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; i_req: ", i_req,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; mi_req_completed: ", mi_req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n",
        "||| addr_in :", addr_in, "; req_completed: ", req_completed);
        $display(test_dfu.dirty_evict, test_dfu.wb_done); print_count <= print_count + 1;

        flush <= 0;
        #10; $display($time, " PRINTCOUNT: ", print_count, "", //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; i_req: ", i_req,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; mi_req_completed: ", mi_req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n",
        "||| addr_in :", addr_in, "; req_completed: ", req_completed);
        $display(test_dfu.dirty_evict, test_dfu.wb_done); print_count <= print_count + 1;

        #200; $display($time, " PRINTCOUNT: ", print_count, "", //marking this with green
        "\nIN: ", "mi_exec: ", mi_exec, "; mi_data: ", mi_data, "; mi_addr: ", mi_addr, "; mi_write: ", mi_write,
        " | mem_out: ", mem_out, "; mem_done: ", mem_done, "; i_req: ", i_req,
        " | run: ", run, "; flush: ", flush, "; clk: ", clk,
        "\nOUT: ", "mi_resp: ", mi_resp, "; mi_req_completed: ", mi_req_completed, "; d_req: ", d_req, "; d_data: ", d_data, "; d_addr: ", d_addr, "; d_write: ", d_write, "\n",
        "||| addr_in :", addr_in, "; req_completed: ", req_completed);
        $display(test_dfu.dirty_evict, test_dfu.wb_done); print_count <= print_count + 1;



        $finish;
    end

    dfu #(32, 2**32, 128) test_dfu (exec, data_in, addr_in, write_in, mem_out, mem_done, i_req, run, flush, clk, data_out, req_completed, d_req, d_data, d_addr, d_write);
    //choose_i
    memory #(256) test_memory (d_data, d_addr, d_write, d_req, 1'b0, , , , clk, flush, , , mem_out, mem_done, , );

endmodule

