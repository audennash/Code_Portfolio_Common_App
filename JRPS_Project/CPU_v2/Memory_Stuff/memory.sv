module memory #(parameter width) (
    input [31:0] cpu_data,
    input [31:0] cpu_addr,
    input cpu_write,
    input cpu_req,
    input manual,
    input [31:0] man_data,
    input [31:0] man_addr,
    input man_write,
    input clk,
    input flush,
    input [31:0] portC,
    input [31:0] portD,
    output reg [31:0] mem_out,
    output mem_done,
    output [31:0] portA,
    output [31:0] portB);

    wire [31:0] data = manual? man_data : cpu_data;
    wire [31:0] addr = manual? man_addr : cpu_addr;
    wire write = manual? man_write : cpu_write;

    reg [31:0] memory_chip [width-1:0];
    assign portA = memory_chip[width-1];
    assign portB = memory_chip[width-2];

    reg mem_done_reset;
    reg mem_done_set;
    reg [31:0] mem_old_addr;
    assign mem_done = (~mem_done_reset) && (mem_old_addr==addr) && (cpu_req || manual) && mem_done_set;
    always @(posedge clk) begin
        mem_done_reset <= mem_done;
        if (write) begin
            memory_chip[addr] <= data;
        end
        memory_chip[width-3] <= portC;
        memory_chip[width-4] <= portD;
        mem_out <= #200 memory_chip[addr];
        mem_done_set <= #200 (cpu_req || manual); //this might look redundant but it's an old value
        mem_old_addr <= #200 addr;
    end
    always @(posedge flush) begin
        for (int i=0; i<width; i=i+1) begin
            memory_chip[i] <= 0;
        end
        mem_done_set <= 0;
        mem_done_reset <= 0;
    end
    initial begin
        for (int i=0; i<width; i=i+1) begin
            memory_chip[i] <= 0;
        end
        mem_done_set <= 0;
        mem_done_reset <= 0;
    end

endmodule