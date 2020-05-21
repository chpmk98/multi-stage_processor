module pptb();
  parameter IMEMFILE = "fib/instr.hex";
  parameter DMEMFILE = "fib/data.hex";
  reg [8*80-1:0] filename;
  reg clk;
  reg regRst;
  reg [31:0] pcIn;
  reg pcRst;
  
  // wires between inst. memory and processor
  wire [31:0] iaddr;
  wire [31:0] inst;

  // wires between data memory and processor
  wire [31:0] daddr;
  wire [31:0] drData;
  wire [31:0] dwData;
  wire dWr;
  wire [1:0] dSize;

  // wires for debugging
  wire pcHold, ifHold, idHold, ifKill, idKill, aluKill;
  wire idMult;
  wire idRegWr, aluRegWr;
  wire dregw;
  wire [31:0] dbusw;
  wire [4:0] drw;
  wire [31:0] ifInst;
  //wire [4:0] dRt;
 // wire [4:0] dRs;
//  wire [4:0] dRd;
  //wire [4:0] dRw;
  //wire signed [15:0] dimm16;
//  wire [31:0] dbusA;
 // wire [31:0] dbusB;
 // wire [31:0] dbusW;
 // wire dregWr;
 // wire dregDst;
//  wire djal;


  integer i;

  // our instruction and data memories
  imem #(.SIZE(16384)) IMEM(.addr(iaddr), .instr(inst));
  dmem #(.SIZE(16384)) DMEM(.addr(daddr), .rData(drData), .wData(dwData), .writeEnable(dWr), .dsize(dSize), .clk(clk));

  // our pipelined processor
  pp ppBoi (.clk(clk), .regRst(regRst), .pcIn(pcIn), .pcRst(pcRst), .iaddr(iaddr), .inst(inst), .daddr(daddr), .drData(drData), .dwData(dwData), .dWr(dWr), .dSize(dSize),
  // signals for debugging
  .dpcHold(pcHold), .difHold(ifHold), .didHold(idHold), .difKill(ifKill), .didKill(idKill), .daluKill(aluKill),
  .didMult(idMult), .idRegWr(idRegWr), .aluRegWrOut(aluRegWr), .wbBusWh(dbusw), .wbRegWrh(dregw), .wbRwh(drw),
  .ifInst(ifInst)
  );
	    //  .dRt(dRt), .dRs(dRs), .dRd(dRd), .dRw(dRw), .dimm16(dimm16), .dbusA(dbusA), .dbusB(dbusB), .dbusW(dbusW), .dregWr(
	    //dregWr), .dregDst(dregDst), .djal(djal));

initial begin
  
  // Clear dmem
  for (i = 0; i < DMEM.SIZE; i = i+1)
    DMEM.mem[i] = 8'h0;

  // Load IMEM from file
  if (!$value$plusargs("instrfile=%s", filename)) begin
    filename = IMEMFILE;
  end
  $readmemh(filename, IMEM.mem);

  // Load DMEM from file
  if (!$value$plusargs("datafile=%s", filename)) begin
    filename = DMEMFILE;
  end
  $readmemh(filename, DMEM.mem);

  // Reads out memory files before running
  $writememh("imem_preprogram", IMEM.mem);
  $writememh("dmem_preprogram", DMEM.mem);

 // count = 0;
  clk = 1'b0;
  regRst = 1'b0;
  pcIn = 32'h000;
  pcRst = 1'b0;
  //inst = 32'b0; 
 
  #5
  regRst = 1'b1;
  pcRst = 1'b1;

  $monitor("PC: %h, Inst: %h, ALUout: %h, MemWr: %b, ifInst: %h, idRegWr: %b, aluRegWr%b, wbRegWr: %b, wbRw: %b, wbBusW: %d, pcHold: %b, ifHold: %b idHold: %b, ifKill: %b, idKill: %b, aluKill: %b, idMult: %b", iaddr, inst, daddr, dWr, ifInst, idRegWr, aluRegWr, dregw, drw, dbusw, pcHold, ifHold, idHold, ifKill, idKill, aluKill, idMult);


  //$monitor("Cycle number: %d", count);

/*
  #0 inst = 32'b00000000010000100001000000100110; // xor r2, r2, r2;
  #4 inst = 32'b00100000010000110000000000001001; // addi r3, r2, $9;
  #4 inst = 32'b00100000011001000000000000000110; // addi r4, r3, $6;
  #4 inst = 32'b00000000100000100010100000100000; // add r5, r4, r2;
*/

  //#2500 $writememh("dmem_postprogram", DMEM.mem);
end

//always #2 clk = ~clk;
//always #2 clk = ~clk;
always #2 if (iaddr < 32'h48) clk = ~clk;

//always #4 count = count+1;

/*
always @(dRs) begin
  if (dRs == 5'd2)
    $display("dRs is two!");
  else
    $display("dRs is not two :(");
end
*/
endmodule 













  
