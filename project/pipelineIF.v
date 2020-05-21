module IF(clk, pcIn, pcHold, pcRst, IFhold, IFkill, IFrst, instr, jflag, jPC, jrflag, jrPC, brflag, brPC, pcOut, IFreg);
  input clk, IFhold, IFkill, IFrst;
  input [31:0] pcIn, jPC, jrPC, brPC, instr;
  input pcHold, pcRst, jflag, jrflag, brflag;

  output [31:0] pcOut;
  output [95:0] IFreg;
  reg [31:0] pcOut;


  wire [31:0] addedPC, next;

  adder_32 pcAdder (.a(pcOut), .b(32'd4), .cin(1'b0), .sum(next));

  assign addedPC = (brflag == 1'b1) ? brPC : (jflag == 1'b1) ? jPC : (jrflag == 1'b1) ? jrPC : next;

  /*
  // sets the start of our pc
  always @(negedge pcRst)
  begin
    pcOut = pcIn;
  end
  */

  always @(posedge clk or negedge pcRst)
  begin
    if (~pcRst)
      pcOut = pcIn;
    else if (pcHold == 1'b0)
      pcOut = addedPC;
  end

  wire [31:0]  PCplus8;
  adder_32 addgal2(.a(pcOut), .b(32'd8), .cin(1'b0), .sum(PCplus8));

  wire [95:0] ifIn;
  assign ifIn[95:64] = next;
  assign ifIn[63:32] = instr;
  assign ifIn[31:0] = PCplus8;

  pReg_n reglol[95:0] (.clk(clk), .hold(IFhold), .kill(IFkill), .rst(IFrst), .dataIn(ifIn), .dataOut(IFreg));

endmodule
