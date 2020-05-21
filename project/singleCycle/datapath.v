
module extender(extOp, imm16, imm32);
  // zero extends when extOp == 0
  // sign extends when extOp == 1
  
  input extOp;
  input [15:0] imm16;
  output [31:0] imm32;

  wire extBit;

  and_n andGate (.a(extOp), .b(imm16[15]), .out(extBit));

  assign imm32[15:0] = imm16;

  genvar i;
    for (i = 16; i < 32; i = i+1) begin
      assign imm32[i] = extBit;
    end
/*  
  genExt: for i in 16 to 31 generate
    assign imm32[i] = extBit;
  end generate genExt;
*/
endmodule


module extByte(extOp, imm8, imm32);
  input extOp;
  input [7:0] imm8;
  output [31:0] imm32;

  wire extBit;

  and_n andGate (.a(extOp), .b(imm8[7]), .out(extBit));

  assign imm32[7:0] = imm8;

  genvar i;
    for (i = 8; i < 32; i = i+1) begin
      assign imm32[i] = extBit;
    end
/*
  genExt: for i in 8 to 31 generate
    assign imm32[i] = extBit;
  end generate genExt;
*/
endmodule


module fatALU(busA, busB, imm16, extOp, aluSrc, cond, mult, lhi, aluOp, condOp, imm32, result); //, zero);
  // This is the main processing unit of the datapath
  // cond == 1 if it is a conditional command (e.g. seq)
  // mult == 1 if it is a multiplication 
  // (if cond == 1 == mult, we treat it as a conditional command)
  input [31:0] busA;
  input [31:0] busB;
  input [15:0] imm16;
  input extOp, aluSrc, cond, mult, lhi;
  input [3:0] aluOp;
  input [2:0] condOp;
  output [31:0] imm32; // this is the extended imm16 used for branch and jmp
  output [31:0] result; // the selected output from cond, mult, and alu
  //output zero;

  wire [31:0] imm32w; // a wire for moving this to the MUX
  wire [31:0] aluIn;
  wire [3:0] modAluOp;
  wire [31:0] condOut;
  wire [31:0] multOut; // Do we want this to be a 64-bit thing? How to do?
  wire [31:0] lhiOut;
  wire [31:0] aluOut;
  wire aluV;

  // exposes imm32 for J
  assign imm32 = imm32w;

  // Extends the immediate value
  extender extBoi (.extOp(extOp), .imm16(imm16), .imm32(imm32w));
  
  // Selects the alu input (either imm32w or busB)
  assign aluIn = (aluSrc == 1'b1) ? imm32w : busB;
/*
  always @(aluSrc or imm32w or busB)
  begin
    if(aluSrc == 1'b1)
      aluIn = imm32w;
    else
      aluIn = busB;
  end
*/

  // Sets the ALU to subtraction if it is a cond operation
  assign modAluOp = (cond == 1'b1) ? 4'b0001 : aluOp;
/*
  always @(cond or aluOp)
  begin
    if (cond == 1'b1)
      modAluOp = 4'b0001; // Set the alu to do a subtraction
    else
      modAluOp = aluOp;
  end
*/

  // This is the alu
  alu aluBoi (.opCode(modAluOp), .a(busA), .b(aluIn), .out(aluOut), .v(aluV));

  // This is the conditional logic
  condLogics condBoi (.opCode(condOp), .aluOut(aluOut), .V(aluV), .out(condOut)); //, .z(zero)); 

  // This is the multiplier
  assign multOut = busA*aluIn;

  // This is the LHI process
  assign lhiOut = {imm16, 16'b0};

  // This selects which output we actually use
  assign result = (lhi == 1'b1) ? lhiOut : (cond == 1'b1) ? condOut : (mult == 1'b1) ? multOut : aluOut;
/*
  always @(cond or mult or condOut or multOut or aluOut)
  begin
    if (cond == 1'b1)
      result = condOut;
    else if (mult == 1'b1)
      result = multOut;
    else
      result = aluOut;
  end
*/
endmodule


module dMemSelector(dataIn, dSizeOp, dExtOp, dataOut);
  // word == 11; halfword == 01; byte == 00;
  input [31:0] dataIn;
  input [1:0] dSizeOp;
  input dExtOp;
  output [31:0] dataOut;

  wire [31:0] byteOut;
  wire [31:0] halfOut;

  extender halfExt (.extOp(dExtOp), .imm16(dataIn[15:0]), .imm32(halfOut));
  extByte byteExt (.extOp(dExtOp), .imm8(dataIn[7:0]), .imm32(byteOut));

  // selects which size we use
  assign dataOut = (dSizeOp == 2'b11) ? dataIn : (dSizeOp == 2'b01) ? halfOut : byteOut;

endmodule


module datapath(clk, Rt, Rs, Rd, imm16, pc8, jal, regRst, regDst, regWr, extOp, aluSrc, cond, mult, lhi, aluOp, condOp, dSizeOp, dExtOp, memWr, mem2reg, busBout, imm32, regZero, Daddr, DwData, DmemWr, DrData,
		dbusA, dbusW, dRw); // debugging purposes
  // This is the full datapath
  input clk;
  input [4:0] Rt;
  input [4:0] Rs;
  input [4:0] Rd;
  input [15:0] imm16;
  input [31:0] pc8; // allows inputing PC for JAL and JALR (in which case jal should be set to 1)
  input jal, regRst, regDst, regWr, extOp, aluSrc, cond, mult, lhi;
  input [3:0] aluOp;
  input [2:0] condOp;
  input [1:0] dSizeOp;
  input dExtOp, memWr, mem2reg;
  output [31:0] busBout;
  output [31:0] imm32;
  output regZero; // for use in branching
  //output condResult; // for use in branching

  // Dmemory interface
  output [31:0] Daddr;
  output [31:0] DwData;
  output DmemWr;
  input [31:0] DrData;


  // pull signals out for debugging
  output [31:0] dbusA;
  output [31:0] dbusW;
  output [4:0] dRw;


  wire [4:0] Rw;
  //wire [31:0] busAreg;
  wire [31:0] busA;
  wire [31:0] busB;
  wire [31:0] fatAluOut;
  wire [31:0] dataIn;
  wire [31:0] dataOut;
  wire [31:0] busW;

  // this reads busB out for JR and JALR
  assign busBout = busB;
  

  // pulls busA out for debugging
  assign dbusA = busA;
  assign dbusW = busW;
  assign dRw = Rw;


  // this checks if busA is 0 for BEQZ and BNEZ
  isZero regIsZero (.in(busA), .out(regZero));
  //assign condResult = fatAluOut[0];

  // selects the input for the ALU (allowing bypassing for JAL and JALR)
  //assign busA = (setBusA == 1'b1) ? busAin : busAreg;
/*
  always @(busAin or busAreg or setBusA)
  begin
    if (setBusA == 1'b1)
      busA = busAin;
    else
      busA = busAreg;
  end
*/

  // This selects the register we write to
  wire [4:0] RdRtOut;
  mux_n #(5) RdRtMux (.s(regDst), .s0(Rt), .s1(Rd), .out(RdRtOut));
  mux_n #(5) jalMux (.s(jal), .s0(RdRtOut), .s1(5'd31), .out(Rw));

/*
  assign Rw = (jal == 1'b1) ? 5'd31 :
	 (regDst == 1'b1) ? Rd : Rt;
*
  always @(Rd or Rt or regDst)
  begin
    if (regDst == 1'b1)
      Rw = Rd;
    else
      Rw = Rt;
  end
*/

  // Here are our 16 registers
  register_files regBoiz (.clk(clk), .rst(regRst), .RegWr(regWr), .Rw(Rw), .Data_in(busW), .Rs(Rs), .BusA(busA), .Rt(Rt), .BusB(busB));

  // Here is our fat alu
  fatALU fatBoi (.busA(busA), .busB(busB), .imm16(imm16), .extOp(extOp), .aluSrc(aluSrc), .cond(cond), .mult(mult), .lhi(lhi), .aluOp(aluOp), .condOp(condOp), .imm32(imm32), .result(fatAluOut)); //, .zero(zero));

  // Here is our data memory
  //dmem dboi (.addr(fatAluOut), .wData(dataIn), .writeEnable(memWr), .clk(clk), .dsize(2'b11), .rData(dataOut));
  assign Daddr = fatAluOut;
  assign DwData = busB;
  assign DmemWr = memWr;
  //assign dataOut = DrData;

  // This selects the size of the data read from dMem (depends on type of load)
  dMemSelector dBoi (.dataIn(DrData), .dExtOp(dExtOp), .dSizeOp(dSizeOp), .dataOut(dataOut));

  // This selects the data we write back into our registers

  assign busW = (jal == 1'b1) ? pc8 :
		(mem2reg == 1'b1) ? dataOut :
		fatAluOut;
/*
  always @(fatAluOut or dataOut or mem2reg)
  begin
    if (mem2reg == 1'b1)
      busW = dataOut;
    else
      busW = fatAluOut;
  end
*/

endmodule




































