module top_module ();
    reg clk=0;
	always #5 clk = ~clk;

    reg [4:0] decode_rreg1;
    reg [4:0] decode_rreg2;
    reg [4:0] decode_wreg;
    reg [3:0] issue_fu;
    reg fetch_stall;
    reg [1:0] fu_phase [9:0];
    reg run;
    reg flush;

    reg [4:0] dr [9:0];
    wire [9:0] can_read;
    wire [9:0] can_write;
    wire [9:0] read_enable;
    wire [9:0] write_enable;
    wire [9:0] active;
    
    reg [9:0] execution_done;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module);

        for (int i=0; i<10; i=i+1) begin
            fu_phase[i] <= 2'b00;
            execution_done[i] <= 0;
        end
        
        #10; $display("PRINTOUT 1"); print_sb();
        run <= 1; 
        //to issue to FU i: issue_fu <= i; fetch_stall <= 0; decode_rreg1 <= rr1; decode_rreg2 <= rr2; decode_wreg <= wr; 
        //to complete inst: execution_done[i] <= (fu_phase[i] == 2'b10);
        //to non-issue: fetch_stall <= 1;

        $display("BASIC RAW EXECUTION STALL TEST");
        issue_fu <= 5; fetch_stall <= 0; decode_rreg1 <= 1; decode_rreg2 <= 2; decode_wreg <= 3; //for p2
        #10; $display("PRINTOUT 2"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active); 
        decode_rreg1 <= 3; decode_rreg2 <= 4; decode_wreg <= 6; issue_fu = 7; //for p4
        #10; $display("PRINTOUT 4"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);
        fetch_stall <= 1; //for p5
        #10; $display("PRINTOUT 5"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);  
        execution_done[5] <= (fu_phase[5] == 2'b10); //for p6
        #10; $display("PRINTOUT 6"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);
        execution_done[7] <= (fu_phase[7] == 2'b10); //for p7
        #10; $display("PRINTOUT 7"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);
        execution_done[7] <= (fu_phase[7] == 2'b10); //for p8
        #10; $display("PRINTOUT 8"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);
        execution_done[7] <= (fu_phase[7] == 2'b10); //for p9
        #10; $display("PRINTOUT 9"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);
        execution_done[7] <= (fu_phase[7] == 2'b10); //for p10
        #10; $display("PRINTOUT 10"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);
        #10; $display("PRINTOUT 11"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);

        $display("BASIC WAW TEST");
        issue_fu <= 2; fetch_stall <= 0; decode_rreg1 <= 1; decode_rreg2 <= 2; decode_wreg <= 3; //for p12
        //$display("for p12 w written: %b", scoreboard_test.reg_written);
        #10; $display("PRINTOUT 12"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);
        issue_fu <= 4; fetch_stall <= 0; decode_rreg1 <= 4; decode_rreg2 <= 5; decode_wreg <= 3; //for p13
        //$display("for p13 w written: %b", scoreboard_test.reg_written);
        #10; $display("PRINTOUT 13"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);
        fetch_stall <= 1; //for p14
        #10; $display("PRINTOUT 14"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);
        execution_done[2] <= (fu_phase[2] == 2'b10 && (execution_done[4] == 1)); execution_done[4] <= (fu_phase[4] == 2'b10); //for p15
        #10; $display("PRINTOUT 15"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);
        execution_done[2] <= (fu_phase[2] == 2'b10 && (execution_done[4] == 1)); execution_done[4] <= (fu_phase[4] == 2'b10); //for p16
        #10; $display("PRINTOUT 16"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);
        execution_done[2] <= (fu_phase[2] == 2'b10 && (execution_done[4] == 1)); execution_done[4] <= (fu_phase[4] == 2'b10); //for p17
        #10; $display("PRINTOUT 17"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);
        execution_done[2] <= (fu_phase[2] == 2'b10 && (execution_done[4] == 1)); execution_done[4] <= (fu_phase[4] == 2'b10); //for p18
        #10; $display("PRINTOUT 18"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);
        execution_done[2] <= (fu_phase[2] == 2'b10 && (execution_done[4] == 1)); execution_done[4] <= (fu_phase[4] == 2'b10); //for p19
        #10; $display("PRINTOUT 19"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);
        execution_done[2] <= (fu_phase[2] == 2'b10 && (execution_done[4] == 1)); execution_done[4] <= (fu_phase[4] == 2'b10); //for p20
        #10; $display("PRINTOUT 20"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);
        #10; $display("PRINTOUT 20.5"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);
        
        $display("BASIC WAR TEST");
        issue_fu <= 5; fetch_stall <= 0; decode_rreg1 <= 2; decode_rreg2 <= 3; decode_wreg <= 14; //for p21
        #10; $display("PRINTOUT 21"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);
        issue_fu <= 6; fetch_stall <= 0; decode_rreg1 <= 14; decode_rreg2 <= 15; decode_wreg <= 16; //for p22
        #10; $display("PRINTOUT 22"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);
        //$display("read req? %b", scoreboard_test.read_req);
        issue_fu <= 9; fetch_stall <= 0; decode_rreg1 <= 11; decode_rreg2 <= 12; decode_wreg <= 15; //for p23
        #10; $display("PRINTOUT 23"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);
        //$display("read req? %b", scoreboard_test.read_req);
        fetch_stall <= 1; execution_done[9] <= (fu_phase[9] == 2'b10); //for p24
        #10; $display("PRINTOUT 24"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);
        execution_done[9] <= (fu_phase[9] == 2'b10); execution_done[5] <= (fu_phase[5] == 2'b10); //for p25
        #10; $display("PRINTOUT 25"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);
        execution_done[9] <= (fu_phase[9] == 2'b10); execution_done[5] <= (fu_phase[5] == 2'b10); //for p26
        #10; $display("PRINTOUT 26"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);
        execution_done[9] <= (fu_phase[9] == 2'b10); execution_done[5] <= (fu_phase[5] == 2'b10); //for p27
        #10; $display("PRINTOUT 27"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);
        execution_done[6] <= (fu_phase[6] == 2'b10); //for p28
        #10; $display("PRINTOUT 28"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);
        execution_done[6] <= (fu_phase[6] == 2'b10); //for p29
        #10; $display("PRINTOUT 29"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);
        execution_done[6] <= (fu_phase[6] == 2'b10); //for p30
        #10; $display("PRINTOUT 30"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);
        execution_done[6] <= (fu_phase[6] == 2'b10); //for p31
        #10; $display("PRINTOUT 31"); print_sb(); //$display("CR: %b", can_read, "; RE: %b", read_enable, "; CW: %b", can_write, "; WE: %b", write_enable, "; active: %b", active);


        $finish;
    end

    scoreboard #(10) scoreboard_test (decode_rreg1, decode_rreg2, decode_wreg, issue_fu, fetch_stall, fu_phase, dr, run, flush, clk,
    can_read, can_write, read_enable, write_enable, active);
    string fu_status;
    function void print_sb();
        $write("          ");
        for (int k=0; k<10; k=k+1) begin
            $write("FU %0d", k, " ");
        end
        $write ("  RB WB R W");
        $write("\n");
        for (int i=0; i<10; i=i+1) begin
            if (active[i]) begin
                fu_status = "a";
            end else begin
                fu_status = " ";
            end
            $write("FU ", "%0d", i, " ", fu_status, " |  ");
            for (int j=0; j<10; j=j+1) begin 
                $write(scoreboard_test.RAW_grid[i][j], scoreboard_test.RAW_grid_tr[i][j], scoreboard_test.WAW_grid[i][j], scoreboard_test.WAR_grid[i][j], " ");
            end
            $write("| %b", (~can_read[i] && active[i]), "  %b", ~can_write[i], "  %b", read_enable[i], " %b", write_enable[i]);
            $write("\n");
        end
    endfunction

    always @(posedge clk) begin
        for (int i=0; i<10; i=i+1) begin
            if (can_read[i] && (fu_phase[i]==2'b00)) begin
                fu_phase[i] <= 2'b01; //read permitted, so await read
            end else if (read_enable[i] && (~execution_done[i])) begin
                fu_phase[i] <= 2'b10; //read enabled, so execute
            end else if (execution_done[i] && can_write[i] && (fu_phase[i] == 2'b10)) begin
                fu_phase[i] <= 2'b11; //write permitted and execution done, so await write
            end else if (write_enable[i]) begin
                fu_phase[i] <= 2'b00; //write enabled, so write
                execution_done[i] <= 0;
            end
        end
    end

    always @(posedge clk) begin
        if (!(fetch_stall)) begin
            dr[issue_fu] <= decode_wreg;
            $display("Issue FU: ", issue_fu, " | Dest Reg: ", decode_wreg, " | Src Reg 1: ", decode_rreg1, " | Src Reg 2: ", decode_rreg2);
        end
    end
endmodule
//RAW, RAWtr, WAW, WAR