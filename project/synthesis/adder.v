`timescale 1ns/1ps
module fa(a, b, cin, sum, cout);
   input a, b, cin;
   output sum, cout;

   assign sum = a ^ b ^ cin;
   assign cout = (a&b)^(cin&(a^b));
endmodule // fa

`timescale 1ns/1ps
module testbench;
   reg in1, in2, cin;
   wire sum, cout;

   fa FULL_ADDER(.a(in1), .b(in2), .cin(cin), .sum(sum), .cout(cout));

   initial begin
      $monitor("A = %b B = %b CIN=%b SUM = %b COUT=%b", in1, in2, cin, sum, cout);

      in1 = 0; in2 = 0; cin = 0;
      #1 in1 = 0; in2 = 0; cin = 1;
      #1 in1 = 0; in2 = 1; cin = 0;
      #1 in1 = 0; in2 = 1; cin = 1;
      #1 in1 = 1; in2 = 0; cin = 0;
      #1 in1 = 1; in2 = 0; cin = 1;
      #1 in1 = 1; in2 = 1; cin = 0;
      #1 in1 = 1; in2 = 1; cin = 1;      
      
   end
   
endmodule // testbench
