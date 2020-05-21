module mult(A, B, start, clk, ready, out);
  input [31:0] A;
  input [31:0] B;
  input start;
  input clk;
  output ready;
  output [63:0] out; 

  reg ready;
  reg [2:0] count;
  reg signed [64:0] runProd;
  wire [35:0] temp; //put a 0 at the end at first


  wire [35:0] lala;
  wire [64:0] temppp;
  foureach ellamai (.x(A), .y(runProd[4:0]), .result(lala));
  sra65 jorja (.a(runProd), .out(temppp));

  // need a 36-bit adder
  adder_36 bryce (.a(temppp[64:29]), .b(lala), .cin(1'b0), .sum(temp));

  assign out = runProd[64:1];//{temp, temppp[28:1]};



  always @ (posedge clk)
    if (start == 1) begin
      runProd <= {32'b0, B, 1'b0};
      count <= 3'b111;
    end else begin
      runProd[28:0] <= temppp[28:0];
      runProd[64:29] <= temp;
      count <= count - 3'b1; // Might need a 3-bit adder here...
      if (count == 3'b0) begin
        ready <= 1'b1;
      end else begin
        ready <= 1'b0;
      end
    end
 

  //assign temp[64:33] = 32'h00000000;
  //assign temp[32:1] = B;
  //assign temp[0] = 1'b0;
  /*
  //do it 7 more times

  foureach ellamai1 (.x(A), .y(temp[4:0]), .result(lala));
  sra65 jorja1 (.a(temp), .out(temppp));
  adder_36 bryce1 (.a(temppp[64:29]), .b(lala), .cin(1'b0), .sum(temp[64:29]));

  foureach ellamai2 (.x(A), .y(temp[4:0]), .result(lala));
  sra65 jorja2 (.a(temp), .out(temppp));
  adder_36 bryce2 (.a(temppp[64:29]), .b(lala), .cin(1'b0), .sum(temp[64:29]));

  foureach ellamai3 (.x(A), .y(temp[4:0]), .result(lala));
  sra65 jorja3 (.a(temp), .out(temppp));
  adder_36 bryce3 (.a(temppp[64:29]), .b(lala), .cin(1'b0), .sum(temp[64:29]));

  foureach ellamai4 (.x(A), .y(temp[4:0]), .result(lala));
  sra65 jorja4 (.a(temp), .out(temppp));
  adder_36 bryce4 (.a(temppp[64:29]), .b(lala), .cin(1'b0), .sum(temp[64:29]));

  foureach ellamai5 (.x(A), .y(temp[4:0]), .result(lala));
  sra65 jorja5 (.a(temp), .out(temppp));
  adder_36 bryce5 (.a(temppp[64:29]), .b(lala), .cin(1'b0), .sum(temp[64:29]));

  foureach ellamai6 (.x(A), .y(temp[4:0]), .result(lala));
  sra65 jorja6 (.a(temp), .out(temppp));
  adder_36 bryce6 (.a(temppp[64:29]), .b(lala), .cin(1'b0), .sum(temp[64:29]));

  foureach ellamai7 (.x(A), .y(temp[4:0]), .result(lala));
  sra65 jorja7 (.a(temp), .out(temppp));
  adder_36 bryce7 (.a(temppp[64:29]), .b(lala), .cin(1'b0), .sum(temp[64:29]));


  assign out = temp[64:1];
  */
endmodule
