module ext26 (imm26, imm32);
  input [25:0] imm26;
  output [31:0] imm32;

  assign imm32[25:0] = imm26;

  genvar i;
    for (i = 26; i < 32; i = i+1) begin
      assign imm32[i] = imm26[25];
    end

/*
  genExt: for i in 26 to 31 generate
    assign imm32[i] = imm26[25];
  end generate genExt;
*/
endmodule


module PCreg(clk, pcIn, pcRst, imm26, imm32, busAout, branch, jump, jr, pcOut, pc8);
  input clk;
  input [31:0] pcIn;
  input pcRst;
  input [25:0] imm26;
  input [31:0] imm32;
  input [31:0] busAout;
  input branch, jump, jr;
  output [31:0] pcOut;
  output [31:0] pc8;

  reg [31:0] pcOut;

  wire [31:0] jmp32;
  wire [31:0] pcAdd;
  wire [31:0] addedPC;
  wire cout; //unused

  ext26 jmpExt (.imm26(imm26), .imm32(jmp32));

  assign pcAdd = (branch == 1'b1) ? imm32 : (jump == 1'b1) ? jmp32 : 32'b0;

  wire [31:0] pc4;
  adder_32 pc4Adder (.a(pcOut), .b(32'd4), .cin(1'b0), .sum(pc4), .v(cout));

  adder_32 pcAdder (.a(pc4), .b(pcAdd), .cin(1'b0), .sum(addedPC), .v(cout));
  adder_32 jalAdder (.a(pcOut), .b(32'd8), .cin(1'b0), .sum(pc8), .v(cout));

  // sets the start of our pc
  always @(negedge pcRst)
  begin
    pcOut = pcIn;
  end

  
  always @(posedge clk)
  begin
    if (jr == 1'b1)
      pcOut = busAout;
    else
      pcOut = addedPC;
  end

endmodule 


module scp(clk, regRst, pcIn, pcRst, iaddr, inst, daddr, drData, dwData, dWr, dSize,
	   dRt, dRs, dRd, dRw, dimm16, dbusA, dbusB, dbusW, dregWr, dregDst, djal); // these are for debugging purposes
  input clk;
  input regRst;
  input [31:0] pcIn;
  input pcRst;
  output [31:0] iaddr;
  input [31:0] inst;
  output [31:0] daddr;
  input [31:0] drData;
  output [31:0] dwData;
  output dWr;
  output [1:0] dSize;

  output [4:0] dRt;
  output [4:0] dRs;
  output [4:0] dRd;
  output [4:0] dRw;
  output [15:0] dimm16;
  output [31:0] dbusA;
  output [31:0] dbusB;
  output [31:0] dbusW;
  output dregWr;
  output dregDst;
  output djal;

  // wires from instruction to datapath
  wire [4:0] Rt;
  wire [4:0] Rs;
  wire [4:0] Rd;
  wire [15:0] imm16;

  // wire from pc reg to datapath
  wire [31:0] pc8;

  // wires from control unit to datapath
  wire jal, regDst, regWr, extOp, aluSrc, cond, mult, lhi;
  wire [3:0] aluOp;
  wire [2:0] condOp;
  wire [1:0] dSizeOp;
  wire dExtOp, memWr, mem2reg;

  // wires from datapath to pc register
  wire [31:0] busBout;
  wire [31:0] imm32;

  // wires from datapath to control unit
  wire regZero;

  // wires from control unit to pc reg
  wire branch, jump, jr;


  // rips out stuff for debugging
  assign dRt = Rt;
  assign dRs = Rs;
  assign dRd = Rd;
  assign dimm16 = imm16;
  assign dbusB = busBout;
  assign dregWr = regWr;
  assign dregDst = regDst;
  assign djal = jal;


  // sets the inputs from the instruction
  assign Rs = inst[25:21];
  assign Rt = inst[20:16];
  assign Rd = inst[15:11];
  assign imm16 = inst[15:0];

  // bring out the dSize for various stores
  assign dSize = dSizeOp;

  // this is our PC register
  PCreg pcBoi (.clk(clk), .pcIn(pcIn), .pcRst(pcRst), .imm26(inst[25:0]), .imm32(imm32), .busAout(dbusA), .branch(branch), .jump(jump), .jr(jr), .pcOut(iaddr), .pc8(pc8));

  // this is our control unit
  control contBoi(.opc(inst[31:26]), .func(inst[5:0]), .ALUzero(regZero), .RegDst(regDst), .ALUsrc(aluSrc), .MemReg(mem2reg), .RegW(regWr), .MemW(memWr), .Branch(branch), .ExtOp(extOp), .mult(mult), .cond(cond), .dextop(dExtOp), .jflag(jump), .jrflag(jr), .jalflag(jal), .lhiflag(lhi), .ALUop(aluOp), .condOp(condOp), .dsize(dSizeOp));

  // this is our datapath
  datapath dataBoi(.clk(clk), .Rt(Rt), .Rs(Rs), .Rd(Rd), .imm16(imm16), .pc8(pc8), .jal(jal), .regRst(regRst), .regDst(regDst), .regWr(regWr), .extOp(extOp), .aluSrc(aluSrc), .cond(cond), .mult(mult), .lhi(lhi), .aluOp(aluOp), .condOp(condOp), .dSizeOp(dSizeOp), .dExtOp(dExtOp), .memWr(memWr), .mem2reg(mem2reg), .busBout(busBout), .imm32(imm32), .regZero(regZero), .Daddr(daddr), .DwData(dwData), .DmemWr(dWr), .DrData(drData), .dbusA(dbusA), .dbusW(dbusW), .dRw(dRw));

endmodule





















