module pipeRegsTB();
  reg clk, hold, kill, rst, done;
  reg [5:0] dataIn;
  wire [5:0] dataOut;

  pReg_n #(6) regBoiz (clk, hold, kill, rst, dataIn, dataOut);

initial begin
  $monitor("clk: %b, hold: %b, kill: %b, rst: %b, dataIn: %d, dataOut: %d", clk, hold, kill, rst, dataIn, dataOut);

  #0 clk = 1'b0; hold = 1'b0; kill = 1'b0; rst = 1'b1; dataIn = 6'd42; done = 1'b0;
  #1 rst = 1'b0; #2 rst = 1'b1;
  #1 //middle of the cycle
  #4 dataIn = 6'd9; hold = 1'b1;
  #4 dataIn = 6'd8; hold = 1'b0;
  #4 kill = 1'b1;
  #8 kill = 1'b0;
  #8 done = 1'b1;

  //report "simulation finished successfully" severity FAILURE;
 
end

always #2 clk = (~clk || done);

endmodule 













  
