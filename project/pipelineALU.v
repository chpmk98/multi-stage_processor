module wire_n(a, out);
  input a;
  output out;

  assign out = a;
endmodule


module extender(extOp, imm16, imm32);
  // zero extends when extOp == 0
  // sign extends when extOp == 1
  
  input extOp;
  input [15:0] imm16;
  output [31:0] imm32;

  wire extBit;

  and_n andGate (.a(extOp), .b(imm16[15]), .out(extBit));

  assign imm32[15:0] = imm16;

  wire_n wires[15:0] (.a(extBit), .out(imm32[31:16]));

  /*
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

  wire_n wires[23:0] (.a(extBit), .out(imm32[31:8]));

  /*
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


module pipelineALU(clk, aluHold, aluKill, aluRst, busA, busB, regDst, Rt, Rd, pc4, imm16, extOp, aluSrc, cond, mult, lhi, aluOp, condOp, jrFlagIn, beq, bne, pc8In, memWrIn, dExtOpIn, dSizeOpIn, jalIn, mem2regIn, regWrIn, curMult, jrFlagOut, brFlagOut, jrAddr, brAddr, pc8Out, aluOutout, Rw, busBout, memWrOut, dExtOpOut, dSizeOpOut, jalOut, mem2regOut, regWrOut);
  // This is the ALU stage of the pipeline processor
  // cond == 1 if it is a conditional command (e.g. seq)
  // mult == 1 if it is a multiplication 
  // (if cond == 1 == mult, we treat it as a conditional command)
  input clk, aluHold, aluKill, aluRst;

  // input from forwarding unit
  input [31:0] busA;
  input [31:0] busB;

  // input from ID stage to be consumed here
  input regDst;
  input [4:0] Rt;
  input [4:0] Rd;
  input [31:0] pc4;
  input [15:0] imm16;
  input extOp, aluSrc, cond, mult, lhi;
  input [3:0] aluOp;
  input [2:0] condOp;
  input jrFlagIn, beq, bne;

  // input from ID stage to be passed to the MEM stage
  input [31:0] pc8In;
  input memWrIn;
  input dExtOpIn;
  input [1:0] dSizeOpIn;
  input jalIn;
  input mem2regIn;
  input regWrIn;

  // output for controls (does NOT go through aluReg)
  output curMult;
  output jrFlagOut, brFlagOut;
  output [31:0] jrAddr;
  output [31:0] brAddr; // this is the extended imm16 used for branching

  // output for MEM stage
  output [31:0] pc8Out;
  output [31:0] aluOutout; // the selected output from cond, mult, and alu
  output [4:0] Rw;
  output [31:0] busBout;
  output memWrOut;
  output dExtOpOut;
  output [1:0] dSizeOpOut;
  output jalOut;
  output mem2regOut;
  output regWrOut;

  wire regZero, notRegZero, beqb, bneb;
  wire [4:0] Rww;
  wire [31:0] imm32w; // a wire for moving this to the MUX
  wire [31:0] aluIn;
  wire [3:0] modAluOp;
  wire [31:0] condOut;
  wire [63:0] multOut; // Do we want this to be a 64-bit thing? How to do?
  wire [31:0] lhiOut;
  wire [31:0] aluOut;
  wire [31:0] result;
  wire aluV;
  wire startMult, multReady, notMultReady;
  wire curMultw, notCurMultw, newCurMult, newCurMultw;


  // sends out information for branching and jumping
  // sets brFlagOut if (beq and zero) or (bne and nonzero)
  isZero regIsZero (.in(busA), .out(regZero));
  not_n notRegIsZero (.a(regZero), .out(notRegZero));
  and_n beqBranch (.a(beq), .b(regZero), .out(beqb));
  and_n bneBranch (.a(bne), .b(notRegZero), .out(bneb));
  or_n brBranch (.a(beqb), .b(bneb), .out(brFlagOut));
  // sets brAddr as pc+4 + imm32
  adder_32 brAddrAdder (.a(pc4), .b(imm32w), .cin(1'b0), .sum(brAddr));
  // sets stuff for jumps
  assign jrFlagOut = jrFlagIn;
  assign jrAddr = busA;


  // chooses Rw from Rt and Rd
  assign Rww = (jalIn == 1'b1) ? 5'd31 :
	       (regDst == 1'b1) ? Rd : Rt;


  // the register to hold curMultw in
  pReg_bit multTracker (.clk(clk), .hold(1'b0), .kill(1'b0), .rst(rst), .dataIn(newCurMultw), .dataOut(curMultw));

  // sends out flag to freeze the subsequent instructions
  assign curMult = newCurMultw;

  // Extends the immediate value
  extender extBoi (.extOp(extOp), .imm16(imm16), .imm32(imm32w));
  
  // Selects the alu input (either imm32w or busB)
  assign aluIn = (aluSrc == 1'b1) ? imm32w : busB;

  // Sets the ALU to subtraction if it is a cond operation
  assign modAluOp = (cond == 1'b1) ? 4'b0001 : aluOp;

  // This is the alu
  alu aluBoi (.opCode(modAluOp), .a(busA), .b(aluIn), .out(aluOut), .v(aluV));

  // This is the conditional logic
  condLogics condBoi (.opCode(condOp), .aluOut(aluOut), .V(aluV), .out(condOut)); 

  // This is the multiplier. It needs to go die.
  //assign multOut = busA*aluIn;
  not_n notty (.a(curMultw), .out(notCurMultw));
  and_n andy (.a(mult), .b(notCurMultw), .out(startMult));
  not_n notty2 (.a(multReady), .out(notMultReady));
  and_n andy2 (.a(mult), .b(notMultReady), .out(newCurMultw));
  //and_n andy2 (.a(curMultw), .b(notMultReady), .out(newCurMult));
  //or_n ihatemyself(.a(newCurMult), .b(startMult), .out(newCurMultw));
  mult multBoi (.A(busA), .B(aluIn), .start(startMult), .clk(clk), .ready(multReady), .out(multOut));


  // This is the LHI process
  assign lhiOut = {imm16, 16'b0};

  // This selects which output we actually use
  assign result = (lhi == 1'b1) ? lhiOut : (cond == 1'b1) ? condOut : (mult == 1'b1) ? multOut[31:0] : aluOut;


  // This is the aluReg register
  wire [107:0] aluRegDataIn;
  wire [107:0] aluRegDataOut;
  pReg_n aluReg[107:0] (.clk(clk), .hold(aluHold), .kill(aluKill), .rst(aluRst), .dataIn(aluRegDataIn), .dataOut(aluRegDataOut));

  // this assigns the values into the register
  assign aluRegDataIn[107:76] = pc8In;
  assign aluRegDataIn[75:44] = result;
  assign aluRegDataIn[43:39] = Rww;
  assign aluRegDataIn[38:7] = busB;
  assign aluRegDataIn[6] = memWrIn;
  assign aluRegDataIn[5] = dExtOpIn;
  assign aluRegDataIn[4:3] = dSizeOpIn;
  assign aluRegDataIn[2] = jalIn;
  assign aluRegDataIn[1] = mem2regIn;
  assign aluRegDataIn[0] = regWrIn;

  // this parses the values out of the register
  assign pc8Out = aluRegDataOut[107:76];
  assign aluOutout = aluRegDataOut[75:44];
  assign Rw     = aluRegDataOut[43:39];
  assign busBout = aluRegDataOut[38:7];
  assign memWrOut = aluRegDataOut[6];
  assign dExtOpOut = aluRegDataOut[5];
  assign dSizeOpOut = aluRegDataOut[4:3];
  assign jalOut     = aluRegDataOut[2];
  assign mem2regOut = aluRegDataOut[1];
  assign regWrOut   = aluRegDataOut[0];

endmodule





























