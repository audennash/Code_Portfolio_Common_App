module top_module_icache_tb_old();
    reg clk = 0;
    always #5 clk = ~clk;

    reg [31:0] read_addr;
    reg [31:0] write_addr;
    reg [31:0] write_data;
    reg write;
    reg flush;
    wire [31:0] data;
    wire eqeq;
    wire hit;
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module);
        
        //eviction testbench
        read_addr <= 4'b0000; write_addr <= 4'b0000; write_data <= 4'b0000; write <= 1; flush <= 0; //update
        #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
        write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

        read_addr <= 4'b0000; write_addr <= 4'b1000; write_data <= 4'b0001; write <= 1; flush <= 0; //update
        #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
        write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

        read_addr <= 4'b1000; write_addr <= 4'b1000; write_data <= 4'b1011; write <= 0; flush <= 0; //update
        #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
        write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

        read_addr <= 5'b10000; write_addr <= 5'b10000; write_data <= 4'b0010; write <= 1; flush <= 0; //update
        #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
        write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

        read_addr <= 5'b11000; write_addr <= 5'b11000; write_data <= 4'b0011; write <= 1; flush <= 0; //update
        #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
        write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);


        read_addr <= 5'b00000; write_addr <= 5'b00000; write_data <= 4'b0011; write <= 0; flush <= 0; //update
        #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
        write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

        read_addr <= 5'b01000; write_addr <= 5'b01000; write_data <= 4'b0011; write <= 0; flush <= 0; //update
        #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
        write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

        read_addr <= 5'b10000; write_addr <= 5'b10000; write_data <= 4'b0011; write <= 0; flush <= 0; //update
        #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
        write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

        read_addr <= 5'b11000; write_addr <= 5'b11000; write_data <= 4'b0011; write <= 0; flush <= 0; //update
        #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
        write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);
        //start the 27 thing
        read_addr <= 6'b111000; write_addr <= 6'b111000; write_data <= 5'b11011; write <= 1; flush <= 0; //update
        #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
        write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

        read_addr <= 6'b000000; write_addr <= 6'b000000; write_data <= 5'b11010; write <= 0; flush <= 0; //update
        #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
        write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

        read_addr <= 6'b010000; write_addr <= 6'b010000; write_data <= 5'b11110; write <= 0; flush <= 0; //update
        #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
        write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

        read_addr <= 6'b101000; write_addr <= 6'b101000; write_data <= 5'b10001; write <= 1; flush <= 0; //update
        #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
        write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

        read_addr <= 6'b011000; write_addr <= 6'b011000; write_data <= 5'b11010; write <= 0; flush <= 0; //update
        #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
        write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

        $finish;
    end

    
    icache_old #(.width(32), .sets(8), .deg_assoc(4), .addr_width(32)) icache_test (read_addr, write_addr, write_data, write, flush, clk, data,eqeq,hit);
endmodule

