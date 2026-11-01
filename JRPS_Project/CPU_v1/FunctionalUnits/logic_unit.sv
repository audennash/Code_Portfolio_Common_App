module top_module_logic_unit ();
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
        $display("op1: ", op1, "; op2: ", op2, "; FU_type: ", FU_type, "; FU_param: ", FU_param, " ||| out: ", out);


        $display("DIFFERENT PARAM TEST");
        op1 <= 8'b11011100; op2 <= 8'b10101010; FU_type <= 3; #10;
        $display("op1: %0b", op1, "; op2: %0b", op2, "; FU_type: ", FU_type, "; FU_param: ", FU_param, " ||| out: %0b", out); //and
        FU_param[1:0] <= FU_param[1:0] + 1; #10;
        $display("op1: %0b", op1, "; op2: %0b", op2, "; FU_type: ", FU_type, "; FU_param: ", FU_param, " ||| out: %0b", out); //or
        FU_param[1:0] <= FU_param[1:0] + 1; #10;
        $display("op1: %0b", op1, "; op2: %0b", op2, "; FU_type: ", FU_type, "; FU_param: ", FU_param, " ||| out: %0b", out); //xor
        FU_param[1:0] <= FU_param[1:0] + 1; #10;
        $display("op1: %0b", op1, "; op2: %0b", op2, "; FU_type: ", FU_type, "; FU_param: ", FU_param, " ||| out: %0b", out); //not
        FU_param[1:0] <= FU_param[1:0] + 1; #10;


        $display("WRONG FU TEST");
        FU_type <= 0; #10;
        $display("op1: %0b", op1, "; op2: %0b", op2, "; FU_type: ", FU_type, "; FU_param: ", FU_param, " ||| out: %0b", out); //and
        FU_param[1:0] <= FU_param[1:0] + 1; #10;
        $display("op1: %0b", op1, "; op2: %0b", op2, "; FU_type: ", FU_type, "; FU_param: ", FU_param, " ||| out: %0b", out); //or
        FU_param[1:0] <= FU_param[1:0] + 1; #10;
        $display("op1: %0b", op1, "; op2: %0b", op2, "; FU_type: ", FU_type, "; FU_param: ", FU_param, " ||| out: %0b", out); //xor
        FU_param[1:0] <= FU_param[1:0] + 1; #10;
        $display("op1: %0b", op1, "; op2: %0b", op2, "; FU_type: ", FU_type, "; FU_param: ", FU_param, " ||| out: %0b", out); //not
        FU_param[1:0] <= FU_param[1:0] + 1; #10;

        $finish;
    end

    logic_unit test_lu (op1, op2, imm, FU_type, FU_param, FU_run, FU_reset, out);

endmodule

module logic_unit (
    input [31:0] op1,
    input [31:0] op2,
    input [21:0] imm,
    input [3:0] FU_type,
    input [3:0] FU_param,
    input FU_run,
    input FU_reset,
    output [31:0] out);

    wire [31:0] andout = op1 & op2;
    wire [31:0] orout = op1 | op2;
    wire [31:0] xorout = op1 ^ op2;
    wire [31:0] notout = ~op1;

    wire [31:0] fh_out = FU_param[0]? orout : andout;
    wire [31:0] sh_out = FU_param[0]? notout : xorout;
    wire [31:0] result = FU_param[1]? sh_out : fh_out;
    assign out = (FU_type==3)? result : 0;

endmodule