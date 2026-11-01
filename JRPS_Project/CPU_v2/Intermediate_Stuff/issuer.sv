module issuer (
    input [4:0] r_op1,
    input [4:0] r_op2,
    input [4:0] r_d,
    input [21:0] imm,
    input immsub,
    input [3:0] FU_type, 
    input [3:0] FU_param,
    input [12:0] busy,
    input fetch_stall,
    input run,
    input flush,
    input clk,
    output reg [4:0] decode_wreg [12:0],
    output reg [4:0] decode_rreg1 [12:0],
    output reg [4:0] decode_rreg2 [12:0],
    output reg [3:0] FU_param_out [12:0],
    output reg immsub_out [12:0],
    output reg [21:0] imm_out [12:0],
    output logic [3:0] issue_fu,
    output issue_stall);

    
    logic all_busy;
    always_comb begin
        case (FU_type)
            0: begin
                issue_fu = 0;
                all_busy = 0;
            end
            1: begin
                issue_fu = 1;
                all_busy = busy[1];
            end
            2: begin
                issue_fu = 2;
                all_busy = busy[2]; 
            end
            3: begin
                issue_fu = 3;
                all_busy = busy[3];
            end
            4: begin
                issue_fu = 4;
                all_busy = busy[4];
            end
            5: begin
                issue_fu = busy[5]? 6 : 5;
                all_busy = busy[5] && busy[6];
            end
            6: begin
                issue_fu = busy[7]? 8 : 7;
                all_busy = busy[7] && busy[8];
            end
            7: begin
                issue_fu = 9;
                all_busy = busy[9];
            end
            8: begin
                issue_fu = 10;
                all_busy = busy[10];
            end
            9: begin
                issue_fu = 11;
                all_busy = busy[11];
            end
            10: begin
                issue_fu = 12;
                all_busy = busy[12];
            end
            default: begin
                issue_fu = 0;
                all_busy = 1;
            end
        endcase
    end
    assign issue_stall = all_busy || fetch_stall || (~run);
    always @(posedge clk) begin
        if (FU_type == 1) begin
            $display("reached the halt");
        end
        if (!issue_stall) begin
            decode_wreg[issue_fu] <= r_d;
            decode_rreg1[issue_fu] <= r_op1;
            decode_rreg2[issue_fu] <= r_op2;
            FU_param_out[issue_fu] <= FU_param;
            immsub_out[issue_fu] <= immsub;
            imm_out[issue_fu] <= imm;
        end
    end
    always @(posedge flush) begin
        for (int i=0; i<13; i=i+1) begin
            decode_wreg[i] <= 0;
            decode_rreg1[i] <= 0;
            decode_rreg2[i] <= 0;
            FU_param_out[i] <= 0;
            immsub_out[i] <= 0;
            imm_out[i] <= 0;
        end
    end
    initial begin
        for (int i=0; i<13; i=i+1) begin
            decode_wreg[i] <= 0;
            decode_rreg1[i] <= 0;
            decode_rreg2[i] <= 0;
            FU_param_out[i] <= 0;
            immsub_out[i] <= 0;
            imm_out[i] <= 0;
        end
    end


    /* FU numbers
    0: NOP (ignore this) - Type 0
    1: HALT - Type 1
    2: EQ, LE - Type 2
    3: AND, OR, XOR, NOT - Type 3
    4: ADD, SUB, NEG - Type 4
    5: MUL 1 - Type 5
    6: MUL 2 - Type 5
    7: DIV, MOD 1 - Type 6
    8: DIV, MOD 2 - Type 6
    9: SHL, SHR - Type 7
    10: LI - Type 8
    11: LOAD, STORE - Type 9
    12: JUMP, BRZ, BRNZ - Type 10
    13+: INVALID - Type 11
    */

endmodule