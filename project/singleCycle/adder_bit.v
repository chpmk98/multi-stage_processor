// Single bit adder
module adder_bit(a, b, cin, sum, cout);
  input a, b, cin;
  output sum, cout;

  wire axorb, aandb, candaxorb;

  // axorb = a ^ b
  xor_n xor1(.a(a), .b(b), .out(axorb));
  // sum = (a ^ b) ^ cin
  xor_n xor2(.a(axorb), .b(cin), .out(sum));

  // aandb = a & b
  and_n and1(.a(a), .b(b), .out(aandb));
  // candaxorb = cin & (a ^ b)
  and_n and2(.a(cin), .b(axorb), .out(candaxorb));
  // cout = (a & b) ^ (cin & (a ^ b))
  xor_n xor3(.a(aandb), .b(candaxorb), .out(cout));
endmodule
