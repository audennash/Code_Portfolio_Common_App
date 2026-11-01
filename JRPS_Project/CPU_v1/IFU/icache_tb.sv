module top_module_icache_tb();
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

    
    icache #(.width(32), .sets(8), .deg_assoc(4), .addr_width(32)) icache_test (read_addr, write_addr, write_data, write, flush, clk, data,eqeq,hit);
endmodule


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