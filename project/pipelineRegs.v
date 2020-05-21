
module pReg_bit (clk, hold, kill, rst, dataIn, dataOut);
  input clk, hold, kill, rst, dataIn;
  output dataOut;

  reg curData;

  assign dataOut = curData;

  /*
  // Asynchronously resets the register to 0 whenever reset is low
  always @(rst) begin
    if (rst == 1'b0)
      curData = 1'b0;
  end
  */

  //wire IaR;
  //and_n ander (.a(dataIn), .b(rst), .out(IaR));

  // Every cycle, if hold is not high, we update the register
  // with the value from dataIn.
  // Also, synchronously kill.
  always @(posedge clk or negedge rst) begin
    if (~rst)
      curData = 1'b0;
    else if (hold == 1'b0 && kill == 1'b0 && rst == 1'b1)
      curData = dataIn;
    else if (kill == 1'b1)
      curData = 1'b0;
  end
endmodule

module pReg_n (clk, hold, kill, rst, dataIn, dataOut);
  //parameter n = 1;
  input clk, hold, kill, rst;
  input dataIn;
  output dataOut;

  // Make n 1-bit registers in a row
  pReg_bit regBoi (.clk(clk), .hold(hold), .kill(kill), .rst(rst), .dataIn(dataIn), .dataOut(dataOut));
endmodule





    
