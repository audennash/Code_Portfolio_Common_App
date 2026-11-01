module top_module_cpu1_other_ops ();
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

    wire [31:0] mem_out;
    wire [31:0] cpu_data;
    wire [31:0] cpu_addr;
    wire cpu_write;

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
            man_addr <= i; man_data[26:22] <= i+1; man_data[21:0] <= 100+(i+1); #10;
        end

        man_data[31:27] <= 18; //store
        for (int i=0; i<31; i=i+1) begin
            man_addr <= man_addr+1; man_data[26:22] <= i+1; man_data[21:17] <= i+1; man_data[16:0] <= 100; #10;
        end

        man_data[31:27] <= 17; //load swapped
        for (int i=0; i<31; i=i+1) begin
            man_addr <= man_addr+1; man_data[26:22] <= i+1; man_data[21:17] <= i+1; man_data[16:0] <= ((200+31)-i)-(100+(i+1)); #10;
        end

        man_data[31:27] <= 18; //show output with store
        for (int i=0; i<31; i=i+1) begin
            man_addr <= man_addr+1; man_data[26:22] <= i+1; man_data[21:17] <= 0; man_data[16:0] <= 255; #10;
            man_addr <= man_addr+1; man_data [26:22] <= 31; man_data [21:17] <= 0; man_data [16:0] <= 254; #10; //1 portB
            man_addr <= man_addr+1; man_data [26:22] <= 0; man_data [21:17] <= 0; man_data [16:0] <= 254; #10; //0 portB
        end

        man_addr <= man_addr+1; man_data[31:27] <= 16; man_data[26:22] <= 1; man_data[21:0] = 0; #10; //test branching, reg0=0, reg1=0 (to be notted)
        man_addr <= man_addr+1; man_data[26:22] <= 2; man_data[21:0] = 5; #10; //reg2=5
        man_addr <= man_addr+1; man_data[31:27] <= 7; man_data[26:22] <= 1; man_data[21:17] <= 1; man_data[16:0] <= 0; #10; //not r1
        man_addr <= man_addr+1; man_data[31:27] <= 16; man_data[26:22] <= 3; man_data[21:0] = 14; #10; //reg3=14
        man_addr <= man_addr+1; man_data[31:27] <= 21; man_data[26:22] <= 1; man_data[21:17] = 0; man_data[21:0] = man_addr+5; #10; //branch if reg1=0
        man_addr <= man_addr+1; man_data[31:27] <= 19; man_data[26:22] = 3; man_data[21:0] = man_addr+3-14; #10; //jump past next inst
        man_addr <= man_addr+1; man_data[31:27] <= 16; man_data [26:22] <= 2; man_data[21:0] = 69; #10; //reg2=69;
        man_addr <= man_addr+1; man_data[31:27] <= 8; man_data [26:22] <= 2; man_data[21:17] <= 0; man_data[16:12] <= 2; man_data[11] <= 0; man_data[10] <= 1; man_data[9:0] <= 1; #10; //reg2=reg2+1
        man_addr <= man_addr+1; man_data[31:27] <= 20; man_data[26:22] <= 1; man_data[21:17] = 3; man_data[16:0] = man_addr-6 +1 -14; #10; //branch if reg1 is 1
        man_addr <= man_addr+1; man_data[31:27] <= 18; man_data[26:22] <= 2; man_data[21:17] <= 0; man_data[16:0] <= 255; #10; //display reg2
        man_addr <= man_addr+1; man_data [26:22] <= 31; man_data [21:17] <= 0; man_data [16:0] <= 254; #10; //1 portB
        man_addr <= man_addr+1; man_data[31:27] <= 0; #10; //nop?
        man_addr <= man_addr+1; man_data[31:27] <= 18; man_data [26:22] <= 0; man_data [21:17] <= 0; man_data [16:0] <= 254; #10; //0 portB
        man_addr <= man_addr+1; man_data[31:27] <= 23; #10; //undefined


        man_addr <= man_addr+1; man_data[31:27] <= 1; #10; //halt
        manual <= 0; cpu_run <= 1;
        $display("RUNNING");
        #6000;
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


    cpu test_cpu (cpu_run, flush, clk, mem_out, cpu_data, cpu_addr, cpu_write, halted);
    memory #(256) test_mem (cpu_data, cpu_addr, cpu_write, manual, man_data, man_addr, man_write, clk, flush,,, mem_out, portA, portB);

endmodule

    

    