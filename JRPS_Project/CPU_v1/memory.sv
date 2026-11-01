module memory #(parameter width) (
    input [31:0] cpu_data,
    input [31:0] cpu_addr,
    input cpu_write,
    input manual,
    input [31:0] man_data,
    input [31:0] man_addr,
    input man_write,
    input clk,
    input flush,
    input [31:0] portC,
    input [31:0] portD,
    output [31:0] mem_out,
    output [31:0] portA,
    output [31:0] portB);

    wire [31:0] data = manual? man_data : cpu_data;
    wire [31:0] addr = manual? man_addr : cpu_addr;
    wire write = manual? man_write : cpu_write;

    reg [31:0] memory_chip [width-1:0];
    assign mem_out = memory_chip[addr];
    assign portA = memory_chip[width-1];
    assign portB = memory_chip[width-2];

    always @(posedge clk) begin
        if (write) begin
            memory_chip[addr] <= data;
        end
        memory_chip[width-3] <= portC;
        memory_chip[width-4] <= portD;
    end
    always @(posedge flush) begin
        for (int i=0; i<width; i=i+1) begin
            memory_chip[i] <= 0;
        end
    end

endmodule