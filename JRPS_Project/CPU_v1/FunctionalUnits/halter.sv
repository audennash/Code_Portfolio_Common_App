module halter (
    input [31:0] op1,
    input [31:0] op2,
    input [21:0] imm,
    input [3:0] FU_type,
    input [3:0] FU_param,
    input FU_run,
    input FU_reset,
    output set_halt);

    assign set_halt = (FU_type == 1) && FU_run;
endmodule