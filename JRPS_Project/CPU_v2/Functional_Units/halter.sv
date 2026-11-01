module halter (
    input [31:0] op1,
    input [31:0] op2,
    input use_imm,
    input [21:0] imm,
    input [3:0] operation,
    input execute,
    output [31:0] result,
    output set_hr);

    assign result = 0;
    assign set_hr = execute;
endmodule