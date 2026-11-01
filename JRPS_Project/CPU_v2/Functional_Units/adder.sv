module top_module_adder (); //going to be a few idiosyncracies due to rehaul, logic seems to be working fine
    reg clk=0;
	always #5 clk = ~clk;

    reg signed [31:0] op1;
    reg signed [31:0] op2;
    reg [21:0] imm;
    reg [3:0] FU_param;
    reg execute;
    wire signed [31:0] out;
    reg FU_type = 0;
    reg FU_reset;
    reg FU_run;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module);

        op1 <= 0; op2 <= 0; imm <= 0; FU_type <= 0; FU_param <= 0; FU_run <= 0; FU_reset <= 0; #10;
        $display("op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param[1:0], "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", out);


        $display("ALL PARAM TEST");
        op1 <= -15; op2 <= 23; FU_type <= 4;
        FU_param[1:0] <= 2'b00; #10;
        $display("op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param[1:0], "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", out);
        FU_param[1:0] <= 2'b01; #10;
        $display("op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param[1:0], "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", out);
        FU_param[1:0] <= 2'b10; #10;
        $display("op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param[1:0], "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", out);


        $display("WRONG TYPE TEST");
        FU_type <= 0; #10;
        $display("op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param[1:0], "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", out);

        $finish;
    end

    adder test_adder (op1, op2, ,imm, FU_param, execute, out);

endmodule //Top module has not been mopdified

module adder (
    input [31:0] op1_raw,
    input [31:0] op2,
    input use_imm,
    input [21:0] imm,
    input [3:0] operation,
    input execute,
    output [31:0] result);

    wire [31:0] op1 = use_imm? { {(22){1'b0}} , imm[9:0]} : op1_raw;
    
    wire [31:0] neg_in = operation[0]? op2 : op1;
    wire make_neg = operation[0] || operation[1];

    wire [31:0] inputa = operation[1]? 0 : op1;
    wire [31:0] inputb = make_neg? ~neg_in : op2;
    assign result = inputa + (inputb + make_neg);

endmodule