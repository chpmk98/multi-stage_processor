module or_6 (a,b,c,d,e,f, z);
    input a,b,c,d,e,f;
    output z;
    wire ab, cd, ef, abcd;
    
    or_n first(.a(a), .b(b), .out(ab));
    or_n second(.a(c), .b(d), .out(cd));
    or_n third(.a(e), .b(f), .out(ef));
    or_n fourth(.a(ab), .b(cd), .out(abcd));
    or_n fifth(.a(abcd), .b(ef), .out(z));
endmodule
