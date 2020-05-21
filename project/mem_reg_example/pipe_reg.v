module PipeReg(out, in, clk, rst); // synopsys template
   parameter width = 32, init = 0;
   output [0:width-1] out;
   reg [0:width-1]    out;
   input [0:width-1]  in;
   input 	      clk, rst;

   always @ (posedge clk or negedge rst)
     if (~rst)
       out <= init;
     else
       out <= in;
   
endmodule // PipeReg

module PipeCtlReg(out, in, ctl, clk, rst); // synopsys template
   parameter width = 32, init = 0;
   output [0:width-1] out;
   reg [0:width-1]    out;
   input [0:width-1]  in;
   input [0:1] 	      ctl;
   input 	      clk, rst;

   always @ (posedge clk or negedge rst)
     if (~rst)
       out <= init;
     else begin
        if (ctl == 2'b00)
	        out <= in;
        else if (ctl == 2'b11)
	        out <= init;
     end
endmodule // PipeCtlReg
