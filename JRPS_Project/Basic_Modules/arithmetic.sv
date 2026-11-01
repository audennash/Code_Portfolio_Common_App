module top_module_arithmetic ();
	reg clk=0;
	always #1 clk = ~clk;  // Create clock with period=10
	initial `probe_start;   // Start the timing diagram

	//`probe(clk);        // Probe signal "clk"

	// A testbench
    reg signed [7:0] a=8'b00000000;
    reg signed [7:0] b=8'b00000001;
    reg signed [7:0] a_old=8'b00000000;
    reg signed [7:0] b_old=8'b00000000;
    reg run=0;
    reg reset=0;
    //reg c=0;
    //reg signed [3:0] in = 4'b0000;
    wire signed [7:0] quotient;
    wire signed [7:0] remainder;
    wire div0;
    reg done;
    //wire [3:0] sum;
    //wire carry;
	initial begin
        #16;run<=1;$display("INITIATE");
        
        #4; a_old<=a; b_old<=b; a <= 8'b00010001; b <= 8'b00001100;
        #12; $display("a: ", a_old, "; b: ", b_old, "; q: ", quotient, "; r: ", remainder, "; d0: ", div0, "; done: ", done); 
        
        #4; a_old<=a; b_old<=b; a <= 8'b01100001; b <= 8'b00101001;
        #12; $display("a: ", a_old, "; b: ", b_old, "; q: ", quotient, "; r: ", remainder, "; d0: ", div0, "; done: ", done);  
        
        #4; a_old<=a; b_old<=b; a <= 8'b10111111; b <= 8'b00000000; 
        #12; $display("a: ", a_old, "; b: ", b_old, "; q: ", quotient, "; r: ", remainder, "; d0: ", div0, "; done: ", done);  
        
        #4; a_old<=a; b_old<=b; a <= 8'b01110110; b <= 8'b11000010;
        #12; $display("a: ", a_old, "; b: ", b_old, "; q:", quotient, "; r: ", remainder, "; d0: ", div0, "; done: ", done); 
        
        #4; a_old<=a; b_old<=b; a <= 8'b11100001; b <= 8'b01101101;
        #12; $display("a: ", a_old, "; b: ", b_old, "; q: ", quotient, "; r: ", remainder, "; d0: ", div0, "; done: ", done);  
        
        #4; a_old<=a; b_old<=b; a <= 8'b10111111; b <= 8'b10011000; 
        #12; $display("a: ", a_old, "; b: ", b_old, "; q: ", quotient, "; r: ", remainder, "; d0: ", div0, "; done: ", done);  
        
        #4; a_old<=a; b_old<=b; a <= 8'b10010110; b <= 8'b00001011;
        #12; $display("a: ", a_old, "; b: ", b_old, "; q:", quotient, "; r: ", remainder, "; d0: ", div0, "; done: ", done); 
        
        #4; a_old<=a; b_old<=b;
        #12; $display("a: ", a_old, "; b: ", b_old, "; q:", quotient, "; r: ", remainder, "; d0: ", div0, "; done: ", done); 
        
		//$display ("Hello world! The current time is (%0d ps)", $time);
		$finish;
	end
    
    tcdiv #(8) testdiv (a,b,clk,run,reset,quotient,remainder,div0,done);

endmodule

module tcdiv #(parameter n=2)(
    input [n-1:0] a,
    input [n-1:0] b,
    input clk,
    input run,
    input reset,
    output [n-1:0] quotient,
    output [n-1:0] remainder,
    output div0,
    output reg done);
    
    reg sign_a;
    reg sign_b;
    always @(posedge clk) begin
        if (done==1) begin
            sign_a <= a[n-1];
            sign_b <= b[n-1];
        end
    end
    
    wire [n-1:0] na;
    wire [n-1:0] nb;
    neg #(n) neg_a (a,na);
    neg #(n) neg_b (b,nb);
    
    wire [n-1:0] ap;
    wire [n-1:0] bp;
    assign ap=a[n-1]? na:a;
    assign bp=b[n-1]? nb:b;
    
    wire [n-1:0] us_quot;
    wire [n-1:0] us_rem;
    wire [n-1:0] nq;
    wire [n-1:0] nr;
    wire fs;
    neg #(n) neg_quot (us_quot, nq);
    neg #(n) neg_rem (us_rem, nr);
    xor final_sign (fs, sign_a, sign_b);
    assign quotient = fs? nq : us_quot;
    assign remainder = sign_a? nr: us_rem;
    
    usdiv #(n) maindiv (ap, bp, clk, run, reset, us_quot, us_rem, div0, done);
    
endmodule

