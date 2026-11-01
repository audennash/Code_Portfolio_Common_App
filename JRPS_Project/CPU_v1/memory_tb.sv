module top_module_memory_tb ();
    reg clk=0;
	always #5 clk = ~clk;

    reg [31:0] cpu_data;
    reg [31:0] cpu_addr;
    reg cpu_write;
    reg manual;
    reg [31:0] man_data;
    reg [31:0] man_addr;
    reg man_write;
    reg flush;

    wire [31:0] mem_out;
    wire [31:0] portA;
    wire [31:0] portB;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module);

        cpu_data <= 0; cpu_addr <= 0; cpu_write <= 0; manual <= 0; man_data <= 0; man_addr <= 0; man_write <= 0; flush <= 0; #10;
        $display("cpu_data: %0d", cpu_data, "; cpu_addr: %0d", cpu_addr, "; cpu_write: ", cpu_write, " | manual: ", manual, 
        " | man_data: %0d", man_data, "; man_addr: %0d", man_addr, "; man_write: ", man_write, " | flush: ", flush,
        " ||| mem_out: %0d", mem_out, "; portA: %0d", portA, "; portB: %0d", portB);

        
        $display("INITIAL RW TEST");
        cpu_write <= 1;
        for (int i=0; i<32; i=i+1) begin
            cpu_data <= i; cpu_addr <= i;
            #10;
        end
        cpu_write <= 0;
        for (int i=0; i<32; i=i+1) begin
            cpu_addr <= i; #10;
            $display("cpu_data: %0d", cpu_data, "; cpu_addr: %0d", cpu_addr, "; cpu_write: ", cpu_write, " | manual: ", manual, 
            " | man_data: %0d", man_data, "; man_addr: %0d", man_addr, "; man_write: ", man_write, " | flush: ", flush,
            " ||| mem_out: %0d", mem_out, "; portA: %0d", portA, "; portB: %0d", portB);
        end

        
        $display("PORT TEST");
        cpu_addr <= 255; cpu_write <= 1; #10;
        cpu_addr <= 254; cpu_data <= 32; cpu_write <= 1; #10;
        cpu_write <= 0; #10;
        $display("cpu_data: %0d", cpu_data, "; cpu_addr: %0d", cpu_addr, "; cpu_write: ", cpu_write, " | manual: ", manual, 
        " | man_data: %0d", man_data, "; man_addr: %0d", man_addr, "; man_write: ", man_write, " | flush: ", flush,
        " ||| mem_out: %0d", mem_out, "; portA: %0d", portA, "; portB: %0d", portB);

        $display("FLUSH TEST");
        flush <= 1; #10; flush <= 0; #10;
        for (int i=0; i<32; i=i+1) begin
            cpu_addr <= i; #10;
            $display("cpu_data: %0d", cpu_data, "; cpu_addr: %0d", cpu_addr, "; cpu_write: ", cpu_write, " | manual: ", manual, 
            " | man_data: %0d", man_data, "; man_addr: %0d", man_addr, "; man_write: ", man_write, " | flush: ", flush,
            " ||| mem_out: %0d", mem_out, "; portA: %0d", portA, "; portB: %0d", portB);
        end        


        $display("MANUAL TEST");
        manual <= 1; man_addr <= 63; man_data <= 12; man_write <= 1; #10; man_write <= 0;

        cpu_write <= 1;
        for (int i=0; i<32; i=i+1) begin
            cpu_data <= i; cpu_addr <= i;
            #10;
        end
        cpu_write <= 0;
        for (int i=0; i<32; i=i+1) begin
            cpu_addr <= i; #10;
            $display("cpu_data: %0d", cpu_data, "; cpu_addr: %0d", cpu_addr, "; cpu_write: ", cpu_write, " | manual: ", manual, 
            " | man_data: %0d", man_data, "; man_addr: %0d", man_addr, "; man_write: ", man_write, " | flush: ", flush,
            " ||| mem_out: %0d", mem_out, "; portA: %0d", portA, "; portB: %0d", portB);
        end
        $display("man addr scan");
        for (int i=0; i<32; i=i+1) begin
            man_addr <= i; #10;
            $display("cpu_data: %0d", cpu_data, "; cpu_addr: %0d", cpu_addr, "; cpu_write: ", cpu_write, " | manual: ", manual, 
            " | man_data: %0d", man_data, "; man_addr: %0d", man_addr, "; man_write: ", man_write, " | flush: ", flush,
            " ||| mem_out: %0d", mem_out, "; portA: %0d", portA, "; portB: %0d", portB);
        end

        $finish;
    end

    memory #(.width(256)) test_mem (cpu_data, cpu_addr, cpu_write, manual, man_data, man_addr, man_write, clk, flush, mem_out, portA, portB);

endmodule