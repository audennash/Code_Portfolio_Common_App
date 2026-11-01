module top_module_icache();
    reg clk = 0;
    always #5 clk = ~clk;
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module);
        $finish;
    end
    reg [31:0] read_addr;
    reg [31:0] write_addr;
    reg [31:0] write_data;
    reg write;
    reg flush;
    wire data;
    wire hit;

    icache #(.width(32), .sets(8), .deg_assoc(4), .addr_width(32)) icache_test (read_addr, write_addr, write_data, write, flush, clk, data, hit);

endmodule

module icache #(parameter width=32, parameter sets=64, parameter deg_assoc = 2, parameter addr_width=2*deg_assoc*sets) (
    input [addr_width-1:0] read_addr, 
    input [addr_width-1:0] write_addr, //also used for prefetching
    input [width-1:0] write_data,
    input write,
    input flush,
    input clk,
    output [width-1:0] data, //returns data for instruction; guaranteed read_hit, will only result in a miss on stall, which can be checked through fetched_ahead and write_hit (hit)
    output inst_found,
    output hit); //only refers to hit for prefetch/write access lane
    localparam depth=deg_assoc*sets;

    genvar i;
    genvar j;
    genvar layer;
    genvar node;
    assign data = set_field[sets-1].running_sdata;
    assign inst_found = set_field[sets-1].running_seq;
    assign hit = set_field[sets-1].running_shit;
    generate //prefetch/write = p/w; read = r;
        for (i=0; i<sets; i=i+1) begin :  set_field //each set

            localparam [$clog2(sets)-1:0] set_id = i;
            //wire test_error = set_blocks[0].running_hit && (write_addr[$clog2(sets)-1:0] == set_id);
            wire set_hit = set_blocks[deg_assoc-1].running_hit && (write_addr[$clog2(sets)-1:0] == set_id); //determines if a hit occurs for p/w lane
            wire set_eq = set_blocks[deg_assoc-1].running_eq && (read_addr[$clog2(sets)-1:0] == set_id); //determines if a hit occurs for r lane
            wire [width-1:0] set_data = set_blocks[deg_assoc-1].running_data; //read data
            wire prior_rshit; //prior set p/w hit
            wire prior_rseq; //prior set r hit
            wire [width-1:0] prior_rsdata;
            wire running_shit = set_hit | prior_rshit; //running p/w hit
            wire running_seq = set_eq | prior_rseq; //running r hit
            wire [width-1:0] running_sdata = set_eq? set_data : prior_rsdata;
            if (i==0) begin //base case, avoid i-1=-1 error
                assign prior_rshit = set_hit;
                assign prior_rseq = set_eq;
                assign prior_rsdata = set_data;
            end else begin //regular look at prior set
                assign prior_rshit = set_field[i-1].running_shit;
                assign prior_rseq = set_field[i-1].running_seq;
                assign prior_rsdata = set_field[i-1].running_sdata;
            end

            for (j=0; j<deg_assoc; j=j+1) begin : set_blocks //each block inside a set
                reg [width-1:0] data_reg = flush; //stores data
                reg [addr_width-$clog2(sets)-1:0] tag; //stores tag (address bits of greater significance than set_id)
                reg valid; //did a hit occur?

                wire block_hit=(write_addr[addr_width-1:$clog2(sets)] == tag) & valid; //checks if tag equal to p/w addr and valid
                wire read_eq=(read_addr[addr_width-1:$clog2(sets)] == tag) & valid; //checks if tag equal to r addr and valid
                wire prior_rhit; //instantiates prior running data
                wire prior_req;
                wire [width-1:0] prior_rdata; 
                wire running_hit = block_hit | prior_rhit; //updates current running data
                wire running_eq = read_eq | prior_req;
                wire [width-1:0] running_data = read_eq? data_reg : prior_rdata;
                if (j==0) begin //recursively assigns prior running data
                    assign prior_rhit = block_hit;
                    assign prior_req = read_eq;
                    assign prior_rdata = data_reg;
                end else begin
                    assign prior_rhit = set_blocks[j-1].running_hit;
                    assign prior_req = set_blocks[j-1].running_eq;
                    assign prior_rdata = set_blocks[j-1].running_data;
                end 
                
                localparam path = j % 2;
                wire evict; //if true something should be evicted IF WRITE IS TRUE (i.e. update tag); IMPORTANT: WRITE SHOULD ONLY BE ON IF HIT IS TRUE in main IFU
                wire used = read_eq | block_hit | evict;
                wire correct_set = (write_addr[$clog2(sets)-1:0] == set_id);
                wire correct_tag = (write_addr[addr_width-1:$clog2(sets)]==tag);
                always_ff @(posedge clk) begin
                    if (write && correct_set && ((correct_tag && valid) || evict)) begin //if write: if address equal write and valid gets 1; if evict then tag updated too
                        data_reg <= write_data;
                        tag <= evict? write_addr[addr_width-1:$clog2(sets)] : tag;
                        valid <= 1;
                    end
                end
                always_ff @(posedge flush) begin //reset
                    data_reg <= 0;
                    tag <= 0;
                    valid <= 0;
                end
                initial begin //default reset at 0 
                    data_reg <= 0;
                    tag <= 0;
                    valid <= 0;
                end
                assign evict = tree_layers[$clog2(deg_assoc)-1].layer_nodes[j/2].node_evict & (tree_layers[$clog2(deg_assoc)-1].layer_nodes[j/2].lru_bit==path);
                assign tree_layers[$clog2(deg_assoc)-1].layer_nodes[j/2].subnode_used[path] = used;
            end

            for (layer=0; layer<$clog2(deg_assoc); layer=layer+1) begin : tree_layers
                for (node=0; node < (deg_assoc + 2**($clog2(deg_assoc)-layer) - 1) / (2 ** ($clog2(deg_assoc)-layer)); node=node+1) begin : layer_nodes
                    reg lru_bit;
                    wire [1:0] subnode_used;
                    wire node_evict;
                    always_ff @(posedge clk) begin
                        if (subnode_used[0]==1) begin
                            lru_bit <= 1;
                        end else if (subnode_used[1]==1) begin
                            lru_bit <= 0;
                        end
                    end
                    always_ff @(posedge flush) begin
                        lru_bit <= 0;
                    end
                    initial begin
                        lru_bit <= 0;
                    end
                    if (layer==0) begin
                        assign node_evict = ~set_hit;
                    end else begin
                        localparam path = node % 2;
                        wire evict_above = tree_layers[layer-1].layer_nodes[node/2].node_evict;
                        wire lru_above = tree_layers[layer-1].layer_nodes[node/2].lru_bit;
                        assign node_evict = evict_above & (lru_above==path);

                        assign tree_layers[layer-1].layer_nodes[node/2].subnode_used[path] = subnode_used[0] | subnode_used [1];
                    end
                end 
            end

        end
    endgenerate

endmodule