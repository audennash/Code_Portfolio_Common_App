module loadimm (
    input [31:0] op1,
    input [31:0] op2,
    input [21:0] imm,
    input [3:0] FU_type,
    input [3:0] FU_param,
    input FU_run,
    input FU_reset,
    output [31:0] out);

    assign out[31:22] = 0;
    assign out[21:0] = (FU_type == 8)? imm : 0;
    
endmodule