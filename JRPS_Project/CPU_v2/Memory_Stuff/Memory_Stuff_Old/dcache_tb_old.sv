module top_module_dcache_tb_old(); // not working, make changes before running
    reg clk = 0;
    always #5 clk = ~clk;

    reg [31:0] data_in;
    reg [31:0] addr;
    reg write;
    reg flush;
    wire [31:0] data_out;
    wire hit;
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module);
        

        $display("MAKE SURE NO ACTIVE VALUES"); //green to mark
        data_in <= 0; addr <= 0; write <= 0; flush <= 0;
        #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);

        data_in <= 0; addr <= 12; write <= 0; flush <= 0;
        #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);


        $display("BASIC WRITE TEST"); //green to mark
        data_in <= 11; addr <= 1; write <= 1; flush <= 0;
        #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);

        data_in <= 12; addr <= 1; write <= 0; flush <= 0;
        #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);

        data_in <= 12; addr <= 0; write <= 0; flush <= 0;
        #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);

        data_in <= 10; addr <= 0; write <= 1; flush <= 0;
        #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);

        data_in <= 10; addr <= 1; write <= 0; flush <= 0;
        #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);

        data_in <= 99; addr <= 1; write <= 1; flush <= 0;
        #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);


        $display("EVICTION TEST (SHOULD EVICT)"); //green to mark
        write <= 0; data_in <= 1; #10; write <= 1;
        for (int i=0; i<4; i=i+1) begin
            addr <= addr+32;
            #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);
            data_in <= data_in+1;
        end

        addr <= 1; write <= 0; 
        #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);

        addr <= 33;
        #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);

        addr <= 161; write <= 1;
        #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);

        addr <= 33; write <= 0;
        #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);


        $display("EVICTION TEST (SHOULD NOT EVICT)"); //green to mark
        addr <= 66; data_in <= 8; write <= 1;
        #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);

        addr <= 129; write <= 0;
        #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);

        addr <= 97;
        #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);
        
        addr <= 65;
        #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);


        $display("FLUSH TEST"); //green to mark
        flush <= 1; #10;

        addr <= 66;
        #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);

        addr <= 0;
        #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);

        addr <= 97;
        #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);
        
        addr <= 65;
        #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);

        addr <= 66; data_in <= 8; write <= 1;
        #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);

        $display("DIFFERENT SET TEST");
        data_in <= 11; addr <= 9; write <= 1; flush <= 0;
        #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);

        data_in <= 12; addr <= 9; write <= 0; flush <= 0;
        #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);

        data_in <= 12; addr <= 8; write <= 0; flush <= 0;
        #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);

        data_in <= 10; addr <= 8; write <= 1; flush <= 0;
        #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);

        data_in <= 10; addr <= 9; write <= 0; flush <= 0;
        #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);

        data_in <= 99; addr <= 9; write <= 1; flush <= 0;
        #10; $display("data_in: ", data_in, "; addr: ", addr, "; write: ", write, "; flush: ", flush, " ||| data_out: ", data_out, "; hit: ", hit);
        $finish; 
    end
    wire load = 1;
    dcache_old #(.width(32), .sets(32), .deg_assoc(4), .addr_width(32)) dcache_test (data_in, addr, load, write, flush, clk, data_out, hit);
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