module dfu_old #(parameter data_width, parameter mem_depth, parameter cache_size) (
    input mi_exec, //mi = memory instruction
    input [data_width-1:0] mi_data,
    input [$clog2(mem_depth)-1:0] mi_addr,
    input mi_write,
    input [data_width-1:0] mem_out,
    input mem_done,
    input choose_i,
    input run,
    input flush,
    input clk,
    output [data_width-1:0] mi_resp,
    output req_completed,
    output d_req,
    output [data_width-1:0] d_data,
    output [$clog2(mem_depth)-1:0] d_addr,
    output d_write);

    localparam addr_width = $clog2(mem_depth);

    wire hit;
    wire dirty_evict;
    wire [data_width-1:0] de_addr;
    wire [data_width-1:0] de_data;

    assign req_completed = (d_req && ~choose_i) ? mem_done : hit;
    
    assign d_req = (~hit && ~mi_write && mi_exec) || dirty_evict;
    assign d_data = dirty_evict? de_data : mi_data;
    assign d_addr = dirty_evict? de_addr : mi_addr;
    assign d_write = dirty_evict;

    wire store_mem_output = (~choose_i) && d_req && mem_done;
    wire write_cache = store_mem_output || mi_write;
    wire [data_width-1:0] new_cache_data = mi_write? mi_data : mem_out;
    wire load = ~hit & ~mi_write;


    dcache_old #(.width(data_width), .sets(cache_size/4), .deg_assoc(4), .addr_width(addr_width)) data_cache (
        .data_in(new_cache_data),
        .addr(mi_addr),
        .load(load),
        .write(write_cache),
        .flush(flush),
        .clk(clk),
        .data_out(mi_resp),
        .hit(hit),
        .dirty_evict(dirty_evict),
        .de_addr(de_addr),
        .de_data(de_data)
    );

endmodule