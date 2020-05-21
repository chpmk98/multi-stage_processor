module and_6 (a,b,c,d,e,f, z);
    input a,b,c,d,e,f;
    output z;
    wire ab, cd, ef, abcd;
    
    and_n first(.a(a), .b(b), .out(ab));
    and_n second(.a(c), .b(d), .out(cd));
    and_n third(.a(e), .b(f), .out(ef));
    and_n fourth(.a(ab), .b(cd), .out(abcd));
    and_n fifth(.a(abcd), .b(ef), .out(z));
endmodule

// Six 1 equal to 1
