
module fatALUtb;
  reg [31:0] busA;
  reg [31:0] busB;
  reg [15:0] imm16;
  reg extOp, aluSrc, cond, mult, lhi;
  reg [3:0] aluOp;
  reg [2:0] condOp;
  
  wire [31:0] imm32;
  wire [31:0] result;

  fatALU noo(.busA(busA), .busB(busB), .imm16(imm16), .extOp(extOp), .aluSrc(aluSrc), .cond(cond), .mult(mult), .lhi(lhi), .aluOp(aluOp), .condOp(condOp), .imm32(imm32), .result(result));

  initial begin
  $monitor("BusA: %d, BusB: %d, Imm16: %d, extOp: %b, aluSrc %b, cond %b, mult %b, lhi %b, aluOp: %b, condOp: %b, imm32: %d, result: %d", busA, busB, imm16, extOp, aluSrc, cond, mult, lhi, aluOp, condOp, imm32, result);

  #0 busA = 32'd7; busB = 32'd10; imm16 = 16'd100; aluSrc = 1'b0; aluOp = 4'b0;
  #1 extOp = 1'b0; cond = 1'b0; mult = 1'b0; 
  #1 lhi = 1'b0;
  #1 condOp = 3'b000;
  #1 mult = 1'b1;
  #1 cond = 1'b1;
  #1 lhi = 1'b1;


  end
endmodule






