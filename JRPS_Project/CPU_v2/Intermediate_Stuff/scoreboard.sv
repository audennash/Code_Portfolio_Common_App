module scoreboard #(parameter fu_count) (//fu_count has to be one more than actual fus, i.e. it should include nop fu
    input [4:0] decode_rreg1,
    input [4:0] decode_rreg2,
    input [4:0] decode_wreg,
    input [$clog2(fu_count)-1:0] issue_fu,
    input issue_stall,
    input [1:0] fu_phase [fu_count-1:0],
    input [4:0] dr [fu_count-1:0],
    input run,
    input flush,
    input clk,
    output [fu_count-1:0] can_read,
    output [fu_count-1:0] can_write,
    output [fu_count-1:0] read_enable,
    output [fu_count-1:0] write_enable,
    output reg [fu_count-1:0] active);

    localparam fs = $clog2(fu_count); //number of fu bits
    reg [fs-1:0] reg_writer [31:0];
    reg [31:0] reg_written;

    wire [fu_count-1:0] read_req;
    wire [fu_count-1:0] write_req;

    reg [fu_count-1:0] RAW_grid [fu_count-1:0];
    reg [fu_count-1:0] RAW_grid_tr [fu_count-1:0];
    reg [fu_count-1:0] WAW_grid [fu_count-1:0];
    reg [fu_count-1:0] WAR_grid [fu_count-1:0];


    genvar i;
    generate
        for (i=0; i<fu_count; i=i+1) begin
            assign read_req[i] = (fu_phase[i] == 2'b01);
            assign write_req[i] = (fu_phase[i] == 2'b11);
            assign can_read[i] = ~(|RAW_grid[i]) && active[i];
            assign can_write[i] = ( ~(|WAW_grid[i]) ) && ( ~(|WAR_grid[i]) );
        end
    endgenerate
    arbiter_core #(fu_count) read_arbiter(read_req, clk, read_enable);
    arbiter_core #(fu_count) write_arbiter (write_req, clk, write_enable);

    wire [fs-1:0] s1f = reg_writer[decode_rreg1];
    wire [fs-1:0] s2f = reg_writer[decode_rreg2];
    wire [fs-1:0] df = reg_writer[decode_wreg];

    always @(posedge clk) begin
        for (int i=0; i<fu_count; i=i+1) begin
            if (active[i]) begin
                RAW_grid[i] <= (~write_enable) & RAW_grid[i];
                RAW_grid_tr[i] <= read_enable[i]? {(fu_count){1'b0}} : RAW_grid_tr[i];
                WAR_grid[i] <= (~read_enable) & WAR_grid[i];
                WAW_grid[i] <= (~write_enable) & WAW_grid[i];
                active[i] <= write_enable[i]? 0 : active[i];
                if (write_enable[i]) begin
                    reg_written[dr[i]] <= 1;
                end
            end
            if ((i == issue_fu) && (~issue_stall)) begin
                //$display("instruction issued");
                if (s1f == s2f) begin
                    RAW_grid[i][s1f] <= (~reg_written[decode_rreg1] || ~reg_written[decode_rreg2]) && (~write_enable[s1f]);
                    RAW_grid_tr[i][s1f] <= 1;
                end else begin
                    RAW_grid[i][s1f] <= ~reg_written[decode_rreg1] && (~write_enable[s1f]);
                    RAW_grid[i][s2f] <= ~reg_written[decode_rreg2] && (~write_enable[s2f]);
                    RAW_grid_tr[i][s1f] <= 1;
                    RAW_grid_tr[i][s2f] <= 1;
                end
                WAW_grid[i][df] <= ~reg_written[decode_wreg] && (~write_enable[df]);
                for (int j=0; j<fu_count; j=j+1) begin
                    WAR_grid[i][j] <= RAW_grid_tr[j][df] && (~read_enable[j]) && (j != 0);
                end
                reg_writer[decode_wreg] <= issue_fu;
                reg_written[decode_wreg] <= (decode_wreg == 0);
                active[i] <= 1;
            end
        end
    end
    always @(posedge flush) begin
        for (int i=0; i<fu_count; i=i+1) begin
            RAW_grid[i] <= 0;
            RAW_grid_tr[i] <= 0;
            WAW_grid[i] <= 0;
            WAR_grid[i] <= 0;
        end
        for (int i=0; i<32; i=i+1) begin
            reg_writer[i] <= 0;
            reg_written[i] <= 1;
        end
        active <= 0;
    end
    initial begin
        for (int i=0; i<fu_count; i=i+1) begin
            RAW_grid[i] <= 0;
            RAW_grid_tr[i] <= 0;
            WAW_grid[i] <= 0;
            WAR_grid[i] <= 0;
        end
        for (int i=0; i<32; i=i+1) begin
            reg_writer[i] <= 0;
            reg_written[i] <= 1;
        end
        active <= 0;
    end
endmodule