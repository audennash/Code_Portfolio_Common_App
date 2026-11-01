module top_module_multiplier();
    reg clk=0;
	always #5 clk = ~clk;

    reg [31:0] op1;
    reg [31:0] op2;
    reg [21:0] imm;
    reg [3:0] FU_type;
    reg [3:0] FU_param;
    reg FU_run;
    reg FU_reset;
    wire [31:0] out;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module);

        op1 <= 0; op2 <= 0; imm <= 0; FU_type <= 0; FU_param <= 0; FU_run <= 0; FU_reset <= 0; #10;
        $display("op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", out);


        $display("TESTING 16*12");
        FU_type <= 5; op1 <= 16; op2 <= 12; #10;
        FU_param[3] <= 0; #10;
        $display("op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", out);
        FU_param[3] <= 1; #10;
        $display("op1: ", $signed(op1), "; op2: ", $signed(op2), "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", $signed(out));


        $display("TESTING -16*15");
        op1 <= -16; op2 <= 15; #10;
        FU_param[3] <= 0; #10;
        $display("op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", out);
        FU_param[3] <= 1; #10;
        $display("op1: ", $signed(op1), "; op2: ", $signed(op2), "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", $signed(out));


        $display("TESTING -22*-23");
        op1 <= -22; op2 <= -23; #10;
        FU_param[3] <= 0; #10;
        $display("op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", out);
        FU_param[3] <= 1; #10;
        $display("op1: ", $signed(op1), "; op2: ", $signed(op2), "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", $signed(out));


        $display("TESTING 14*-17");
        op1 <= 14; op2 <= -17; #10;
        FU_param[3] <= 0; #10;
        $display("op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", out);
        FU_param[3] <= 1; #10;
        $display("op1: ", $signed(op1), "; op2: ", $signed(op2), "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", $signed(out));


        $display("TESTING TC OVERFLOW");
        op1 <= 2**17+1; op2 <= 2**18-323; #10;
        FU_param[3] <= 0; #10;
        $display("op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", out);
        FU_param[3] <= 1; #10;
        $display("op1: ", $signed(op1), "; op2: ", $signed(op2), "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", $signed(out));


        $display("TESTING WRONG TYPE");
        FU_type <= 0; #10;
        FU_param[3] <= 0; #10;
        $display("op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", out);
        FU_param[3] <= 1; #10;
        $display("op1: ", $signed(op1), "; op2: ", $signed(op2), "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", $signed(out));
        
        $finish;
    end

    multiplier test_mult (op1, op2, imm, FU_type, FU_param, FU_run, FU_reset, out);

endmodule

module multiplier (
    input [31:0] op1,
    input [31:0] op2,
    input [21:0] imm,
    input [3:0] FU_type,
    input [3:0] FU_param,
    input FU_run,
    input FU_reset,
    output [31:0] out);

    wire signed [31:0] o1s = op1;
    wire signed [31:0] o2s = op2;

    wire [31:0] result_unsigned = op1*op2;
    wire signed [31:0] result_signed = o1s*o2s;
    wire [31:0] result = FU_param[3]? result_signed : result_unsigned;

    assign out = (FU_type == 5)? result : 0;

endmodule