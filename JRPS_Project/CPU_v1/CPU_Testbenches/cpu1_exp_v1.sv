module top_module_cpu1_exp_v1 ();
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
    reg [31:0] portC;
    reg [31:0] portD;

    wire [31:0] mem_out;
    wire [31:0] cpu_data;
    wire [31:0] cpu_addr;
    wire cpu_write;

    reg [8:0] op_number = 0;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module);
        $display("WRITING INSTRUCTIONS");
        manual <= 1; man_write <= 1; #10; //numerator/denominator+(x^n)/(denominator*n)= (n*numerator+x^n)/(denominator*n)
        
        //port C = value, port D = accuracy | reg1 = x, reg2=repetitions left, reg3=comparison, reg4=numerator, reg5=n, reg6 = x^n, reg7=1;
        man_addr <= 0; man_data[31:27] <= 17; man_data[26:22] = 1; man_data[21:17] = 0; man_data[16:0] = 253; #10; //reg1 = port C
        man_addr <= 1; man_data[31:27] <= 17; man_data[26:22] = 2; man_data[21:17] = 0; man_data[16:0] = 252; #10; //reg2 = port D
        man_addr <= 2; man_data[31:27] <= 16; man_data[26:22] = 6; man_data[21:0] = 1; #10; //reg6 = 1
        man_addr <= 3; man_data[31:27] <= 16; man_data[26:22] = 7; man_data[21:0] = 1; #10; //reg7 = 1

        man_addr <= man_addr+1; man_data[31:27] <= 10; man_data[26:22] <= 4; man_data[21:17] <= 4; man_data[16:12] <= 5; man_data[11:0] <= 0; #10; //numerator=numerator*n
        man_addr <= man_addr+1; man_data[31:27] <= 8; man_data[26:22] <= 4; man_data[21:17] <= 4; man_data[16:12] <= 6; man_data[11:0] <= 0; #10; //numerator=numerator+x^n

        man_addr <= man_addr+1; man_data[31:27] <= 8; man_data[26:22] <= 5; man_data[21:17] <= 0; man_data[16:12] <= 5; man_data[11:10] <= 2'b01; man_data[9:0] <= 1; #10; //n=n+1
        man_addr <= man_addr+1; man_data[31:27] <= 10; man_data[26:22] <= 6; man_data[21:17] <= 6; man_data[16:12] <= 1; man_data[11:0] <= 0; #10; //reg6=reg6*x
        man_addr <= man_addr+1; man_data[31:27] <= 2; man_data[26:22] <= 3; man_data[21:17] <= 2; man_data[16:12] <= 0; man_data[11:0] <= 0; #10; //reg3 = (reg2==0)
        man_addr <= man_addr+1; man_data[31:27] <= 20; man_data[26:22] <= 3; man_data[21:17] <= 0; man_data[16:0] <= man_addr+4; #10; //go to store if they're equal;
        man_addr <= man_addr+1; man_data[31:27] <= 9; man_data[26:22] <= 2; man_data[21:17] <= 2; man_data[16:12] <= 7; man_data[11:0] <= 0; #10; //reg2=reg2-1
        man_addr <= man_addr+1; man_data[31:27] <= 19; man_data[26:22] <= 0; man_data[21:0] <= 4; #10; //jump back to start of loop
        man_addr <= man_addr+1; man_data[31:27] <= 18; man_data[26:22] <= 4; man_data[21:17] <= 0; man_data[16:0] <= 255; #10;
        man_addr <= man_addr+1; man_data[31:27] <= 1; #10; //halt 
        
        portC <= 1; //x
        portD <= 12; //accuracy
        manual <= 0; cpu_run <= 1;
        $display("RUNNING CPU");
        #3000;
        //$display("result time");
        $display("OUTPUT STATUS");
        $display("run: ", cpu_run, "; flush: ", flush, " | manual: ", manual, "; man_data: %0d", man_data, "; man_addr: %0d", man_addr, "; man_write: ", man_write
        , " ||| portA: %0d", portA, "; portB: %0d", portB, "; halted: ", halted);

        $finish;
    end

    function automatic integer factorial (input integer n); //Google AI wrote this I hope it works
        if (n <= 1) begin
            factorial = 1;
        end else begin
            factorial = n * factorial(n - 1);
        end
    endfunction


    always @(posedge halted) begin
        $display("in: ", portC, "; acc: ", portD, " | output : ", portA, "; estimate: %.15f", (real'( portA )/real'( factorial(portD) )) );
    end
    cpu test_cpu (cpu_run, flush, clk, mem_out, cpu_data, cpu_addr, cpu_write, halted);
    memory #(256) test_mem (cpu_data, cpu_addr, cpu_write, manual, man_data, man_addr, man_write, clk, flush, portC, portD, mem_out, portA, portB);

endmodule

    

    