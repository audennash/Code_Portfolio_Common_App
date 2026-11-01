module fu_handler #(parameter delay, parameter imm_width) (
    input [31:0] sr1_data, input [31:0] sr2_data, //from regfile
    input can_read, input can_write, input read_enable, input write_enable, input active,//from scoreboard
    input reg [4:0] decode_wreg, input reg [4:0] decode_rreg1, input reg [4:0] decode_rreg2, //from decoder
    input reg [3:0] FU_param, input reg immsub, input reg [21:0] imm, //from decoder (part 2)
    input run, input flush, input clk, //from cpu main
    output [31:0] dr_data, output [4:0] dr, output [4:0] sr1, output [4:0] sr2, //to rf
    output reg [1:0] phase, output busy, //to scoreboard/decode file
    output reg [31:0] o1, output reg [31:0] o2, output use_imm, output [imm_width-1:0] imm_field, output [3:0] operation, output execute, input [31:0] execution_result); //very important it gets a little difference here you interface with functional unit here
    assign dr = decode_wreg;
    assign sr1 = decode_rreg1;
    assign sr2 = decode_rreg2;

    assign operation = FU_param;
    assign execute = (phase == 2'b10);
    assign use_imm = immsub;
    assign imm_field = imm[imm_width-1:0];
    assign dr_data = execution_result;
    reg execution_done;
    assign busy = active;
    always @(posedge clk) begin

        if (can_read && (phase==2'b00)) begin
            phase <= 2'b01; //read permitted, so await read
        end else if (read_enable && (~execution_done)) begin
            phase <= 2'b10; //read enabled, so execute
            execution_done <= #delay ~(phase == 2'b10);
            if (phase != 2'b10) begin
                o1 <= sr1_data;
                o2 <= sr2_data;
            end
        end else if (execution_done && can_write && (phase==2'b10)) begin
            phase <= 2'b11; //write permitted and execution done, so await write
        end else if (write_enable) begin
            phase <= 2'b00; //write enabled, so write
            execution_done <= 0;
        end
    end
    always @(posedge flush) begin //MAKE SURE TO FLUSH FROM DISPATCHER
        phase <= 0;
        o1 <= 0;
        o2 <= 0;
        execution_done <= 0;
    end
    initial begin
        phase <= 0;
        o1 <= 0;
        o2 <= 0;
        execution_done <= 0;
    end


endmodule