module usdiv #(parameter n=2)(
    input [n-1:0] a,
    input [n-1:0] b,
    input clk,
    input run,
    input reset,
    output [n-1:0] quotient,
    output [n-1:0] remainder,
    output div0,
    output reg done);
    
    reg [2*n-1:0] mainreg;
    reg [n-1:0] b_reg;
    reg [$clog2(n)-1:0] step;
    
    wire done_next;
    wire [n-1:0] b_reg_next;
    wire [2*n-1:1] mainreg_next;
    
    assign done_next = (step==n-1)? 1:0;
    assign b_reg_next = (step==0)? b:b_reg;
    assign mainreg_next = (step==0)? { {(n-1){1'b0}} , a} : mainreg;
    
    initial begin
        mainreg=0;
        b_reg=0;
        step=0;
        done=0;
    end
    
    wire [n:0] adderout;
    wire [n-1:0] mainreg_change;
    adder #(n+1) cand_add (mainreg_next[2*n-1:n], {1'b1,~b_reg_next}, 1'b1, adderout[n:0],);
    assign mainreg_change = adderout[n]? mainreg_next[2*n-1:n] : adderout[n-1:0];
    
    wire [$clog2(n)-1:0] step_next;
    adder #($clog2(n)) stepinc ('0, step, 1'b1, step_next,);
    
    always @(posedge clk) begin
        //if (run==1 && run==0) begin
            //$display("@stp ", step_next, "test:%b", ~b_reg_next);
            //$display("snapshot | RR:%b", mainreg_next[2*n-1:n], "; B:%b", b_reg_next, "; addout%b", adderout[n:0]);
            //$display("about to become |: %b", {mainreg_change,mainreg_next[n-1:1],~adderout[n]});
        //end
        if (reset ==1) begin
            mainreg<=0;
        	b_reg<=0;
        	step<=0;
        	done<=0;
        end else if (run==1) begin
            done <= done_next;
            b_reg <= b_reg_next;
            mainreg [2*n-1:n] <= mainreg_change;
            mainreg [n-1:1] <= mainreg_next[n-1:1];
            mainreg [0] <= ~adderout[n];
            step <= step_next;
        end
    end
    
    assign quotient = mainreg[n-1:0];
    assign remainder = mainreg[2*n-1:n];
    assign div0 = (b_reg==0)? 1:0;
    
endmodule

module tcmult #(parameter n=2)(
    input [n-1:0] a,
    input [n-1:0] b,
    input clk,
    input run,
    input reset,
    output reg [n-1:0] small_prod,
    output reg [2*n-1:0] big_prod,
    output reg done);

    reg sign_a;
    reg sign_b;
    always @(posedge clk) begin
        if (done==1) begin
            sign_a <= a[n-1];
            sign_b <= b[n-1];
        end
    end
    
    wire [n-1:0] na;
    wire [n-1:0] nb;
    neg #(n) neg_a (a,na);
    neg #(n) neg_b (b,nb);
    
    wire [n-1:0] ap;
    wire [n-1:0] bp;
    assign ap=a[n-1]? na:a;
    assign bp=b[n-1]? nb:b;
    
    wire [2*n-1:0] usout;
    wire [n-1:0] nl;
    wire [2*n-1:0] nbi;
    wire fs;
    neg #(n) neg_l (usout[n-1:0], nl);
    neg #(2*n) neg_bi (usout, nbi);
    xor final_sign (fs, sign_a, sign_b);
    assign small_prod = fs? nl : usout[n-1:0];
    assign big_prod = fs? nbi: usout;
    
    usmult #(n) mainmult (ap[n-1:0], bp[n-1:0], clk, run, reset, usout[2*n-1:0], done);
    
endmodule
    
module usmult #(parameter n=2) (
    input [n-1:0] a,
    input [n-1:0] b,
    input clk,
    input run,
    input reset,
    output reg [2*n-1:0] prod,
    output reg done);
    
    reg [n-1:0] a_reg;
    reg [$clog2(n)-1:0] step;
    
    wire done_next;
    wire [n-1:0] a_reg_next;
    wire [2*n-1:0] prod_next;
    
    assign done_next = (step==n-1)? 1:0;
    assign a_reg_next = (step==0)? a:a_reg;
    assign prod_next = (step==0)? { {(n){1'b0}} , b} : prod;
    
    initial begin
        prod=0;
        a_reg=0;
        step=0;
        done=0;
    end
    
    wire [n:0] adderout;
    wire [n:0] prod_change;
    adder #(n) cand_add (prod_next[2*n-1:n], a_reg_next, 1'b0, adderout[n-1:0], adderout[n]);
    assign prod_change = prod_next[0]? adderout:prod_next[2*n-1:n];
    
    wire [$clog2(n)-1:0] step_next;
    adder #($clog2(n)) stepinc ('0, step, 1'b1, step_next, );
    
    always @(posedge clk) begin
        if (reset ==1) begin
            prod<=0;
        	a_reg<=0;
        	step<=0;
        	done<=0;
        end else if (run==1) begin
            done <= done_next;
            a_reg <= a_reg_next;
            prod[2*n-1:n-1] <= prod_change;
            prod [n-2:0] <= prod_next[n-1:1];
            step <= step_next;
        end
    end
    
endmodule

module neg #(parameter n=1)(
    input [n-1:0] in,
    output [n-1:0] out);
    
 
    wire [n-1:0] notout;
    not initnot [n-1:0] (notout, in);
    adder #(n) add1 ('0, notout, 1'b1, out,);
    
endmodule

module adder #(parameter n=1) (
    input [n-1:0] a,
    input [n-1:0] b,
    input c,
    output [n-1:0] sum,
    output carry);
    
    wire subcarry; 
    if (n!= 1) begin : RECURSE
        adder #(.n(n-1)) subadder(a[n-2:0],b[n-2:0],c,sum[n-2:0],subcarry);
    end else begin : BASECASE
        assign subcarry=c;
    end
    fulladder newadder(a[n-1],b[n-1],subcarry,sum[n-1],carry);
    
endmodule

module fulladder(
    input a,
    input b,
    input c,
    output sum,
    output carry);
    
    wire halfsum;
    wire carry1;
    wire carry2;
    halfadder ha2(b,c,halfsum,carry1);
    halfadder ha1(a,halfsum,sum,carry2);
    or carryor (carry,carry1,carry2);
    
endmodule

module halfadder(
    input a,
    input b,
    output sum,
    output carry);
    
    xor sumxor (sum, a, b);
    and carryand (carry, a, b);
    
endmodule