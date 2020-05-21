module foureach (x,y,result);
	input [31:0] x;
	input [4:0] y;
	output [35:0] result;
	// output [31:0] temp1no;

	wire [31:0] notOut;
	wire [31:0] negx;
	not_n #(32) kacey (.a(x), .out(notOut));
	adder_32 billie (.a(notOut), .b(32'h00000000), .cin(1'b1), .sum(negx));

	wire [35:0] temp1;
	wire [35:0] temp2;
	wire [35:0] temp3;
	wire [35:0] temp4;

	wire [35:0] temp1n;
	wire [35:0] temp2n;
	wire [35:0] temp3n;
	wire [35:0] temp4n;

	wire [31:0] zeronext1;
	wire [31:0] zeronext2;
	wire [31:0] zeronext3;
	wire [31:0] zeronext4;
	wire [31:0] onenext1;
	wire [31:0] onenext2;
	wire [31:0] onenext3;
	wire [31:0] onenext4;
    mux_n #(32) mux1 (.s(y[0]), .s0(32'b0), .s1(x), .out(zeronext1));
    mux_n #(32) mux2 (.s(y[0]), .s0(negx), .s1(32'h00000000), .out(onenext1));
	mux_n #(32) mux3 (.s(y[1]), .s0(zeronext1), .s1(onenext1), .out(temp1[35:4]));

	assign temp1[3:0] = 4'b0000;
	sra36 sra1 (.a(temp1), .b(3'b100), .out(temp1n));
	// assign temp1no = zeronext1;

	// do this 3 more times and add
	mux_n #(32) mux4 (.s(y[1]), .s0(32'h00000000), .s1(x), .out(zeronext2));
    mux_n #(32) mux5 (.s(y[1]), .s0(negx), .s1(32'h00000000), .out(onenext2));
	mux_n #(32) mux6 (.s(y[2]), .s0(zeronext2), .s1(onenext2), .out(temp2[35:4]));
	assign temp2[3:0] = 4'b0000;
	sra36 sra2 (.a(temp2), .b(3'b011), .out(temp2n));

	mux_n #(32) mux7 (.s(y[2]), .s0(32'h00000000), .s1(x), .out(zeronext3));
    mux_n #(32) mux8 (.s(y[2]), .s0(negx), .s1(32'h00000000), .out(onenext3));
	mux_n #(32) mux9 (.s(y[3]), .s0(zeronext3), .s1(onenext3), .out(temp3[35:4]));
	assign temp3[3:0] = 4'b0000;
	sra36 sra3 (.a(temp3), .b(3'b010), .out(temp3n));

	mux_n #(32) mux10 (.s(y[3]), .s0(32'h00000000), .s1(x), .out(zeronext4));
    mux_n #(32) mux11 (.s(y[3]), .s0(negx), .s1(32'h00000000), .out(onenext4));
	mux_n #(32) mux12 (.s(y[4]), .s0(zeronext4), .s1(onenext4), .out(temp4[35:4]));
	assign temp4[3:0] = 4'b0000;
	sra36 sra4 (.a(temp4), .b(3'b001), .out(temp4n));

	wire [35:0] plus1;
	wire [35:0] plus2;
	adder_36 aaa (.a(temp1n), .b(temp2n), .cin(1'b0), .sum(plus1));
	adder_36 sss (.a(plus1), .b(temp3n), .cin(1'b0), .sum(plus2));
	adder_36 ddd (.a(plus2), .b(temp4n), .cin(1'b0), .sum(result));

endmodule
