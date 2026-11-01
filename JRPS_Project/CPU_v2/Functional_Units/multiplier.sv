module top_module_multiplier (); //should be good, careful of rehaul quirks
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

    multiplier test_mult (op1, op2, ,imm, FU_param, FU_run, out);

endmodule

module multiplier (
    input [31:0] op1_raw,
    input [31:0] op2,
    input use_imm,
    input [21:0] imm,
    input [3:0] operation,
    input execute,
    output [31:0] result);

    wire [31:0] op1 = use_imm? { {(22){1'b0}} , imm[9:0]} : op1_raw;

    wire signed [31:0] o1s = op1;
    wire signed [31:0] o2s = op2;

    wire [31:0] result_unsigned = op1*op2;
    wire signed [31:0] result_signed = o1s*o2s;
    assign result = operation[3]? result_signed : result_unsigned;

endmodule