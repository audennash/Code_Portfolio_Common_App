module ifu_old #(parameter inst_width, parameter mem_depth, parameter cache_size, parameter pf_window) (
    input branch_inst,
    input [$clog2(mem_depth)-1:0] branch_addr,
    input branch_taken,
    input d_req,
    input [$clog2(mem_depth)-1:0] d_addr,
    input d_write,
    input [inst_width-1:0] mem_out,
    input run,
    input stall,
    input flush,
    input clk,
    output [$clog2(mem_depth)-1:0] i_addr,
    output choose_i,
    output [inst_width-1:0] next_inst,
    output next_stall);

    localparam addr_width = $clog2(mem_depth);
    reg [addr_width-1:0] pc;
    reg [addr_width-1:0] fetched_ahead;

    

    assign i_addr = branch_inst? branch_addr : fetched_ahead + 1;
    wire [addr_width-1:0] check_availability = d_write? d_addr : i_addr;

    wire hit;
    wire i_req = (fetched_ahead != pc+pf_window || branch_inst) && (~hit);
    assign choose_i = ((i_req && (~d_req)) || stall) && run;
    wire store_output = (choose_i || (hit && d_write)) && (branch_inst==branch_taken);
    
    icache #(.width(inst_width), .sets(cache_size/4), .deg_assoc(4), .addr_width(addr_width)) inst_cache (
        .read_addr(pc),
        .write_addr(check_availability),
        .write_data(mem_out),
        .write(store_output),
        .flush(flush),
        .clk(clk),
        .data(next_inst),
        .hit(hit)
    );

    wire [addr_width-1:0] next_pc = branch_taken? branch_addr : pc+1;
    wire [addr_width-1:0] next_fa = (choose_i && (~branch_inst))? fetched_ahead+1 : fetched_ahead;
    assign next_stall = (pc == fetched_ahead) && (~choose_i); //shouldn't take effect until next clock cycle
    always @(posedge clk) begin
        pc <= next_stall? pc : next_pc;
        fetched_ahead <= branch_taken? branch_addr : next_fa;
    end
    initial begin
        pc <= 0;
        fetched_ahead <= 0;
    end
    always @(posedge flush) begin
        pc <= 0;
        fetched_ahead <= 0;
    end


endmodule