module ifu #(parameter inst_width, parameter mem_depth, parameter cache_size) (
    input branch_coming,
    input branch_inst_set,
    input [$clog2(mem_depth)-1:0] branch_addr,
    input branch_taken,
    input mi_req,
    input [inst_width-1:0] d_data,
    input [$clog2(mem_depth)-1:0] d_addr,
    input d_write,
    input [inst_width-1:0] d_out,
    input req_completed,
    input issue_stall,
    input run,
    input flush,
    input clk,
    output [$clog2(mem_depth)-1:0] i_addr,
    output reg i_req,
    output [inst_width-1:0] inst,
    output stall);

    localparam addr_width = $clog2(mem_depth);

    reg branch_inst_reg;
    wire branch_inst = branch_inst_reg;

    reg [addr_width-1:0] pc;
    //wire [addr_width-1:0] pc_ncnj = (stall || issue_stall)? pc : pc+1; //pc next cycle no jump
    wire [addr_width-1:0] next_pc = branch_taken? branch_addr : pc+1;

    wire [addr_width-1:0] i_addr_nonstall = branch_inst? branch_addr : pc+1;
    assign i_addr = stall? pc : i_addr_nonstall;
    wire [addr_width-1:0] check_availability = d_write? d_addr : i_addr;

    wire hit;
    wire i_needed;

    wire inst_found;
    assign stall = ~inst_found;

    always @(posedge clk) begin
        i_req <= (~mi_req || req_completed || i_req) && (i_needed || (i_req && req_completed));
        branch_inst_reg <= branch_inst_set? 1 : (branch_inst_reg && ~inst_found);
    end

    assign i_needed = ((~hit && (~mi_req)) || stall) && run;
    wire store_output = (i_req && ((branch_inst==branch_taken) || stall) && req_completed) || (hit && d_write && ~i_req);
    wire [inst_width-1:0] icache_newdata = d_write? d_data : d_out;

    
    
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
        pc <= (run && ~stall && ~(issue_stall && ~branch_inst_reg) && ~(branch_coming && ~branch_inst_reg))? next_pc: pc;
    end
    initial begin
        pc <= 0;
        i_req <= 0;
        branch_inst_reg <= 0;
    end
    always @(posedge flush) begin
        pc <= 0;
        i_req <= 0;
        branch_inst_reg <= 0;
    end

endmodule