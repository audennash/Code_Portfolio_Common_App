module ifu #(parameter inst_width, parameter mem_depth, parameter cache_size) (
    input branch_inst,
    input [$clog2(mem_depth)-1:0] branch_addr,
    input branch_taken,
    input d_req,
    input [inst_width-1:0] d_data,
    input [$clog2(mem_depth)-1:0] d_addr,
    input d_write,
    input [inst_width-1:0] mem_out,
    input run,
    input flush,
    input clk,
    output [$clog2(mem_depth)-1:0] i_addr,
    output choose_i,
    output [inst_width-1:0] inst,
    output stall);

    localparam addr_width = $clog2(mem_depth);

    reg [addr_width-1:0] pc;
    wire [addr_width-1:0] pc_ncnj = stall? pc : pc+1; //pc next cycle no jump
    wire [addr_width-1:0] next_pc = branch_taken? branch_addr : pc_ncnj;

    wire [addr_width-1:0] i_addr_nonstall = branch_inst? branch_addr : pc_ncnj;
    assign i_addr = stall? pc : i_addr_nonstall;
    wire [addr_width-1:0] check_availability = d_write? d_addr : i_addr;

    wire hit;
    assign choose_i = (((~hit) && (~d_req)) || stall) && run;
    wire store_output = (choose_i || (hit && d_write)) && (branch_inst==branch_taken || stall);
    wire [inst_width-1:0] icache_newdata = d_write? d_data : mem_out;

    wire inst_found;
    assign stall = ~inst_found;
    
    icache #(.width(inst_width), .sets(cache_size/4), .deg_assoc(4), .addr_width(addr_width)) inst_cache (
        .read_addr(pc),
        .write_addr(check_availability),
        .write_data(icache_newdata),
        .write(store_output),
        .flush(flush),
        .clk(clk),
        .data(inst),
        .inst_found(inst_found),
        .hit(hit)
    );

    always @(posedge clk) begin
        pc <= (run && ~stall)? next_pc: pc;
    end
    initial begin
        pc <= 0;
    end
    always @(posedge flush) begin
        pc <= 0;
    end

endmodule