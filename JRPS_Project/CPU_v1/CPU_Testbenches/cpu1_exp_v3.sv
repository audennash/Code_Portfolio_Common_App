module top_module ();
    //to check: nops/undefineds, halts, lis, loads/stores, control
    reg clk=0;
	always #170 clk = ~clk;

    reg cpu_run;
    reg flush;
    wire halted;

    reg manual;
    wire [31:0] man_data;
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

    /*begin psea shorthands*/
    wire [4:0] x = 1;
    wire [4:0] reps_left = 2;
    wire [4:0] at_the_end = 3;
    wire [4:0] numerator = 4;
    wire [4:0] n = 5;
    wire [4:0] x_tothe_n = 6;
    wire [4:0] c1 = 7;
    wire [4:0] fact = 8;

    wire [4:0] quot = 9;
    wire [4:0] point = 10;
    wire [4:0] num_ef = 11;
    wire [4:0] num_new = 12;
    wire [4:0] quot_bit = 13;
    wire [4:0] rem_new = 14;
    wire [4:0] ind = 15;
    wire [4:0] indselreg = 16;
    wire [4:0] indselout = 17;
    wire [4:0] first_one = 18;
    wire [4:0] in_frac = 19;

    /*end psea shorthands*/
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module);

        cpu_run <= 0; flush <= 0; portC <= 0; portD <= 0;
        man_addr <= 0; manual <= 1; man_write <= 1; raw_write(0); #340;
        
        $display("WRITING INSTRUCTIONS at %0d", $time);
        //numerator/denominator+(x^n)/(denominator*n)= (n*numerator+x^n)/(denominator*n)
        
        //port C = value, port D = accuracy | reg1 = x, reg2=repetitions left, reg3=comparison, reg4=numerator, reg5=n, reg6 = x^n, reg7=1;
        mi_inst(17, x, 0, 253); //x = portC
        mi_inst(17, reps_left, 0, 252); //reps_left = port D
        li_inst(16, x_tothe_n, 1); //x^n = 1;
        li_inst(16, c1, 1); //c1=1;
        li_inst(16, fact, 1); //fact=1

        si_inst(10, numerator, numerator, n); //numerator=numerator*n (start of loop)
        si_inst(8, numerator, numerator, x_tothe_n); //numerator=numerator+x^n
        si_inst(8, n,   n, c1); //n=n+1
        si_inst(10, x_tothe_n,   x_tothe_n, x); //x^n=x^n*x
        si_inst(2, at_the_end,   reps_left, 0); //at_the_end = (reps_left == 0);
        mi_inst(20, at_the_end, 0, man_addr+5); //branch if at_the_end to addr+4 (div algo)
        si_inst(10, fact,   fact, n); //fact=fact*n
        si_inst(9, reps_left,   reps_left, c1); //reps_left = reps_left-1
        li_inst(19, 0, man_addr-7); //jump to addr-8 (start of loop)

        si_inst(8, num_ef, numerator, 0); //num_ef = numerator + 0;
        li_inst(16, ind, 31); //ind = 31;
        si_inst(14, indselreg, c1, ind); //indselreg=c1 << r24;

        si_inst(2, 24, indselreg, 0); //reg24 = (indselreg==0) [start of loop]
        mi_inst(20, 24, 0, man_addr+17); //if reg24: branch to man_addr+16
        si_inst(14, rem_new, rem_new, c1); //rem_new = rem_new << c1;
        si_inst(4, indselout, num_ef, indselreg); //indselout = num_ef & indselreg;
        si_inst(15, indselout, indselout, ind); //indselout = indselout >> ind;
        si_inst(5, num_new, rem_new, indselout); //num_new = rem_new | indselout;
        si_inst(11, quot_bit, num_new, fact); //quot_bit = num_new // fact;
        si_inst(12, rem_new, num_new, fact); //rem_new = num_new % fact;
        si_inst(14, indselout, quot_bit, ind); //indselout = rem_new << ind;
        si_inst(5, quot, quot, indselout); //quot = quot | quot_bit;
        si_inst(2, indselout, first_one, 0); //indselout = (first_one==0);
        si_inst(4, indselout, indselout, quot_bit); //indselout = indselout & quotbit;
        mi_inst(21, indselout, 0, man_addr+3); //if not indselout: goto man_addr+2;
        si_inst(8, first_one, ind, 0); //first_one=ind+0;
        si_inst(9, ind, ind, c1); //ind=ind-c1;
        si_inst(15, indselreg, indselreg, c1); //indselreg = indselreg >> c1;
        li_inst(19, 0, man_addr-15); //jump to man_addr-16;

        mi_inst(20, in_frac, 0, man_addr+10); //if infrac, branch to man_addr+9  [start of fracprod]
        li_inst(16, 24, 31); //load 31 into reg 24;
        si_inst(9, point, 24, first_one); //point = reg24-firstone;
        si_inst(14, quot, quot, point); //quot = quot << point;
        si_inst(8, num_ef, 0, 0); //num_ef = 0+0;
        si_inst(9, ind, point, c1); //ind=point-c1;
        si_inst(14, indselreg, c1, ind); //indselreg = c1 << ind
        li_inst(16, in_frac, 1); //in_frac=1;
        li_inst(19, 0, man_addr-24); //jump to man_addr-25

        mi_inst(18, quot, 0, 255); //store quotient in port A
        mi_inst(18, point, 0, 254); //store point location in port B
        li_inst(1, 0); //halt




        portC <= 1; portD = 12; #10; //x and acc respectively
        $display("SETTING INPUTS at %0d", $time);
        manual <= 0; cpu_run <= 1;
        $display("RUNNING CPU at %0d", $time);
        #500000;
        $display("TIME ELAPSED, PROGRAM SHUTDOWN at %0d", $time);
        //$display("result time");
        $finish;
    end

	function automatic integer factorial (input integer n); //Google AI wrote this function
        if (n <= 1) begin
            factorial = 1;
        end else begin
            factorial = n * factorial(n - 1);
        end
    endfunction


    always @(posedge halted) begin
        $display("DONE! OUTPUT STATUS at %0d", $time, ":");
        $display("Desired: e^%0d", portC, " with accuracy %0d", portD, " | Results: portA=%b", portA, "; portB=%0d", portB);
    end
    cpu test_cpu (cpu_run, flush, clk, mem_out, cpu_data, cpu_addr, cpu_write, halted);
    memory #(256) test_mem (cpu_data, cpu_addr, cpu_write, manual, man_data, man_addr, man_write, clk, flush, portC, portD, mem_out, portA, portB);

    /*
    Pseudo-Assembly Stuff
    */
    reg [4:0] opcode;
    reg [4:0] r1;
    reg [4:0] r2;
    reg [4:0] r3;
    reg [1:0] cbits;
    reg [21:0] imm;

    reg [1:0] op_type;
    wire [4:0] r2_real = op_type[1]? imm[21:17] : r2;
    wire [4:0] r3_real = op_type[0]? imm[16:12] : r3;
    wire [1:0] cbits_real = op_type[0]? imm[11:10] : cbits;
    assign man_data = {opcode, r1, r2_real, r3_real, cbits_real, imm[9:0]};

    task automatic si_inst (input [4:0] fopcode, input [4:0] fr1, input [4:0] fr2, input [4:0] fr3, input [1:0] fcbits = 2'b00, input [9:0] fimm = 0);
        man_addr <= man_addr+1; op_type <= 2'b00; opcode <= fopcode; r1 <= fr1; r2 <= fr2; r3 <= fr3; cbits <= fcbits; imm <= fimm; #340;
    endtask
    task automatic mi_inst (input [4:0] fopcode, input [4:0] fr1, input [4:0] fr2, input [16:0] fimm = 0);
        man_addr <= man_addr+1; op_type <= 2'b01; opcode <= fopcode; r1 <= fr1; r2 <= fr2; imm <= fimm; #340;
    endtask
    task automatic li_inst (input [4:0] fopcode, input [4:0] fr1, input [21:0] fimm = 0);
        man_addr <= man_addr+1; op_type <= 2'b11; opcode <= fopcode; r1 <= fr1; imm <= fimm; #340;
    endtask
    task automatic raw_write (input [31:0] raw_data);
        op_type <= 2'b11; opcode <= raw_data[31:27]; r1 <= raw_data[26:22]; imm <= raw_data[21:0]; #340;
    endtask

endmodule 

    

    
