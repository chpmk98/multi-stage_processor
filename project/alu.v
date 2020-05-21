
module alu(opCode, a, b, out, v);
  // NOTE: c is the carry out from the adder
  // ADD: 0000, SUB: 0001
  // AND: 0110, OR : 0101, XOR: 0110
  // SLL: 1000, SRL: 1001, SRA: 1010

  input [3:0] opCode;
  input [31:0] a;
  input [31:0] b;
  output [31:0] out;
  output v;

  wire [31:0] notB;
  wire [31:0] adderIn;
  wire [31:0] adderOut;
  wire [31:0] logicOut;
  wire [31:0] mux1Out;
  wire [31:0] shifterOut;

  // Does the addition/subtraction
  // Outputs cout from the adder
  not_n notGate[31:0] (.a(b), .out(notB));
  mux_n adderSelector[31:0] (.s(opCode[0]), .s0(b), .s1(notB), .out(adderIn));
  adder_32 adder (.a(a), .b(adderIn), .cin(opCode[0]), .sum(adderOut), .v(v));

  // Does the AND/OR/XOR
  logics logicGates (.opCode(opCode[1:0]), .a(a), .b(b), .out(logicOut));

  // Does SLL/SLR/SRA
  shifter shft (.opCode(opCode[1:0]), .a(a), .b(b[4:0]), .out(shifterOut));

  // Selects the proper output given the opCode
  mux_n mux1[31:0] (.s(opCode[2]), .s0(adderOut), .s1(logicOut), .out(mux1Out));
  mux_n mux2[31:0] (.s(opCode[3]), .s0(mux1Out), .s1(shifterOut), .out(out));

endmodule




 
