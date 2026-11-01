module top_module_register_file ();
    reg clk = 0;
    always #5 clk = ~clk;

    reg [4:0] r_op1;
    reg [4:0] r_op2;
    reg [4:0] r_d;
    reg [31:0] data;
    reg flush;
    reg FU_run;
    reg [21:0] imm;
    reg immsub;
    wire [31:0] op1;
    wire [31:0] op2;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module);

        r_op1 <= 0; r_op2 <= 0; r_d <= 0; data <= 0; flush <= 0; FU_run <= 0; imm <= 0; immsub <= 0; #10;
        $display("r_op1: ", r_op1, "; r_op2: ", r_op2, "; r_d: ", r_d, "; data: ", data, "; flush: ", flush, "; FU_run: ", FU_run, "; imm: ", imm, "; immsub: ", immsub, 
        "||| op1: ", op1, "; op2: ", op2);

        $display("NORMAL R/W TEST");
        FU_run <= 1; #10;
        for (int i=0; i<32; i=i+1) begin
            r_d <= i;
            data <= i;
            #10;
        end
        r_d <= 0;
        for (int i=0; i<32; i=i+1) begin
            r_op1 <= i; r_op2 <= 31-i; #10;
            $display("reg1: ", r_op1, "; data1: ", op1, " ||| reg2: ", r_op2, "; data2: ", op2);
        end

        $display("R0 TEST");
        r_d <= 0; r_op1 <= 0; r_op2 <= 0; data <= 8; #10;
        $display("r0: ", op1, op2);
        r_d <= 1; r_op1 <= 1; r_op2 <= 1; #10;
        $display("r0: ", op1, op2);

        $display("FLUSH TEST");
        r_d <= 0; flush <= 1; #10; flush <= 0;
        for (int i=0; i<32; i=i+1) begin
            r_op1 <= i; r_op2 <= 31-i; #10;
            $display("reg1: ", r_op1, "; data1: ", op1, " ||| reg2: ", r_op2, "; data2: ", op2);
        end

        $display("RUNOFF TEST");
        FU_run <= 0; #10;
        for (int i=0; i<32; i=i+1) begin
            r_d <= i;
            data <= i;
            #10;
        end
        r_d <= 0;
        for (int i=0; i<32; i=i+1) begin
            r_op1 <= i; r_op2 <= 31-i; #10;
            $display("reg1: ", r_op1, "; data1: ", op1, " ||| reg2: ", r_op2, "; data2: ", op2);
        end
        $display("runnow"); FU_run <= 1;
        for (int i=0; i<32; i=i+1) begin
            r_d <= i;
            data <= 2*i;
            #10;
        end
        r_d <= 0;
        for (int i=0; i<32; i=i+1) begin
            r_op1 <= i; r_op2 <= 31-i; #10;
            $display("reg1: ", r_op1, "; data1: ", op1, " ||| reg2: ", r_op2, "; data2: ", op2);
        end

        $display("IMM TEST"); 
        r_op1 <= 15; r_op2 <= 12; data <= 1; immsub <= 0; imm <= 31; #10;
        $display("immsub: ", immsub, "; out: ", op1, op2);
        immsub <= 1; #10;
        $display("immsub: ", immsub, "; out: ", op1, op2);

        $finish;
    end


    register_file test_rf (r_op1, r_op2, r_d, data, clk, flush, FU_run, imm, immsub, op1, op2);

endmodule

module register_file (
    input [4:0] r_op1,
    input [4:0] r_op2,
    input [4:0] r_d,
    input [31:0] data,
    input clk,
    input flush,
    input FU_run,
    input [21:0] imm,
    input immsub,
    output [31:0] op1,
    output [31:0] op2);

    reg [31:0] rf_data [31:0];
    assign op1 = immsub? imm[9:0] : rf_data[r_op1];
    assign op2 = rf_data[r_op2];

    always @(posedge clk) begin
        if (FU_run) begin
            rf_data[r_d] <= (r_d==0)? 0: data;
        end
    end

    always @(posedge flush) begin
        for (int i=0; i<32; i=i+1) begin
            rf_data[i] <= 0;
        end
    end

    initial begin
        for (int i=0; i<32; i=i+1) begin
            rf_data[i] <= 0;
        end
    end

endmodule