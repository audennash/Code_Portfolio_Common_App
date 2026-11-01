module top_module_dcache_old();
    reg clk = 0;
    always #5 clk = ~clk;
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module);
        $finish;
    end
    reg [31:0] addr;
    reg [31:0] data_in;
    reg write;
    reg flush;
    wire [31:0] data_out;
    wire hit;

    dcache_old #(.width(32), .sets(32), .deg_assoc(4), .addr_width(32)) dcache_test (data_in, addr, write, flush, clk, data_out, hit);

endmodule

module dcache_old #(parameter width=32, parameter sets=64, parameter deg_assoc=2, parameter addr_width=2*deg_assoc*sets) (
    input [width-1:0] data_in,
    input [addr_width-1:0] addr,
    input load,
    input write,
    input flush,
    input clk,
    output [width-1:0] data_out, 
    output hit,
    output dirty_evict, //de for short
    output [addr_width-1:0] de_addr,
    output [width-1:0] de_data); 
    localparam depth=deg_assoc*sets;
    localparam setmax = $clog2(sets);
    localparam degmax = $clog2(deg_assoc);

    genvar i;
    genvar j;
    genvar layer;
    genvar node;
    assign data_out = set_field[sets-1].running_data;
    assign hit = set_field[sets-1].running_hit;
    assign dirty_evict = set_field[sets-1].running_de;
    assign de_addr = set_field[sets-1].running_de_addr;
    assign de_data = set_field[sets-1].running_de_data;

    generate
        for (i=0; i<sets; i=i+1) begin : set_field
            localparam [setmax-1:0] set_id = i;
            wire correct_set = (addr[setmax-1:0] == set_id);
            wire set_hit = set_blocks[deg_assoc-1].running_hit && (addr[setmax-1:0] == set_id);
            wire [width-1:0] set_data = set_blocks[deg_assoc-1].running_data;
            wire set_de = set_blocks[deg_assoc-1].running_de;
            wire [addr_width-1:0] set_de_addr = set_blocks[deg_assoc-1].running_de_addr;
            wire [width-1:0] set_de_data = set_blocks[deg_assoc-1].running_de_data;

            wire prior_hit;
            wire [width-1:0] prior_data;
            wire prior_de;
            wire [addr_width-1:0] prior_de_addr;
            wire [width-1:0] prior_de_data;
            wire running_hit = set_hit | prior_hit;
            wire [width-1:0] running_data = set_hit? set_data : prior_data;
            wire running_de = set_de | prior_de;
            wire [addr_width-1:0] running_de_addr = set_de? set_de_addr : prior_de_addr;
            wire [width-1:0] running_de_data = set_de? set_de_data : prior_de_data;
            
            if (i==0) begin
                assign prior_hit = set_hit;
                assign prior_data = set_data;
                assign prior_de = set_de;
                assign prior_de_addr = set_de_addr;
                assign prior_de_data = set_de_data;
            end else begin
                assign prior_hit = set_field[i-1].running_hit;
                assign prior_data = set_field[i-1].running_data;
                assign prior_de = set_field[i-1].running_de;
                assign prior_de_addr = set_field[i-1].running_de_addr;
                assign prior_de_data = set_field[i-1].running_de_data;
            end

            for (j=0; j<deg_assoc; j=j+1) begin: set_blocks
                localparam path = j%2;
                reg [width-1:0] data_reg = 0;
                reg [addr_width-setmax-1:0] tag;
                reg valid;
                reg dirty;
                wire block_hit = (addr[addr_width-1:setmax] == tag) & valid;
                

                wire evict;
                wire used = hit | evict;
                
                wire block_de = evict && dirty;
                wire [addr_width-1:0] block_de_addr = {tag, set_id};
                wire [width-1:0] block_de_data = data_reg;

                wire prior_hit;
                wire [width-1:0] prior_data;
                wire prior_de;
                wire [addr_width-1:0] prior_de_addr;
                wire [width-1:0] prior_de_data;
                wire running_hit = block_hit | prior_hit;
                wire [width-1:0] running_data = block_hit? data_reg : prior_data;
                wire running_de = block_de | prior_de;
                wire [addr_width-1:0] running_de_addr = block_de? block_de_addr : prior_de_addr;
                wire [width-1:0] running_de_data = block_de? block_de_data : prior_de_data;

                if (j==0) begin
                    assign prior_hit = block_hit;
                    assign prior_data = data_reg;
                    assign prior_de = block_de;
                    assign prior_de_addr = block_de_addr;
                    assign prior_de_data = block_de_data;
                end else begin
                    assign prior_hit = set_blocks[j-1].running_hit;
                    assign prior_data = set_blocks[j-1].running_data;
                    assign prior_de = set_blocks[j-1].running_de;
                    assign prior_de_addr = set_blocks[j-1].running_de_addr;
                    assign prior_de_data = set_blocks[j-1].running_de_data;
                end

                always_ff @(posedge clk) begin
                    if (write && correct_set && (block_hit || evict)) begin
                        data_reg <= data_in;
                        tag <= evict? addr[addr_width-1:setmax] : tag;
                        valid <= 1;
                        dirty <= ~load;
                    end
                end
                always_ff @(posedge flush) begin
                    data_reg <= 0;
                    tag <= 0;
                    valid <= 0;
                    dirty <= 0;
                end
                initial begin
                    data_reg <= 0;
                    tag <= 0;
                    valid <= 0;
                    dirty <= 0;
                end

                assign evict = tree_layers[degmax-1].layer_nodes[j/2].node_evict & (tree_layers[degmax-1].layer_nodes[j/2].lru_bit == path);
                assign tree_layers[degmax-1].layer_nodes[j/2].subnode_used[path] = used;
                
            end

            for (layer=0; layer<degmax; layer=layer+1) begin: tree_layers
                for (node=0; node < (deg_assoc + 2**(degmax-layer) - 1)/(2 ** (degmax-layer) ); node=node+1 ) begin: layer_nodes //ceil(a/b) = (a+b-1)/(b)
                    localparam path = node%2;
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
                        wire evict_above = tree_layers[layer-1].layer_nodes[node/2].node_evict;
                        wire lru_above = tree_layers[layer-1].layer_nodes[node/2].lru_bit;
                        assign node_evict = evict_above & (lru_above==path);
                        assign tree_layers[layer-1].layer_nodes[node/2].subnode_used[path] = subnode_used[0] | subnode_used[1];
                    end
                end
            end

        end
    endgenerate
endmodule