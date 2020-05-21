// 32-bit SLL
module sll(a, b, out);
  input [31:0]a;
  input [4:0]b;
  output [31:0]out;

  assign out = a << b;
endmodule

// 32-bit SRL
module srl(a, b, out);
  input [31:0]a;
  input [4:0]b;
  output [31:0]out;

  assign out = a >> b;
endmodule

// 32-bit SRA
module sra(a, b, out);
  input signed [31:0]a;
  input [4:0]b;
  output [31:0]out;

  assign out = a >>> b;
endmodule

// 36-bit SRA shift right for foureach
module sra36(a, b, out);
  input signed [35:0]a;
  input [2:0]b;
  output [35:0]out;

  assign out = a >>> b;
endmodule

// 65-bit SRA shift right 4 for mult
module sra65(a, out);
  input signed [64:0]a;
  output [64:0]out;

  assign out = a >>> 4'b0100;
endmodule

// 32-bit general shifter
// SLL: 00, SRL: 01, SRA: 10
module shifter(opCode, a, b, out);
  input [1:0] opCode;
  input [31:0] a;
  input [4:0] b;
  output [31:0] out;

  wire [31:0] sllout;
  wire [31:0] srlout;
  wire [31:0] sraout;

  wire [31:0] mux1out;
  wire [31:0] mux2out;

  sll SLL (.a(a), .b(b), .out(sllout));
  srl SRL (.a(a), .b(b), .out(srlout));
  sra SRA (.a(a), .b(b), .out(sraout));

  mux_n sllsrl[31:0] (.s(opCode[0]), .s0(sllout), .s1(srlout), .out(mux1out));
  mux_n sramux[31:0] (.s(opCode[1]), .s0(mux1out), .s1(sraout), .out(out));
endmodule




