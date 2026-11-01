module top_module_cpu2_run_and_reset ();
    //to check: stopping running and flushing  
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
            man_addr <= i; man_data[26:22] <= i+1; man_data[21:0] <= 100+(i+1); wait (mem_done == 0); wait (mem_done == 1);
        end
        $display("clear");
        man_data[31:27] <= 18; //store
        for (int i=0; i<31; i=i+1) begin
            man_addr <= man_addr+1; man_data[26:22] <= i+1; man_data[21:17] <= i+1; man_data[16:0] <= 100; wait (mem_done == 0); wait (mem_done == 1);
        end
        $display("clear");
        man_data[31:27] <= 17; //load swapped
        for (int i=0; i<31; i=i+1) begin
            man_addr <= man_addr+1; man_data[26:22] <= i+1; man_data[21:17] <= i+1; man_data[16:0] <= ((200+31)-i)-(100+(i+1)); wait (mem_done == 0); wait (mem_done == 1);
        end
        $display("clear");
        man_data[31:27] <= 16;
        man_addr <= man_addr+1; man_data[26:22] <= 1; man_data[21:0] <= 69; wait (mem_done == 0); wait (mem_done == 1);
        man_data[31:27] <= 18;
        man_addr <= man_addr+1; man_data[26:22] <= 1; man_data[21:17] <= 0; man_data[16:0] <= 255; wait (mem_done == 0); wait (mem_done == 1); //alert here, shlud print 69
        man_addr <= man_addr+1; man_data [26:22] <= 31; man_data [21:17] <= 0; man_data [16:0] <= 254; wait (mem_done == 0); wait (mem_done == 1); //1 portB
        man_addr <= man_addr+1; man_data[31:27] <= 0; wait (mem_done == 0); wait (mem_done == 1);
        man_data[31:27] <= 18;
        man_addr <= man_addr+1; man_data [26:22] <= 0; man_data [21:17] <= 0; man_data [16:0] <= 254; wait (mem_done == 0); wait (mem_done == 1); //0 portB
        $display("clear");
        man_data[31:27] <= 18; //show output with store
        for (int i=0; i<31; i=i+1) begin
            man_addr <= man_addr+1; man_data[26:22] <= i+1; man_data[21:17] <= 0; man_data[16:0] <= 255; wait (mem_done == 0); wait (mem_done == 1);
            man_addr <= man_addr+1; man_data [26:22] <= 31; man_data [21:17] <= 0; man_data [16:0] <= 254; wait (mem_done == 0); wait (mem_done == 1); //1 portB
            man_addr <= man_addr+1; man_data [26:22] <= 0; man_data [21:17] <= 0; man_data [16:0] <= 254; wait (mem_done == 0); wait (mem_done == 1); //0 portB
        end



        man_addr <= man_addr+1; man_data[31:27] <= 1; wait (mem_done == 0); wait (mem_done == 1); //halt
        manual <= 0; cpu_run <= 1;
        $display("RUNNING");
        //$display("result time");
        //$display("run: ", cpu_run, "; flush: ", flush, " | manual: ", manual, "; man_data: %0d", man_data, "; man_addr: %0d", man_addr, "; man_write: ", man_write
        //, " ||| portA: %0d", portA, "; portB: %0d", portB, "; halted: ", halted);
    end

    reg funked = 0;
    always @(posedge portB[0]) begin
        $display("portA: ", portA, "; time: ", $time);
    end
    always @(posedge halted) begin
        $display("HALT SEQ");
        #100;
        cpu_run <= 0; flush <= 1; manual <= 1; man_write <= 1; wait (mem_done == 0); wait (mem_done == 1);
        flush <= 0;
        for (int i=1; i<32; i=i+1) begin
            man_addr <= i+200; man_data <= i+300; wait (mem_done == 0); wait (mem_done == 1);
        end
        man_write <= 0; man_addr <= -1; man_data[31:27] <= 17; #10; //load in
        man_write <= 1;
        for (int i=1; i<32; i=i+1) begin
            man_addr <= man_addr+1; man_data[26:22] <= i; man_data[21:17] <= 0; man_data[16:0] <= i+200; wait (mem_done == 0); wait (mem_done == 1);
        end
        man_data[31:27] <= 18; //write out
        for (int i=1; i<32; i=i+1) begin
            man_addr <= man_addr+1; man_data[26:22] <= i; man_data[21:17] <= 0; man_data[16:0] <= 255; wait (mem_done == 0); wait (mem_done == 1);
            man_addr <= man_addr+1; man_data [26:22] <= 31; man_data [21:17] <= 0; man_data [16:0] <= 254; wait (mem_done == 0); wait (mem_done == 1); //1 portB
            man_addr <= man_addr+1; man_data [26:22] <= 0; man_data [21:17] <= 0; man_data [16:0] <= 254; wait (mem_done == 0); wait (mem_done == 1); //0 portB
        end
        man_addr <= man_addr+1; man_data[31:27] <= 1; wait (mem_done == 0); wait (mem_done == 1);
        manual <= 0; cpu_run <= 1;
        #200000;
        $display("DONE");
        $display("run: ", cpu_run, "; flush: ", flush, " | manual: ", manual, "; man_data: %0d", man_data, "; man_addr: %0d", man_addr, "; man_write: ", man_write
        , " ||| portA: %0d", portA, "; portB: %0d", portB, "; halted: ", halted);
        $finish;
    end

    cpu test_cpu (cpu_run, flush, clk, mem_out, mem_done, cpu_data, cpu_addr, cpu_write, cpu_req, halted);
    memory #(256) test_mem (cpu_data, cpu_addr, cpu_write, cpu_req, manual, man_data, man_addr, man_write, clk, flush, portC, portD, mem_out, mem_done, portA, portB);

endmodule

    

    