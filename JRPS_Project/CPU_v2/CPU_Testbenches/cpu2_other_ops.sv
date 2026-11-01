module top_module_cpu2_other_ops ();
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

        man_data[31:27] <= 16; //loadimm
        for (int i=0; i<31; i=i+1) begin
            man_addr <= i; man_data[26:22] <= i+1; man_data[21:0] <= 100+(i+1); let_mem();
        end

        man_data[31:27] <= 18; //store
        for (int i=0; i<31; i=i+1) begin
            man_addr <= man_addr+1; man_data[26:22] <= i+1; man_data[21:17] <= i+1; man_data[16:0] <= 100; let_mem();
        end

        man_data[31:27] <= 17; //load swapped
        for (int i=0; i<31; i=i+1) begin
            man_addr <= man_addr+1; man_data[26:22] <= i+1; man_data[21:17] <= i+1; man_data[16:0] <= ((200+31)-i)-(100+(i+1)); let_mem();
        end

        man_data[31:27] <= 18; //show output with store
        for (int i=0; i<31; i=i+1) begin
            man_addr <= man_addr+1; man_data[26:22] <= i+1; man_data[21:17] <= 0; man_data[16:0] <= 255; let_mem();
            man_addr <= man_addr+1; man_data [26:22] <= 31; man_data [21:17] <= 0; man_data [16:0] <= 254; let_mem(); //1 portB
            man_addr <= man_addr+1; man_data [26:22] <= 0; man_data [21:17] <= 0; man_data [16:0] <= 254; let_mem(); //0 portB
        end

        $display("address before branch code: ", man_addr);
        man_addr <= man_addr+1; man_data[31:27] <= 16; man_data[26:22] <= 1; man_data[21:0] = 0; let_mem(); //test branching, reg0=0, reg1=0 (to be notted) 186
        man_addr <= man_addr+1; man_data[26:22] <= 2; man_data[21:0] = 5; let_mem(); //reg2=5   187
        man_addr <= man_addr+1; man_data[31:27] <= 7; man_data[26:22] <= 1; man_data[21:17] <= 1; man_data[16:0] <= 0; let_mem(); //not r1  188
        man_addr <= man_addr+1; man_data[31:27] <= 16; man_data[26:22] <= 3; man_data[21:0] = 14; let_mem(); //reg3=14  189
        man_addr <= man_addr+1; man_data[31:27] <= 21; man_data[26:22] <= 1; man_data[21:17] = 0; man_data[21:0] = man_addr+5; let_mem(); //branch if reg1=0    190 BRANCH
        man_addr <= man_addr+1; man_data[31:27] <= 19; man_data[26:22] = 3; man_data[21:0] = man_addr+3-14; let_mem(); //jump past next inst    191 BRANCH
        man_addr <= man_addr+1; man_data[31:27] <= 16; man_data [26:22] <= 2; man_data[21:0] = 69; let_mem(); //reg2=69;    192
        man_addr <= man_addr+1; man_data[31:27] <= 8; man_data [26:22] <= 2; man_data[21:17] <= 0; man_data[16:12] <= 2; man_data[11] <= 0; man_data[10] <= 1; man_data[9:0] <= 1; let_mem(); //reg2=reg2+1 193
        man_addr <= man_addr+1; man_data[31:27] <= 20; man_data[26:22] <= 1; man_data[21:17] = 3; man_data[16:0] = man_addr-6 +1 -14; let_mem(); //branch if reg1 is 1  194 BRANCH
        man_addr <= man_addr+1; man_data[31:27] <= 18; man_data[26:22] <= 2; man_data[21:17] <= 0; man_data[16:0] <= 255; let_mem(); //display reg2 195
        man_addr <= man_addr+1; man_data [26:22] <= 31; man_data [21:17] <= 0; man_data [16:0] <= 254; let_mem(); //1 portB 196
        man_addr <= man_addr+1; man_data[31:27] <= 0; let_mem(); //nop? 197
        man_addr <= man_addr+1; man_data[31:27] <= 18; man_data [26:22] <= 0; man_data [21:17] <= 0; man_data [16:0] <= 254; let_mem(); //0 portB   198
        man_addr <= man_addr+1; man_data[31:27] <= 23; let_mem(); //undefined   199


        man_addr <= man_addr+1; man_data[31:27] <= 1; let_mem(); //halt 200
        manual <= 0; cpu_run <= 1;
        $display("RUNNING");
        #100000;
        $display("DONE");
        $display("run: ", cpu_run, "; flush: ", flush, " | manual: ", manual, "; man_data: %0d", man_data, "; man_addr: %0d", man_addr, "; man_write: ", man_write
        , " ||| portA: %0d", portA, "; portB: %0d", portB, "; halted: ", halted);
        //$display("result time");
        //$display("run: ", cpu_run, "; flush: ", flush, " | manual: ", manual, "; man_data: %0d", man_data, "; man_addr: %0d", man_addr, "; man_write: ", man_write
        //, " ||| portA: %0d", portA, "; portB: %0d", portB, "; halted: ", halted);

        $finish;
    end

    always @(posedge portB[0]) begin
        $display("portA: ", portA, "; time: ", $time);
    end

    task automatic let_mem();
        wait (mem_done == 0); wait (mem_done == 1);
    endtask

    cpu test_cpu (cpu_run, flush, clk, mem_out, mem_done, cpu_data, cpu_addr, cpu_write, cpu_req, halted);
    memory #(256) test_mem (cpu_data, cpu_addr, cpu_write, cpu_req, manual, man_data, man_addr, man_write, clk, flush, portC, portD, mem_out, mem_done, portA, portB);

endmodule

    

    