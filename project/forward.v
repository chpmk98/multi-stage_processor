module forward (rs, rt, busA, busB, ALUout, ALUrw, Memout, Memrw, busAF, busBF);

	input [4:0] rs, rt, ALUrw, Memrw;
	input [31:0] busA, busB, ALUout, Memout;
	output [31:0] busAF;
	output [31:0] busBF;
	//reg busAF, busBF;

	assign busAF = 	(rs == ALUrw) ? ALUout :
			(rs == Memrw) ? Memout :
			busA;

	assign busBF =	(rt == ALUrw) ? ALUout :
			(rt == Memrw) ? Memout :
			busB;

/*
	always @(rs or ALUrw or Memrw or busA or ALUout or Memout)
  	begin
    	if (rs == ALUrw)
      		busAF = ALUout;
    	else if (rs == Memrw)
      		busAF = Memout;
    	else
      		busAF = busA;

    	if (rt == ALUrw)
      		busBF = ALUout;
    	else if (rt == Memrw)
      		busBF = Memout;
    	else
      		busBF = busB;
  	end
/*
  	always @(rt or ALUrw or Memrw or busB or ALUout or Memout)
  	begin
    	if (rt == ALUrw)
      		busBF = ALUout;
    	else if (rt == Memrw)
      		busBF = Memout;
    	else
      		busBF = busB;
  	end*/
endmodule
