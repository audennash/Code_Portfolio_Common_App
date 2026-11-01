module top_module_cpu2_standard_ops ();
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
        $display("BEGINNING");
        cpu_run <= 0; flush <= 0; manual <= 0; man_data <= 0; man_addr <=0; man_write <= 0; #10;
        $display("run: ", cpu_run, "; flush: ", flush, " | manual: ", manual, "; man_data: %0d", man_data, "; man_addr: %0d", man_addr, "; man_write: ", man_write
        , " ||| portA: %0d", portA, "; portB: %0d", portB, "; halted: ", halted);

        $display("MEMORY SETUP");
        manual <= 1; man_write <= 1; 
        man_data[31:27] <= 16; //loadimm instructions
        man_addr <= 0; man_data[26:22] <= 1; man_data[21:0] <= 5; let_mem();
        man_addr <= 1; man_data[26:22] <= 2; man_data[21:0] <= 9; let_mem();
        man_addr <= 2; man_data [26:22] <= 4; man_data[21:0] <= 1; let_mem();
        //op and store
        for (int i=2; i<16; i=i+1) begin
            man_addr <= man_addr + 1; man_data[31:27] <= i; man_data [26:22] <= 3; man_data [21:17] <= 1; man_data [16:12] <= 2; man_data[11:0] <= 0; let_mem();
            man_addr <= man_addr + 1; man_data[31:27] <= 18; man_data [26:22] <= 3; man_data [21:17] <= 0; man_data [16:0] <= 255; let_mem(); //store portA
            man_addr <= man_addr + 1; man_data[31:27] <= 18; man_data [26:22] <= 4; man_data [21:17] <= 0; man_data [16:0] <= 254; let_mem(); //1 portB
            man_addr <= man_addr + 1; man_data[31:27] <= 18; man_data [26:22] <= 0; man_data [21:17] <= 0; man_data [16:0] <= 254; let_mem(); //0 portB
        end
        $display("SWAPOUT TEST");
        for (int i=2; i<16; i=i+1) begin
            man_addr <= man_addr + 1; man_data[31:27] <= i; man_data [26:22] <= 3; man_data [21:17] <= 1; man_data [16:12] <= 2; man_data[11:10] <= 2'b01; man_data[9:0] <= 12; let_mem();
            man_addr <= man_addr + 1; man_data[31:27] <= 18; man_data [26:22] <= 3; man_data [21:17] <= 0; man_data [16:0] <= 255; let_mem(); //store portA
            man_addr <= man_addr + 1; man_data[31:27] <= 18; man_data [26:22] <= 4; man_data [21:17] <= 0; man_data [16:0] <= 254; let_mem(); //1 portB
            man_addr <= man_addr + 1; man_data[31:27] <= 18; man_data [26:22] <= 0; man_data [21:17] <= 0; man_data [16:0] <= 254; let_mem(); //0 portB
        end
        $display("BEGIN SIGNEDENABLED TIME");
        man_addr <= man_addr+1; man_data[31:27] <= 13; man_data[26:22] <= 1; man_data [21:17] <= 1; let_mem();
        man_addr <= man_addr+1; man_data[31:27] <= 13; man_data[26:22] <= 2; man_data [21:17] <= 2; let_mem();
        for (int i=2; i<16; i=i+1) begin
            man_addr <= man_addr + 1; man_data[31:27] <= i; man_data [26:22] <= 3; man_data [21:17] <= 1; man_data [16:12] <= 2; man_data[11] <= 1; man_data[10:0] <= 0; let_mem();
            man_addr <= man_addr + 1; man_data[31:27] <= 18; man_data [26:22] <= 3; man_data [21:17] <= 0; man_data [16:0] <= 255; let_mem(); //store portA
            man_addr <= man_addr + 1; man_data[31:27] <= 18; man_data [26:22] <= 4; man_data [21:17] <= 0; man_data [16:0] <= 254; let_mem(); //1 portB
            man_addr <= man_addr + 1; man_data[31:27] <= 18; man_data [26:22] <= 0; man_data [21:17] <= 0; man_data [16:0] <= 254; let_mem(); //0 portB
        end
        $display("QUICK SHIFT TEST", man_addr);
        man_addr <= man_addr+11; man_data[31:27] <= 16; man_data[26:22] <= 2; man_data[21:0] <= 1; let_mem();
        for (int i=14; i<16; i=i+1) begin
            man_addr <= man_addr + 1; man_data[31:27] <= i; man_data [26:22] <= 3; man_data [21:17] <= 1; man_data [16:12] <= 2; man_data[11] <= 1; man_data[10:0] <= 0; let_mem();
            man_addr <= man_addr + 1; man_data[31:27] <= 18; man_data [26:22] <= 3; man_data [21:17] <= 0; man_data [16:0] <= 255; let_mem(); //store portA
            man_addr <= man_addr + 1; man_data[31:27] <= 18; man_data [26:22] <= 4; man_data [21:17] <= 0; man_data [16:0] <= 254; let_mem(); //1 portB
            man_addr <= man_addr + 1; man_data[31:27] <= 18; man_data [26:22] <= 0; man_data [21:17] <= 0; man_data [16:0] <= 254; let_mem(); //a0 portB
        end
        for (int i=14; i<16; i=i+1) begin
            man_addr <= man_addr + 1; man_data[31:27] <= i; man_data [26:22] <= 3; man_data [21:17] <= 1; man_data [16:12] <= 2; man_data[11] <= 0; man_data[10:0] <= 0; let_mem();
            man_addr <= man_addr + 1; man_data[31:27] <= 18; man_data [26:22] <= 3; man_data [21:17] <= 0; man_data [16:0] <= 255; let_mem(); //store portA
            man_addr <= man_addr + 1; man_data[31:27] <= 18; man_data [26:22] <= 4; man_data [21:17] <= 0; man_data [16:0] <= 254; let_mem(); //1 portB
            man_addr <= man_addr + 1; man_data[31:27] <= 18; man_data [26:22] <= 0; man_data [21:17] <= 0; man_data [16:0] <= 254; let_mem(); //a0 portB
        end

    
        man_addr <= man_addr+1; man_data[31:27] <= 1; let_mem(); //halt instruction
        cpu_run <= 0; flush <= 0; manual <= 0; man_data <= 0; man_addr <=0; man_write <= 0; #10;
        $display("RUNTIME");
        $display("run: ", cpu_run, "; flush: ", flush, " | manual: ", manual, "; man_data: %0d", man_data, "; man_addr: %0d", man_addr, "; man_write: ", man_write
        , " ||| portA: %0d", portA, "; portB: %0d", portB, "; halted: ", halted);
        manual <= 0; cpu_run <= 1; #1000000;
        $display("DONE");
        $display("run: ", cpu_run, "; flush: ", flush, " | manual: ", manual, "; man_data: %0d", man_data, "; man_addr: %0d", man_addr, "; man_write: ", man_write
        , " ||| portA: %0d", portA, "; portB: %0d", portB, "; halted: ", halted);
        //$display("result time");
        //$display("run: ", cpu_run, "; flush: ", flush, " | manual: ", manual, "; man_data: %0d", man_data, "; man_addr: %0d", man_addr, "; man_write: ", man_write
        //, " ||| portA: %0d", portA, "; portB: %0d", portB, "; halted: ", halted);

        $finish;
    end

    task automatic let_mem();
        wait (mem_done == 0); wait (mem_done == 1);
    endtask

    always @(posedge portB[0]) begin
        if (op_number<14) begin
            $display("time: ", $time, "; portA: ", portA, "; op: ", 2+(op_number%14));
            $display("in1: %b", 5, "; in2: %b", 9, " ||| portA: %b", portA);
        end else if (op_number<28) begin
            $display("time: ", $time, "; portA: ", portA, "; op: ", 2+(op_number%14));
            $display("in1: %b", 12, "; in2: %b", 9, " ||| portA: %b", portA);
        end else if (op_number < 42) begin
            $display("time: ", $time, "; portA: ", $signed(portA), "; op: ", 2+(op_number%14));
            $display("in1: %b", -5, "; in2: %b", -9, " ||| portA: %b", portA);
        end else begin
            $display("time: ", $time, "; portA: ", $signed(portA), "; op: ", 2+(op_number%14));
            $display("in1: %b", -5, "; in2: %b", 1, " ||| portA: %b", portA);
        end
        op_number <= op_number+1;
    end


    cpu test_cpu (cpu_run, flush, clk, mem_out, mem_done, cpu_data, cpu_addr, cpu_write, cpu_req, halted);
    memory #(256) test_mem (cpu_data, cpu_addr, cpu_write, cpu_req, manual, man_data, man_addr, man_write, clk, flush, portC, portD, mem_out, mem_done, portA, portB);

endmodule

    

    