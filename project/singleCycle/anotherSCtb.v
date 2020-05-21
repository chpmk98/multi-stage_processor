module SCtb();
  parameter IMEMFILE = "quicksort/instr.hex";
  parameter DMEMFILE = "quicksort/data.hex";
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
  wire [4:0] dRt;
  wire [4:0] dRs;
  wire [4:0] dRd;
  wire [4:0] dRw;
  wire signed [15:0] dimm16;
  wire [31:0] dbusA;
  wire [31:0] dbusB;
  wire [31:0] dbusW;
  wire dregWr;
  wire dregDst;
  wire djal;
  integer i;
  integer count;

  // our instruction and data memories
  imem #(.SIZE(16384)) IMEM(.addr(iaddr), .instr(inst));
  dmem #(.SIZE(16384)) DMEM(.addr(daddr), .rData(drData), .wData(dwData), .writeEnable(dWr), .dsize(dSize), .clk(clk));

  // our single cycle processor
  scp scpBoi (.clk(clk), .regRst(regRst), .pcIn(pcIn), .pcRst(pcRst), .iaddr(iaddr), .inst(inst), .daddr(daddr), .drData(drData), .dwData(dwData), .dWr(dWr), .dSize(dSize),
	      .dRt(dRt), .dRs(dRs), .dRd(dRd), .dRw(dRw), .dimm16(dimm16), .dbusA(dbusA), .dbusB(dbusB), .dbusW(dbusW), .dregWr(dregWr), .dregDst(dregDst), .djal(djal));

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
  
  count = 0;
  clk = 1'b0;
  regRst = 1'b0;
  pcIn = 32'h1000;
  //pcIn = 32'h0;
  pcRst = 1'b1;
  #5
  regRst = 1'b1;
  pcRst = 1'b0;

  $monitor("PC: %h, Inst: %h, ALUout: %h, MemWr: %b, Rt: %d, Rs: %d, Rd: %d, Rw: %d, imm16: %d, busA: %h, busB: %h, busW: %h, regWr: %b, regDst: %b, jal: %b", iaddr, inst, daddr, dWr, dRt, dRs, dRd, dRw, dimm16, dbusA, dbusB, dbusW, dregWr, dregDst, djal);

  //$monitor("Cycle number: %d", count);

/*
  #1 inst = 32'b00000000010000100001000000100110; // xor r2, r2, r2;
  #4 inst = 32'b00100000010000110000000000001001; // addi r3, r2, $9;
  #4 inst = 32'b00100000011001000000000000000110; // addi r4, r3, $6;
  #4 inst = 32'b00000000100000100010100000100000; // add r5, r4, r2;
*/

  #460000 $writememh("dmem_postprogram2", DMEM.mem);
end

always #2 clk = ~clk;

always #4 count = count+1;

/*
always @(dRs) begin
  if (dRs == 5'd2)
    $display("dRs is two!");
  else
    $display("dRs is not two :(");
end
*/
endmodule 













  