/*
read_addr:          0; write_addr:          0; write_data:          0; write: 1; flush: 0; data:          0; hit: 1
read_addr:          0; write_addr:          8; write_data:          1; write: 1; flush: 0; data:          0; hit: 1
read_addr:          8; write_addr:          8; write_data:         11; write: 0; flush: 0; data:          1; hit: 1
read_addr:         16; write_addr:         16; write_data:          2; write: 1; flush: 0; data:          2; hit: 1
read_addr:         24; write_addr:         24; write_data:          3; write: 1; flush: 0; data:          3; hit: 1
read_addr:          0; write_addr:          0; write_data:          3; write: 0; flush: 0; data:          0; hit: 1
read_addr:          8; write_addr:          8; write_data:          3; write: 0; flush: 0; data:          1; hit: 1
read_addr:         16; write_addr:         16; write_data:          3; write: 0; flush: 0; data:          2; hit: 1
read_addr:         24; write_addr:         24; write_data:          3; write: 0; flush: 0; data:          3; hit: 1
read_addr:         56; write_addr:         56; write_data:         27; write: 1; flush: 0; data:         27; hit: 1
read_addr:          0; write_addr:          0; write_data:         26; write: 0; flush: 0; data:         27; hit: 0
read_addr:         16; write_addr:         16; write_data:         30; write: 0; flush: 0; data:          2; hit: 1
read_addr:         40; write_addr:         40; write_data:         17; write: 1; flush: 0; data:         17; hit: 1
read_addr:         24; write_addr:         24; write_data:         26; write: 0; flush: 0; data:         27; hit: 0
*/
/*
    //read/write testbench
    read_addr <= 0; write_addr <= 0; write_data <= 0; write <= 0; flush <= 0; //update
    #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
    write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

    read_addr <= 0; write_addr <= 0; write_data <= 4'b1111; write <= 0; flush <= 0; //update
    #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
    write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

    read_addr <= 0; write_addr <= 0; write_data <= 4'b1111; write <= 1; flush <= 0; //update
    #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
    write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

    read_addr <= 0; write_addr <= 0; write_data <= 0; write <= 0; flush <= 0; //update
    #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
    write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

    read_addr <= 0; write_addr <= 4'b1010; write_data <= 4'b0101; write <= 1; flush <= 0; //update
    #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
    write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

    read_addr <= 4'b1010; write_addr <= 4'b1010; write_data <= 4'b0011; write <= 0; flush <= 0; //update
    #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
    write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

    read_addr <= 4'b1010; write_addr <= 4'b1110; write_data <= 4'b0011; write <= 0; flush <= 0; //update
    #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
    write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

    read_addr <= 4'b0000; write_addr <= 4'b1110; write_data <= 4'b0011; write <= 0; flush <= 0; //update
    #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
    write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

    read_addr <= 4'b0000; write_addr <= 4'b1110; write_data <= 4'b0011; write <= 0; flush <= 1; //update
    #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
    write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

    read_addr <= 4'b1010; write_addr <= 4'b1110; write_data <= 4'b0011; write <= 0; flush <= 0; //update
    #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
    write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

    read_addr <= 4'b1110; write_addr <= 4'b1110; write_data <= 4'b0011; write <= 0; flush <= 0; //update
    #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
    write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);
*/
/*
    //eviction testbench
    read_addr <= 4'b0000; write_addr <= 4'b0000; write_data <= 4'b0000; write <= 1; flush <= 0; //update
    #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
    write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

    read_addr <= 4'b0000; write_addr <= 4'b1000; write_data <= 4'b0001; write <= 1; flush <= 0; //update
    #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
    write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

    read_addr <= 4'b1000; write_addr <= 4'b1000; write_data <= 4'b1011; write <= 0; flush <= 0; //update
    #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
    write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

    read_addr <= 5'b10000; write_addr <= 5'b10000; write_data <= 4'b0010; write <= 1; flush <= 0; //update
    #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
    write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

    read_addr <= 5'b11000; write_addr <= 5'b11000; write_data <= 4'b0011; write <= 1; flush <= 0; //update
    #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
    write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);


    read_addr <= 5'b00000; write_addr <= 5'b00000; write_data <= 4'b0011; write <= 0; flush <= 0; //update
    #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
    write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

    read_addr <= 5'b01000; write_addr <= 5'b01000; write_data <= 4'b0011; write <= 0; flush <= 0; //update
    #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
    write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

    read_addr <= 5'b10000; write_addr <= 5'b10000; write_data <= 4'b0011; write <= 0; flush <= 0; //update
    #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
    write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

    read_addr <= 5'b11000; write_addr <= 5'b11000; write_data <= 4'b0011; write <= 0; flush <= 0; //update
    #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
    write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);
    //start the 27 thing
    read_addr <= 6'b111000; write_addr <= 6'b111000; write_data <= 5'b11011; write <= 1; flush <= 0; //update
    #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
    write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

    read_addr <= 6'b000000; write_addr <= 6'b000000; write_data <= 5'b11010; write <= 0; flush <= 0; //update
    #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
    write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

    read_addr <= 6'b010000; write_addr <= 6'b010000; write_data <= 5'b11110; write <= 0; flush <= 0; //update
    #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
    write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

    read_addr <= 6'b101000; write_addr <= 6'b101000; write_data <= 5'b10001; write <= 1; flush <= 0; //update
    #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
    write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);

    read_addr <= 6'b011000; write_addr <= 6'b011000; write_data <= 5'b11010; write <= 0; flush <= 0; //update
    #10; $display("read_addr: ", read_addr, "; write_addr: ", write_addr, "; write_data: ", write_data, "; write: ", 
    write, "; flush: ", flush, "; data: ", data, "; hit: ", hit);
*/