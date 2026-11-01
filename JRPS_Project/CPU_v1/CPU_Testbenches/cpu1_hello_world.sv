module top_module_hello_world ();
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

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module);

        cpu_run <= 0; flush <= 0; manual <= 0; man_data <= 0; man_addr <=0; man_write <= 0; #10;
        $display("run: ", cpu_run, "; flush: ", flush, " | manual: ", manual, "; man_data: %0d", man_data, "; man_addr: %0d", man_addr, "; man_write: ", man_write
        , " ||| portA: %0d", portA, "; portB: %0d", portB, "; halted: ", halted);

        $display("memory setup");
        manual <= 1; man_write <= 1; 
        man_data[31:27] <= 16; //loadimm instructions
        man_addr <= 0; man_data[26:22] <= 1; man_data[21:0] <= 72; #10;
        man_addr <= 1; man_data[26:22] <= 2; man_data[21:0] <= 101; #10;
        man_addr <= 2; man_data[26:22] <= 3; man_data[21:0] <= 108; #10;
        man_addr <= 3; man_data[26:22] <= 4; man_data[21:0] <= 108; #10;
        man_addr <= 4; man_data[26:22] <= 5; man_data[21:0] <= 111; #10;
        man_addr <= 5; man_data[26:22] <= 6; man_data[21:0] <= 32; #10;
        man_addr <= 6; man_data[26:22] <= 7; man_data[21:0] <= 87; #10;
        man_addr <= 7; man_data[26:22] <= 8; man_data[21:0] <= 111; #10;
        man_addr <= 8; man_data[26:22] <= 9; man_data[21:0] <= 114; #10;
        man_addr <= 9; man_data[26:22] <= 10; man_data[21:0] <= 108; #10;
        man_addr <= 10; man_data[26:22] <= 11; man_data[21:0] <= 100; #10;
        man_addr <= 11; man_data[26:22] <= 12; man_data[21:0] <= 33; #10;


        man_data[31:27] <= 18; man_data[21:17] <= 0; man_data[16:0] <= 255;// store instructions
        man_addr <= 12;  man_data[26:22] <= 1; #10;
        man_addr <= 13;  man_data[26:22] <= 2; #10;
        man_addr <= 14;  man_data[26:22] <= 3; #10; 
        man_addr <= 15;  man_data[26:22] <= 4; #10; 
        man_addr <= 16;  man_data[26:22] <= 5; #10; 
        man_addr <= 17;  man_data[26:22] <= 6; #10; 
        man_addr <= 18;  man_data[26:22] <= 7; #10; 
        man_addr <= 19;  man_data[26:22] <= 8; #10; 
        man_addr <= 20;  man_data[26:22] <= 9; #10; 
        man_addr <= 21;  man_data[26:22] <= 10; #10; 
        man_addr <= 22;  man_data[26:22] <= 11; #10; 
        man_addr <= 23;  man_data[26:22] <= 12; #10; 
        man_addr <= 24; man_data[31:27] <= 1; #10; //halt instruction
        cpu_run <= 0; flush <= 0; manual <= 0; man_data <= 0; man_addr <=0; man_write <= 0; #10;
        $display("runtime");
        $display("run: ", cpu_run, "; flush: ", flush, " | manual: ", manual, "; man_data: %0d", man_data, "; man_addr: %0d", man_addr, "; man_write: ", man_write
        , " ||| portA: %0d", portA, "; portB: %0d", portB, "; halted: ", halted);
        manual <= 0; cpu_run <= 1; #1000;
        $display("result time");
        $display("run: ", cpu_run, "; flush: ", flush, " | manual: ", manual, "; man_data: %0d", man_data, "; man_addr: %0d", man_addr, "; man_write: ", man_write
        , " ||| portA: %0d", portA, "; portB: %0d", portB, "; halted: ", halted);

        $finish;
    end

    cpu test_cpu (cpu_run, flush, clk, mem_out, cpu_data, cpu_addr, cpu_write, halted);
    memory #(256) test_mem (cpu_data, cpu_addr, cpu_write, manual, man_data, man_addr, man_write, clk, flush,,,mem_out, portA, portB);

endmodule

    

    