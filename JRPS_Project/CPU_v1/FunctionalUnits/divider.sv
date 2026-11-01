module top_module_divider ();
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
        $display("op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param[1:0], "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", out);


        $display("137 12 TEST");
        FU_type <= 6; op1 <= 137; op2 <= 12; #10;
        FU_param[3] <= 0; FU_param[0] <= 0; #10;
        $display("divUS | op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", out);
        FU_param[0] <= 1; #10;
        $display("modUS | op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", out);
        FU_param[3] <= 1; FU_param[0] <= 0; #10;
        $display("divTC | op1: ", $signed(op1), "; op2: ", $signed(op2), "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", $signed(out));
        FU_param[0] <= 1; #10; 
        $display("modTC | op1: ", $signed(op1), "; op2: ", $signed(op2), "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", $signed(out));
        

        $display("-138 14 TEST");
        op1 <= -138; op2 <= 14; #10;
        FU_param[3] <= 0; FU_param[0] <= 0; #10;
        $display("divUS | op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", out);
        FU_param[0] <= 1; #10;
        $display("modUS | op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", out);
        FU_param[3] <= 1; FU_param[0] <= 0; #10;
        $display("divTC | op1: ", $signed(op1), "; op2: ", $signed(op2), "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", $signed(out));
        FU_param[0] <= 1; #10; 
        $display("modTC | op1: ", $signed(op1), "; op2: ", $signed(op2), "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", $signed(out));
        
        
        $display("-145 -39 TEST");
        op1 <= -145; op2 <= -39; #10;
        FU_param[3] <= 0; FU_param[0] <= 0; #10;
        $display("divUS | op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", out);
        FU_param[0] <= 1; #10;
        $display("modUS | op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", out);
        FU_param[3] <= 1; FU_param[0] <= 0; #10;
        $display("divTC | op1: ", $signed(op1), "; op2: ", $signed(op2), "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", $signed(out));
        FU_param[0] <= 1; #10; 
        $display("modTC | op1: ", $signed(op1), "; op2: ", $signed(op2), "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", $signed(out));
        

        $display("75 -8 TEST");
        op1 <= 75; op2 <= -8; #10;
        FU_param[3] <= 0; FU_param[0] <= 0; #10;
        $display("divUS | op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", out);
        FU_param[0] <= 1; #10;
        $display("modUS | op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", out);
        FU_param[3] <= 1; FU_param[0] <= 0; #10;
        $display("divTC | op1: ", $signed(op1), "; op2: ", $signed(op2), "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", $signed(out));
        FU_param[0] <= 1; #10; 
        $display("modTC | op1: ", $signed(op1), "; op2: ", $signed(op2), "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", $signed(out));


        $display("BREAK TEST");
        op2 <= 0; #10;
        FU_param[3] <= 0; FU_param[0] <= 0; #10;
        $display("divUS | op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", out);
        FU_param[0] <= 1; #10;
        $display("modUS | op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", out);
        FU_param[3] <= 1; FU_param[0] <= 0; #10;
        $display("divTC | op1: ", $signed(op1), "; op2: ", $signed(op2), "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", $signed(out));
        FU_param[0] <= 1; #10; 
        $display("modTC | op1: ", $signed(op1), "; op2: ", $signed(op2), "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", $signed(out));


        $display("RIGHT TYPE TEST");
        op2 <= 22; #10;
        FU_param[3] <= 0; FU_param[0] <= 0; #10;
        $display("divUS | op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", out);
        FU_param[0] <= 1; #10;
        $display("modUS | op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", out);
        FU_param[3] <= 1; FU_param[0] <= 0; #10;
        $display("divTC | op1: ", $signed(op1), "; op2: ", $signed(op2), "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", $signed(out));
        FU_param[0] <= 1; #10; 
        $display("modTC | op1: ", $signed(op1), "; op2: ", $signed(op2), "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", $signed(out));


        $display("WRONG TYPE TEST");
        FU_type <= 0; #10;
        FU_param[3] <= 0; FU_param[0] <= 0; #10;
        $display("divUS | op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", out);
        FU_param[0] <= 1; #10;
        $display("modUS | op1: ", op1, "; op2: ", op2, "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", out);
        FU_param[3] <= 1; FU_param[0] <= 0; #10;
        $display("divTC | op1: ", $signed(op1), "; op2: ", $signed(op2), "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", $signed(out));
        FU_param[0] <= 1; #10; 
        $display("modTC | op1: ", $signed(op1), "; op2: ", $signed(op2), "; imm: ", imm, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run, "; FU_reset: ", FU_reset, " ||| out: ", $signed(out));

        $finish;
    end

    divider test_divider (op1, op2, imm, FU_type, FU_param, FU_run, FU_reset, out);

endmodule

module divider (
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

    wire [31:0] div_unsigned = op1/op2;
    wire [31:0] mod_unsigned = op1%op2;

    wire signed [31:0] div_signed = o1s/o2s;
    wire signed [31:0] mod_signed = o1s%o2s;

    wire [31:0] result_div = FU_param[3]? div_signed : div_unsigned;
    wire [31:0] result_mod = FU_param[3]? mod_signed : mod_unsigned;
    wire [31:0] result = FU_param[0]? result_mod : result_div;

    assign out = (FU_type == 6)? result : 0;

endmodule