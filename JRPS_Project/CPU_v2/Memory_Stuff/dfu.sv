module dfu #(parameter data_width, parameter mem_depth, parameter cache_size, parameter first_port = 252) (
    input exec,
    input [data_width-1:0] data_in,
    input [$clog2(mem_depth)-1:0] addr_in,
    input write_in,
    input [data_width-1:0] mem_out,
    input mem_done,
    input i_req,
    input run,
    input flush,
    input clk,
    output [data_width-1:0] data_out,
    output req_completed,
    output d_req,
    output [data_width-1:0] d_data,
    output [$clog2(mem_depth)-1:0] d_addr,
    output d_write);

    localparam addr_width = $clog2(mem_depth);

    localparam portA = first_port + 3;
    localparam portB = first_port + 2;
    localparam portC = first_port + 1;
    localparam portD = first_port;
    wire not_a_port = (addr_in != portA) && (addr_in != portB) && (addr_in != portC) && (addr_in != portD);
    wire hit_before_port;

    wire hit = hit_before_port && not_a_port;
    
    wire dirty_evict;
    wire [data_width-1:0] de_addr;
    wire [data_width-1:0] de_data;
    
    reg wb_done;
    reg wd_for_port;
    reg de_ongoing;
    reg [31:0] de_addr_reg;
    reg [31:0] de_data_reg;
    always @(posedge clk) begin
        wb_done <= wb_done? ~((dirty_evict && ~de_ongoing) || (~not_a_port && ~wd_for_port)) : mem_done; //look here NOTAPORT TOO
        de_addr_reg <= dirty_evict? de_addr : de_addr_reg;
        de_data_reg <= dirty_evict? de_data : de_data_reg;
        de_ongoing <= req_completed? 0 : (dirty_evict);
        wd_for_port <= (exec && ~i_req)? (req_completed || (~wb_done && mem_done)) : 0;
    end
    initial begin
        wb_done <= 1;
        de_ongoing <= 0;
        wd_for_port <= 0;
        de_addr_reg <= 0;
        de_data_reg <= 0;
    end
    always @(posedge flush) begin
        wb_done <= 1;
        de_ongoing <= 0;
        wd_for_port <= 0;
        de_addr_reg <= 0;
        de_data_reg <= 0;
    end

    assign req_completed = wb_done && (hit || (mem_done && i_req) || (de_ongoing) || (~not_a_port && wd_for_port)); //works because wb_done will be updated at the same time that mem_done is turned off
    assign d_req = (~hit && ~write_in && exec) || (~wb_done);
    assign d_data = (~wb_done && not_a_port)? de_data_reg : data_in;
    assign d_addr = (~wb_done && not_a_port)? de_addr_reg : addr_in;
    assign d_write = (~wb_done && exec);

    wire store_mem_output = d_req && mem_done && wb_done;
    wire write_cache = store_mem_output || (write_in);
    wire [data_width-1:0] new_cache_data = write_in? data_in : mem_out;
    wire load = ~hit & ~write_in;

    wire [data_width-1:0] cache_out;
    assign data_out = ((i_req && ~hit) || (~not_a_port))? mem_out : cache_out;
    dcache #(.width(data_width), .sets(cache_size/4), .deg_assoc(4), .addr_width(addr_width)) data_cache (
        .data_in(new_cache_data),
        .addr(addr_in),
        .load(load),
        .write(write_cache),
        .no_evict(i_req),
        .flush(flush),
        .clk(clk),
        .data_out(cache_out),
        .hit(hit_before_port),
        .dirty_evict(dirty_evict),
        .de_addr(de_addr),
        .de_data(de_data)
    );

endmodule