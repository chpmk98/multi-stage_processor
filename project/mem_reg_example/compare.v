// Compare two 16-bit numbers; return lesser
module compare_lt(a, b, result);
   input [0:15] a, b;
   output [0:15] result;

   assign result = (a < b) ? a : b;
endmodule // compare_lt

// Compare 4 16-bit numbers; return lowest in 1 cycle
module find_min_single(a, b, c, d, m, clk, rst);
    input [0:15] a, b, c, d;
    input 	clk, rst;
    output [0:15] m;
    wire [0:15] input1_a, input1_b, input2_a, input2_b, result1, result2, final_result;

    PipeReg #(16) IN_PIPE_REG_A(input1_a, a, clk, rst);
    PipeReg #(16) IN_PIPE_REG_B(input1_b, b, clk, rst);
    PipeReg #(16) IN_PIPE_REG_C(input2_a, c, clk, rst);
    PipeReg #(16) IN_PIPE_REG_D(input2_b, d, clk, rst);

    // First stage
    compare_lt COMPARE1_STAGE1(.a(input1_a), .b(input1_b), .result(result1));
    compare_lt COMPARE2_STAGE1(.a(input2_a), .b(input2_b), .result(result2));

    // Second stage (no intermediate registers)
    compare_lt COMPARE_STAGE2(.a(result1), .b(result2), .result(final_result));
    assign m = final_result;

endmodule

module find_min_pipe(a, b, c, d, m, clk, rst);
    input [0:15] a, b, c, d;
    input 	clk, rst;
    output [0:15] m;
    wire [0:15] input1_a, input1_b, input2_a, input2_b, result1, result2, result1_reg, result2_reg,
                final_result;

    PipeReg #(16) IN_PIPE_REG_A(input1_a, a, clk, rst);
    PipeReg #(16) IN_PIPE_REG_B(input1_b, b, clk, rst);
    PipeReg #(16) IN_PIPE_REG_C(input2_a, c, clk, rst);
    PipeReg #(16) IN_PIPE_REG_D(input2_b, d, clk, rst);

    // First pipeline stage
    compare_lt COMPARE1_STAGE1(.a(input1_a), .b(input1_b), .result(result1));
    compare_lt COMPARE2_STAGE1(.a(input2_a), .b(input2_b), .result(result2));

    PipeReg #(16) PIPEREG1(result1_reg, result1, clk, rst);
    PipeReg #(16) PIPEREG2(result2_reg, result2, clk, rst);

    // Second pipeline stage
    compare_lt COMPARE_STAGE2(.a(result1_reg), .b(result2_reg), .result(final_result));
    assign m = final_result;

endmodule // find_max


module test_find_min();
    reg [0:15] a, b, c, d;
    reg clk;
    reg rst;
    wire [0:15] m_single, m_pipe;

    find_min_single MIN_SINGLE(.a(a), .b(b), .c(c), .d(d), .m(m_single), .clk(clk), .rst(rst));
    find_min_pipe MIN_PIPE(.a(a), .b(b), .c(c), .d(d), .m(m_pipe), .clk(clk), .rst(rst));
   initial begin
      $monitor($time,,"a=%d b=%d c=%d d=%d m_s=%d m_p=%d",
	       a, b, c, d, m_single, m_pipe);
      
      #1 rst <= 0; clk <= 0;
      #1 rst <= 1; 
      #1 a <= 1; b <= 2; c <= 3; d <= 4; clk <= 1;
      #1 clk <= 0;
      #1 a <= 45; b <= 35; c <= 23; d <= 100; clk <= 1;
      #1 clk = 0;
      #1 a <= 100; b <= 300; c <= 200; d <= 400; clk <= 1;
      #1 clk <= 0;
      #1 clk <= 1;
      #1 clk <= 0;
      #1 clk <= 1;

   end

endmodule //test_find_min
