
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


module pipelineMEM(clk, memHold, memKill, memRst, pc8, aluOut, RwIn, busB, regWrIn, memWr, dExtOp, dSizeOp, jal, mem2reg, Daddr, DwData, Dsize, DmemWr, DrData, busW, regWrOut, RwOut);
  input clk, memHold, memKill, memRst;

  // this is input from pipelineALU
  input [31:0] pc8;
  input [31:0] aluOut;
  input [4:0] RwIn;
  input [31:0] busB;
  input regWrIn, memWr, dExtOp;
  input [1:0] dSizeOp;
  input jal, mem2reg;

  // Dmemory interface
  output [31:0] Daddr;
  output [31:0] DwData;
  output [1:0] Dsize;
  output DmemWr;
  input [31:0] DrData;

  // Output for pipelineWB
  output [31:0] busW;
  output regWrOut;
  output [4:0] RwOut;

  wire [31:0] dataOut;
  wire [31:0] busWw;
  wire [37:0] memRegDataIn;
  wire [37:0] memRegDataOut;

  // here is our data memory
  assign Daddr = aluOut;
  assign DwData = busB;
  assign Dsize = dSizeOp;
  assign DmemWr = memWr;

  // this selects the size of the data read from dMem
  // (depends on type of load)
  dMemSelector dBoi (.dataIn(DrData), .dExtOp(dExtOp), .dSizeOp(dSizeOp), .dataOut(dataOut));

  // this selects the data we write back into our registers
  assign busWw = (jal == 1'b1) ? pc8 :
		 (mem2reg == 1'b1) ? dataOut :
		 aluOut;

  // passes values into the register
  assign memRegDataIn[37:6] = busWw;
  assign memRegDataIn[5] = regWrIn;
  assign memRegDataIn[4:0] = RwIn;
  // takes registers out of register
  assign busW = memRegDataOut[37:6];
  assign regWrOut = memRegDataOut[5];
  assign RwOut = memRegDataOut[4:0];
  // this is the actual register
  pReg_n memReg[37:0] (.clk(clk), .hold(memHold), .kill(memKill), .rst(memRst), .dataIn(memRegDataIn), .dataOut(memRegDataOut)); 

endmodule


