module top_module_comparator (); //seems to work fine, there may be some quirks due to rehaul
    reg clk=0;
	always #5 clk = ~clk;

    reg [31:0] op1;
    reg [31:0] op2;
    reg [21:0] imm;
    reg [3:0] FU_type;
    reg [3:0] FU_param;
    reg FU_run;
    reg FU_reset;
    wire [31:0] c_true;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module);

        $display("TEST: 0 v 0");
        op1 <= 0; op2 <= 0; imm <= 0; FU_type <= 2; FU_param <= 0; FU_run <= 1; FU_reset <= 0; #10;
        //eq
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);
        //le us
        FU_param[0] <= 1; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);
        //le s
        FU_param[3] <= 1; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);


        $display("TEST: 1 v 17");
        op1 <= 1; op2 <= 17; #10;
        //eq
        FU_param[0] <= 0; FU_param[3] <= 0; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);
        //le us
        FU_param[0] <= 1; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);
        //le s
        FU_param[3] <= 1; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);


        $display("TEST: 17 v 17");
        op1 <= 17; #10;
        //eq
        FU_param[0] <= 0; FU_param[3] <= 0; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);
        //le us
        FU_param[0] <= 1; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);
        //le s
        FU_param[3] <= 1; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);


        $display("TEST: 28 v 17");
        op1 <= 28; #10;
        //eq
        FU_param[0] <= 0; FU_param[3] <= 0; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);
        //le us
        FU_param[0] <= 1; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);
        //le s
        FU_param[3] <= 1; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);


        $display("TEST: 1....1 vs 17");
        op1[31] <= 1; op1[1] <= 1; #10;
        //eq
        FU_param[0] <= 0; FU_param[3] <= 0; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);
        //le us
        FU_param[0] <= 1; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);
        //le s
        FU_param[3] <= 1; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);


        $display("Test: 17 vs 1....1");
        op1 <= op2; op2 <= op1; #10;
        //eq
        FU_param[0] <= 0; FU_param[3] <= 0; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);
        //le us
        FU_param[0] <= 1; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);
        //le s
        FU_param[3] <= 1; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);


        $display("Test: 1....1 vs 1....11");
        op1[31] <= 1; op1[0] <= 1; op2[31] <= 1; op2[1] <= 1; op2[0] <= 1; #10;
        //eq
        FU_param[0] <= 0; FU_param[3] <= 0; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);
        //le us
        FU_param[0] <= 1; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);
        //le s
        FU_param[3] <= 1; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);

        $display("Test: 1....11 vs 1....1");
        op1 <= op2; op2 <= op1; #10;
        //eq
        FU_param[0] <= 0; FU_param[3] <= 0; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);
        //le us
        FU_param[0] <= 1; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);
        //le s
        FU_param[3] <= 1; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);

        $display("Now those eq");
        op1 <= op2;
        //eq
        FU_param[0] <= 0; FU_param[3] <= 0; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);
        //le us
        FU_param[0] <= 1; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);
        //le s
        FU_param[3] <= 1; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);

        $display("FUTYPE TEST");
        FU_run <= 0; op1 <= 10; op2 <= 12; #10;
        FU_param[0] <= 0; FU_param[3] <= 0; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);
        //le us
        FU_param[0] <= 1; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);
        //le s
        FU_param[3] <= 1; #10;
        $display("op1: %0d", op1, "; op2: %0d", op2, "; imm: %0d", imm, "; FU_type: %b", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset,
        " ||| c_true: ", c_true);


        $finish;
    end

    comparator test_comp (op1, op2, ,imm, FU_param, FU_run, c_true);

endmodule

module comparator (
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
    wire le_us = (op1 <= op2);
    wire le_s = (o1s <= o2s);
    wire le_out = operation[3]? le_s : le_us;

    wire eq_out = (op1 == op2);

    wire c_true = operation[0]? le_out : eq_out;
    assign result = {{31{1'b0}}, c_true};

endmodule