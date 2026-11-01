module top_module_decoder();
    reg clk = 0;
    always #5 clk = ~clk;

    reg [31:0] inst;
    reg stall;
    reg run;
    wire [4:0] r_op1;
    wire [4:0] r_op2;
    wire [4:0] r_d;
    wire [21:0] imm;
    wire immsub;
    logic [3:0] FU_type;
    logic [3:0] FU_param;
    logic FU_run;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module);


        $display("STALL/RUN TEST");

        inst <= 0; stall <= 0; run <= 0; #10; 
        $display("inst: %b", inst, "; stall: ", stall, "; run: ", run,
        " ||| r_op 1,2: ", r_op1, " ", r_op2, "; r_d: ", r_d, "; imm: %b", imm, "; immsub: ", immsub, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run);

        run <= 1; #10;
        $display("inst: %b", inst, "; stall: ", stall, "; run: ", run,
        " ||| r_op 1,2: ", r_op1, " ", r_op2, "; r_d: ", r_d, "; imm: %b", imm, "; immsub: ", immsub, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run);

        stall <= 1;#10;
        $display("inst: %b", inst, "; stall: ", stall, "; run: ", run,
        " ||| r_op 1,2: ", r_op1, " ", r_op2, "; r_d: ", r_d, "; imm: %b", imm, "; immsub: ", immsub, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run);

        run <= 0; #10;
        $display("inst: %b", inst, "; stall: ", stall, "; run: ", run,
        " ||| r_op 1,2: ", r_op1, " ", r_op2, "; r_d: ", r_d, "; imm: %b", imm, "; immsub: ", immsub, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run);


        $display("SILLYBITS TEST");

        stall <= 0; run <= 1; inst[11] <= 1; inst[10] <= 1; #10;
        $display("inst: %b", inst, "; stall: ", stall, "; run: ", run,
        " ||| r_op 1,2: ", r_op1, " ", r_op2, "; r_d: ", r_d, "; imm: %b", imm, "; immsub: ", immsub, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run);

        inst[31] <= 1; #10;
        $display("inst: %b", inst, "; stall: ", stall, "; run: ", run,
        " ||| r_op 1,2: ", r_op1, " ", r_op2, "; r_d: ", r_d, "; imm: %b", imm, "; immsub: ", immsub, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run);
        

        $display("MANUAL OPCODE TEST");

        inst[11] <= 0; inst[10] <= 0; inst[31] <= 0; inst[26:22] <= 5'b10101; inst [16:12] <= 5'b11111; #10;
        for (int i=0; i<32; i=i+1) begin
            $display("REPa: ", inst[31:27], " || inst: %b", inst, "; stall: ", stall, "; run: ", run,
        " ||| r_op 1,2: ", r_op1, " ", r_op2, "; r_d: ", r_d, "; imm: %b", imm, "; immsub: ", immsub, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run);
            inst[11] <= 1; #10;
            $display("REPb: ", inst[31:27], " || inst: %b", inst, "; stall: ", stall, "; run: ", run,
        " ||| r_op 1,2: ", r_op1, " ", r_op2, "; r_d: ", r_d, "; imm: %b", imm, "; immsub: ", immsub, "; FU_type: ", FU_type, "; FU_param: %b", FU_param, "; FU_run: ", FU_run);
            $display("next");
            inst[31:27] <= inst[31:27] +1; inst [11] <= 0; #10;
        end


        $finish;
    end

    decoder test_decoder (inst, stall, run, r_op1, r_op2, r_d, imm, immsub, FU_type, FU_param, FU_run);

endmodule

module decoder (
    input [31:0] inst,
    input stall,
    input run,
    output [4:0] r_op1,
    output [4:0] r_op2,
    output [4:0] r_d,
    output [21:0] imm,
    output immsub,
    output logic [3:0] FU_type, // CHECK THIS!!!!
    output logic [3:0] FU_param,
    output logic FU_run);

    wire [4:0] opcode = inst[31:27];
    wire [4:0] r1 = inst[26:22];
    wire [4:0] r2 = inst[21:17];
    wire [4:0] r3 = inst[16:12];
    wire cbit = inst[11];

    wire r1_is_dest = (opcode[4]==0 && opcode[3:1]!=0) || (opcode[4]==1 && opcode[3:1]==0);
    assign r_d = r1_is_dest? r1 : 0;
    assign r_op1 = r1_is_dest? r2 : r1;
    assign r_op2 = r1_is_dest? r3 : r2;

    assign imm = inst[21:0];
    assign immsub = (opcode[4]==0)? inst[10] : 0;

    /*FU types:
    0: NOP
    1: HALT
    2: EQ, LE
    3: AND, OR, XOR, NOT
    4: ADD, SUB, NEG
    5: MUL
    6: DIV, MOD
    7: SHL, SHR
    8: LI
    9: LOAD, STORE
    10: JUMP, BRZ, BRNZ
    11: INVALID

    OPCODES:
    0	NOP
    1	HALT
    2	EQ
    3	LE
    4	AND
    5	OR
    6	XOR
    7	NOT
    8	ADD
    9	SUB
    10	MUL
    11	DIV
    12	MOD
    13	NEG
    14	SHL
    15	SHR
    16	LI
    17	LOAD
    18	STORE
    19	JUMP
    20	BRZ
    21	BRNZ
        */
    always_comb begin
        casez (opcode)
            5'b00000: begin //nop
                FU_type = 0;
            end
            5'b00001: begin //halt
                FU_type = 1;
            end
            5'b0001?: begin //eq/le
                FU_type = 2;
                FU_param[0] = opcode[0];
            end
            5'b001??: begin //and/or/xor/not
                FU_type = 3;
                FU_param[1:0] = opcode[1:0];
            end
            5'b0100?: begin //add/sub
                FU_type = 4;
                FU_param[1:0] = {1'b0, opcode[0]};
            end
            5'b01010: begin //mul
                FU_type = 5;
            end
            5'b01011: begin //div
                FU_type = 6;
                FU_param[0] = 0;
            end
            5'b01100: begin //mod
                FU_type = 6;
                FU_param[0] = 1;
            end
            5'b01101: begin //neg
                FU_type = 4;
                FU_param[1:0] = 2'b10;
            end
            5'b0111?: begin //shl/shr
                FU_type = 7;
                FU_param[0] = opcode[0];
            end
            5'b10000: begin //li
                FU_type = 8;
            end
            5'b10001: begin //load
                FU_type = 9;
                FU_param[0] = 0;
            end
            5'b10010: begin //store
                FU_type = 9;
                FU_param[0] = 1;
            end
            5'b10011: begin //jump
                FU_type = 10;
                FU_param[1] = 1;
            end
            5'b1010?: begin //brz/brnz
                FU_type = 10;
                FU_param[1:0] = {1'b0, opcode[0]};
            end
            default: begin
                FU_type = 11;
            end
        endcase
    end
    assign FU_param[3] = cbit;
    assign FU_run = (~stall) && run;
    

endmodule
//cpu_run && halt_reg -> run 
//cpu_flush (resets halt reg)