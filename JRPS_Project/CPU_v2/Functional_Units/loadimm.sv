module loadimm (
    input [31:0] op1,
    input [31:0] op2,
    input use_imm,
    input [21:0] imm,
    input [3:0] operation,
    input execute,
    output [31:0] result);

    assign result[31:22] = 0;
    assign result[21:0] = imm;
    
endmodule