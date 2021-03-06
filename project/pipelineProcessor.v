
// This is our pipelined processor for EECS 362
module pp(clk, regRst, pcIn, pcRst, iaddr, inst, daddr, drData, dwData, dWr, dSize,
// these signals are for debugging
dpcHold, difHold, didHold, difKill, didKill, daluKill, didMult, idRegWr, aluRegWrOut, wbBusWh, wbRegWrh, wbRwh,
ifInst
);
  input clk, regRst;
  input [31:0] pcIn;
  input pcRst;
  output [31:0] iaddr;
  input [31:0] inst;
  output [31:0] daddr;
  input [31:0] drData;
  output [31:0] dwData;
  output dWr;
  output [1:0] dSize;

  // signals for debugging
  output dpcHold, difHold, didHold, difKill, didKill, daluKill;
  output didMult, idRegWr, aluRegWrOut, wbRegWrh;
  output [31:0] wbBusWh;
  output [4:0] wbRwh;
  output [31:0] ifInst;

  // signals for holding, killing, and resetting stages
  wire pcHold, ifHold, idHold, aluHold, memHold;
  wire ifKill, idKill, aluKill, memKill;
  wire ifRst, idRst, aluRst, memRst;



  // assigns register reset signals
  assign ifRst = regRst;
  assign idRst = regRst;
  assign aluRst = regRst;
  assign memRst = regRst;

  // hold and kill depends on signals generated by the
  // subsequent stages, so they are assigned at the end
  // of this module.




  // signals from ID to IF
  wire idifJflag;
  wire [31:0] idifJpc;

  // signals from ALU to IF
  wire aluifJRflag;
  wire [31:0] aluifJRaddr;
  wire aluifBrFlag;
  wire [31:0] aluifBrAddr;

  // signals from IF to ID
  wire [95:0] ifOut;
  wire [31:0] ifidPC4;
  wire [31:0] ifidInst;
  wire [31:0] ifidPC8;

  // this parses the IF output into the correct pieces
  assign ifidPC4 = ifOut[95:64];
  assign ifidInst = ifOut[63:32];
  assign ifidPC8 = ifOut[31:0];

  // this is our IF stage
  IF ifBoi (
	.clk(clk),
	.pcIn(pcIn),
	.pcHold(pcHold),
	.pcRst(pcRst),
	.IFhold(ifHold),
	.IFkill(ifKill),
	.IFrst(ifRst),
	.instr(inst),
	.jflag(idifJflag),
	.jPC(idifJpc),
	.jrflag(aluifJRflag),
	.jrPC(aluifJRaddr), 
	.brflag(aluifBrFlag),
	.brPC(aluifBrAddr),
	.pcOut(iaddr),
	.IFreg(ifOut)
  );




  // signals from ID to ALU
  wire [117:0] idOut;
  wire [31:0] idaluPC4;
  wire [4:0] idaluRs;
  wire [4:0] idaluRt;
  wire [4:0] idaluRd;
  wire [31:0] idaluPC8;
  wire idRegDst;
  wire idALUsrc;
  wire idMemReg;
  wire idRegW;
  wire idMemW;
  wire idbeq;
  wire idbne;
  wire idextop;
  wire idmult;
  wire idcond; 
  wire iddextop;
  wire idjr;
  wire idjal;
  wire idlhi;
  wire [3:0] idaluop;
  wire [2:0] idcondop;
  wire [1:0] iddsize;
  wire [15:0] idimm16;  

  // signal from ID to IF
  wire idLoad;

  // this is our ID stage
  IDcontrol idBoi (
	.PCplus4(ifidPC4),
	.PCplus8(ifidPC8),
	.instr(ifidInst),
	.IDclk(clk),
	.IDhold(idHold),
	.IDkill(idKill),
	.IDrst(idRst),
	.jflag(idifJflag),
	.jumpPC(idifJpc),
	.Load(idLoad),
	.finalreg(idOut)
  );

    assign idaluPC4 = idOut[117:86];
    assign idaluRs = idOut[85:81];
    assign idaluRt = idOut[80:76];
    assign idaluRd = idOut[75:71];
    assign idaluPC8 = idOut[70:39];
    assign idRegDst = idOut[38];
    assign idALUsrc = idOut[37];
    assign idMemReg = idOut[36];
    assign idRegW = idOut[35];
    assign idMemW = idOut[34];
    assign idbeq = idOut[33];
    assign idbne = idOut[32];
    assign idextop = idOut[31];
    assign idmult = idOut[30];
    assign idcond = idOut[29];
    assign iddextop = idOut[28];
    assign idjr = idOut[27];
    assign idjal = idOut[26];
    assign idlhi = idOut[25];
    assign idaluop = idOut[24:21]; 
    assign idcondop = idOut[20:18]; 
    assign iddsize = idOut[17:16];
    assign idimm16 = idOut[15:0];



  // signals from WB to registers
  wire wbRegWr;
  wire [4:0] wbRw;
  wire [31:0] wbBusW;

  // signals from register files to forwarder
  wire [31:0] regBusA;
  wire [31:0] regBusB;

  // this is our register files
  register_files regBoiz(
  		.clk(clk),
  		.rst(regRst),
  		.RegWr(wbRegWr),
  		.Rw(wbRw),
  		.Data_in(wbBusW),
  		.Rs(idaluRs),
  		.BusA(regBusA),
  		.Rt(idaluRt),
  		.BusB(regBusB)
  );




  // signals from ALU to forwarder
  wire [31:0] aluOut;
  wire [4:0] aluRw;

  // signals from MEM to forwarder
  wire [31:0] memBusW;
  wire [4:0] memRw;

  // signals from forwarder to ALU
  wire [31:0] fBusA;
  wire [31:0] fBusB;

  //forward
  forward fwBoi (
  	.rs(idaluRs), 
  	.rt(idaluRt), 
  	.busA(regBusA), 
  	.busB(regBusB), 
  	.ALUout(aluOut), 
  	.ALUrw(aluRw), 
  	.Memout(memBusW), 
  	.Memrw(memRw), 
  	.busAF(fBusA), 
  	.busBF(fBusB)
    );




  // signals from the ALU stage
  wire aluCurMult;
  wire [31:0] aluPC8;
  wire [31:0] aluBusB;
  wire aluMemWr;
  wire aluDExtOp;
  wire [1:0] aluDSizeOp;
  wire aluJAL;
  wire aluMem2Reg;
  wire aluRegWr;

  // this is our ALU stage
  pipelineALU aluBoi (
  				.clk(clk),
				.aluHold(aluHold),
				.aluKill(aluKill),
				.aluRst(aluRst),
				.busA(fBusA), 
				.busB(fBusB),
				.regDst(idRegDst),
				.Rt(idaluRt),
				.Rd(idaluRd),
				.pc4(idaluPC4),
				.imm16(idimm16),
				.extOp(idextop),
				.aluSrc(idALUsrc),
				.cond(idcond),
				.mult(idmult),
				.lhi(idlhi),
				.aluOp(idaluop),
				.condOp(idcondop), 
				.jrFlagIn(idjr), 
				.beq(idbeq), 
				.bne(idbne), 
				.pc8In(idaluPC8), 
				.memWrIn(idMemW), 
				.dExtOpIn(iddextop), 
				.dSizeOpIn(iddsize), 
				.jalIn(idjal), 
				.mem2regIn(idMemReg), 
				.regWrIn(idRegW), 
				.curMult(aluCurMult), 
				.jrFlagOut(aluifJRflag), 
				.brFlagOut(aluifBrFlag), 
				.jrAddr(aluifJRaddr), 
				.brAddr(aluifBrAddr), 
				.pc8Out(aluPC8), 
				.aluOutout(aluOut), 
				.Rw(aluRw), 
				.busBout(aluBusB), 
				.memWrOut(aluMemWr), 
				.dExtOpOut(aluDExtOp), 
				.dSizeOpOut(aluDSizeOp), 
				.jalOut(aluJAL), 
				.mem2regOut(aluMem2Reg), 
				.regWrOut(aluRegWr)
	);




  // this is our MEM stage
  pipelineMEM memBoi (
  .clk(clk), 
  .memHold(memHold), 
  .memKill(memKill), 
  .memRst(memRst), 
  .pc8(aluPC8), 
  .aluOut(aluOut), 
  .RwIn(aluRw), 
  .busB(aluBusB), 
  .regWrIn(aluRegWr), 
  .memWr(aluMemWr), 
  .dExtOp(aluDExtOp), 
  .dSizeOp(aluDSizeOp), 
  .jal(aluJAL), 
  .mem2reg(aluMem2Reg), 
  .Daddr(daddr), 
  .DwData(dwData),
  .Dsize(dSize), 
  .DmemWr(dWr), 
  .DrData(drData), 
  .busW(wbBusW), 
  .regWrOut(wbRegWr), 
  .RwOut(wbRw)
  );




  // WB does not need its own module


  // this assigns holds and kills
  wire BoJ, nBoJ, LoBoJ, LanBoJ, MoLanBoJ;
  or_n BoJor (.a(aluifBrFlag), .b(aluifJRflag), .out(BoJ));
  or_n LoBoJor (.a(idLoad), .b(BoJ), .out(LoBoJ));
  not_n nBoJnot (.a(BoJ), .out(nBoJ));
  and_n LanBoJand (.a(idLoad), .b(nBoJ), .out(LanBoJ));
  or_n MoLanBoJor (.a(aluCurMult), .b(LanBoJ), .out(MoLanBoJ));

  assign pcHold = MoLanBoJ;
  assign ifHold = aluCurMult;
  assign idHold = aluCurMult;
  assign aluHold = 1'b0;
  assign memHold = 1'b0;

  //assign ifKill = LanBoJ;
  assign ifKill = LoBoJ;
  assign idKill = BoJ;
  assign aluKill = aluCurMult;
  assign memKill = 1'b0;



  // assigns signals for debugging
  assign didMult = idmult;
  // these signals are for debugging
  assign dpcHold = pcHold;
  assign difHold = ifHold;
  assign didHold = idHold;
  assign difKill = ifKill;
  assign didKill = idKill;
  assign daluKill = aluKill;

  assign idRegWr = idRegW;
  assign aluRegWrOut = aluRegWr;

  assign wbRegWrh = wbRegWr;
  assign wbBusWh = wbBusW;
  assign wbRwh = wbRw;
  assign ifInst = ifidInst;



endmodule















