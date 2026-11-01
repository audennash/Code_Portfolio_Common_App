module top_module_shifter ();
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
        $display("op1: %b", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param[1:0], "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: %b", out);

        $display("0....10010 SHIFT 3 TEST");
        FU_type <= 7; op1 <= {{27{1'b0}}, 5'b10010}; op2 <= 3;
        FU_param[3] <= 0; FU_param[0] <= 0; #10;
        $display("SHL | op1: %b", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: %b", out);
        FU_param[0] <= 1; #10;
        $display("SHR | op1: %b", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: %b", out);
        FU_param[3] <= 1; #10;
        $display("SAR | op1: %b", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: %b", out);

        $display("1....10110 SHIFT 3 TEST");
        op1 <= {1'b1, {26{1'b0}}, 5'b10110};
        FU_param[3] <= 0; FU_param[0] <= 0; #10;
        $display("SHL | op1: %b", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: %b", out);
        FU_param[0] <= 1; #10;
        $display("SHR | op1: %b", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: %b", out);
        FU_param[3] <= 1; #10;
        $display("SAR | op1: %b", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: %b", out);

        $display("MEGASHIFT Test");
        op2 <= 156;
        FU_param[3] <= 0; FU_param[0] <= 0; #10;
        $display("SHL | op1: %b", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: %b", out);
        FU_param[0] <= 1; #10;
        $display("SHR | op1: %b", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: %b", out);
        FU_param[3] <= 1; #10;
        $display("SAR | op1: %b", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: %b", out);


        $display("CORRECT TYPE TEST");
        op1 <= {3'b101, {21{1'b0}}, 8'b11010110}; op2 <= 5;
        FU_param[3] <= 0; FU_param[0] <= 0; #10;
        $display("SHL | op1: %b", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: %b", out);
        FU_param[0] <= 1; #10;
        $display("SHR | op1: %b", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: %b", out);
        FU_param[3] <= 1; #10;
        $display("SAR | op1: %b", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: %b", out);


        $display("WRONG TYPE TEST");
        FU_type <= 0;
        FU_param[3] <= 0; FU_param[0] <= 0; #10;
        $display("SHL | op1: %b", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: %b", out);
        FU_param[0] <= 1; #10;
        $display("SHR | op1: %b", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: %b", out);
        FU_param[3] <= 1; #10;
        $display("SAR | op1: %b", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: %b", out);
        $finish;
    end

    shifter test_shifter (op1, op2, imm, FU_type, FU_param, FU_run, FU_reset, out);

endmodule

module shifter (
    input [31:0] op1,
    input [31:0] op2,
    input [21:0] imm,
    input [3:0] FU_type,
    input [3:0] FU_param,
    input FU_run,
    input FU_reset,
    output [31:0] out);

    wire [31:0] left_shift = op1 << op2;
    wire [31:0] right_logical_shift = op1 >> op2;
    wire signed [31:0] os1 = op1;
    wire [31:0] right_arithmetic_shift = os1 >>> op2;
    wire [31:0] right_shift = FU_param[3]? right_arithmetic_shift : right_logical_shift;

    wire [31:0] result = FU_param[0]? right_shift : left_shift;

    assign out = (FU_type == 7)? result : 0;

endmodule