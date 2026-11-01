module top_module_cpu2_io ();
    //to check: nops/undefineds, halts, lis, loads/stores, control
    reg clk=0;
	always #5 clk = ~clk;

    reg cpu_run; 
    reg flush;
    wire halted;

    reg manual;
    reg [31:0] man_data;
    reg [31:0] man_addr;
    reg man_write;
    wire [31:0] portA;
    wire [31:0] portB;
    reg [31:0] portC = 0;
    reg [31:0] portD = 0;   

    wire [31:0] mem_out;
    wire mem_done;
    wire [31:0] cpu_data;
    wire [31:0] cpu_addr;
    wire cpu_write;
    wire cpu_req;

    reg [8:0] op_number = 0;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module);
        $display("INITIAL");
        $display("run: ", cpu_run, "; flush: ", flush, " | manual: ", manual, "; man_data: %0d", man_data, "; man_addr: %0d", man_addr, "; man_write: ", man_write
        , " ||| portA: %0d", portA, "; portB: %0d", portB, "; halted: ", halted);
        manual <= 1; man_write <= 1; #10;

        man_addr <= 0; man_data[31:27] <= 17; man_data[26:22] = 1; man_data[21:17] = 0; man_data[16:0] = 253; let_mem();
        man_addr <= 1; man_data[31:27] <= 17; man_data[26:22] = 2; man_data[21:17] = 0; man_data[16:0] = 252; let_mem();
        man_addr <= 2; man_data[31:27] <= 18; man_data[26:22] = 1; man_data[21:17] = 0; man_data[16:0] = 255; let_mem();
        man_addr <= 3; man_data[31:27] <= 18; man_data[26:22] = 2; man_data[21:17] = 0; man_data[16:0] = 254; let_mem();
        

        man_addr <= man_addr+1; man_data[31:27] <= 1; let_mem(); //halt
        portC <= 69;
        portD <= 420;
        manual <= 0; cpu_run <= 1;
        $display("RUNNING");
        #10000;
        $display("portA: ", portA, "; portB: ", portB);
        //$display("result time");
        //$display("run: ", cpu_run, "; flush: ", flush, " | manual: ", manual, "; man_data: %0d", man_data, "; man_addr: %0d", man_addr, "; man_write: ", man_write
        //, " ||| portA: %0d", portA, "; portB: %0d", portB, "; halted: ", halted);

        $finish;
    end

    task automatic let_mem();
        wait (mem_done == 0); wait (mem_done == 1);
    endtask

    cpu test_cpu (cpu_run, flush, clk, mem_out, mem_done, cpu_data, cpu_addr, cpu_write, cpu_req, halted);
    memory #(256) test_mem (cpu_data, cpu_addr, cpu_write, cpu_req, manual, man_data, man_addr, man_write, clk, flush, portC, portD, mem_out, mem_done, portA, portB);

endmodule

    

    