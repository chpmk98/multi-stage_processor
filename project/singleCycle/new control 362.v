module control (opc, func, ALUzero, RegDst, ALUsrc, MemReg, RegW, MemW, Branch, ExtOp, mult, cond, dextop, jflag, jrflag,jalflag, lhiflag, ALUop, condOp, dsize);
    input [5:0] opc, func;
    input ALUzero;
   // input condout;
    output RegDst, ALUsrc, MemReg, RegW, MemW, Branch, ExtOp, mult, cond, dextop, jflag, jrflag,jalflag,  lhiflag;
    output [3:0] ALUop;
    output [2:0] condOp;
    output [1:0] dsize;
    
    // making the inv of opcode and funcode so it will be easier to and/or
    wire [5:0] not_opc, not_func;
    not_n #(6) abc(.a(opc), .out(not_opc));
    not_n #(6) bcd(.a(func), .out(not_func));
    
    wire addx,addux,subx,subux,andx,orx, xorx, sllx,srlx,srax, rtype;   //addx, etc. is a temp wire
    wire seqx, snex, sltx, sgtx, slex, sgex,  multx, multux, nopx;

    and_6 rrr(.a(not_opc[5]), .b(not_opc[4]), .c(not_opc[3]), .d(not_opc[2]), .e(not_opc[1]), .f(not_opc[0]), .z(rtype));
    // if this is rtype, rtype=1


    wire addr,addur,subr,subur,andr,orr,    xorr, sllr,srlr,srar;
    wire seqr, sner, sltr, sgtr, sler, sger,  multr, multur, nopr; 
    // addr, xxxr is the result, if 1 then we wanna add

    and_6 addt(.a(func[5]), .b(not_func[4]), .c(not_func[3]), .d(not_func[2]), .e(not_func[1]), .f(not_func[0]), .z(addx));
    and_n addf(.a(addx), .b(rtype), .out(addr));
    and_6 addut(.a(func[5]), .b(not_func[4]), .c(not_func[3]), .d(not_func[2]), .e(not_func[1]), .f(func[0]), .z(addux));
    and_n adduf(.a(addux), .b(rtype), .out(addur));
    and_6 subt(.a(func[5]), .b(not_func[4]), .c(not_func[3]), .d(not_func[2]), .e(func[1]), .f(not_func[0]), .z(subx));
    and_n subf(.a(subx), .b(rtype), .out(subr));
    and_6 subut(.a(func[5]), .b(not_func[4]), .c(not_func[3]), .d(not_func[2]), .e(func[1]), .f(func[0]), .z(subux));
    and_n subuf(.a(subux), .b(rtype), .out(subur));
    and_6 andt(.a(func[5]), .b(not_func[4]), .c(not_func[3]), .d(func[2]), .e(not_func[1]), .f(not_func[0]), .z(andx));
    and_n andf(.a(andx), .b(rtype), .out(andr));
    and_6 ort(.a(func[5]), .b(not_func[4]), .c(not_func[3]), .d(func[2]), .e(not_func[1]), .f(func[0]), .z(orx));
    and_n orf(.a(orx), .b(rtype), .out(orr));
    and_6 xort(.a(func[5]), .b(not_func[4]), .c(not_func[3]), .d(func[2]), .e(func[1]), .f(not_func[0]), .z(xorx));
    and_n xorf(.a(xorx), .b(rtype), .out(xorr));

    and_6 sllt(.a(not_func[5]), .b(not_func[4]), .c(not_func[3]), .d(func[2]), .e(not_func[1]), .f(not_func[0]), .z(sllx));
    and_n sllf(.a(sllx), .b(rtype), .out(sllr));
    and_6 srlt(.a(not_func[5]), .b(not_func[4]), .c(not_func[3]), .d(func[2]), .e(func[1]), .f(not_func[0]), .z(srlx));
    and_n srlf(.a(srlx), .b(rtype), .out(srlr));
    and_6 srat(.a(not_func[5]), .b(not_func[4]), .c(not_func[3]), .d(func[2]), .e(func[1]), .f(func[0]), .z(srax));
    and_n sraf(.a(srax), .b(rtype), .out(srar));

    and_6 seqt(.a(func[5]), .b(not_func[4]), .c(func[3]), .d(not_func[2]), .e(not_func[1]), .f(not_func[0]), .z(seqx));
    and_n seqf(.a(seqx), .b(rtype), .out(seqr));
    and_6 snet(.a(func[5]), .b(not_func[4]), .c(func[3]), .d(not_func[2]), .e(not_func[1]), .f(func[0]), .z(snex));
    and_n snef(.a(snex), .b(rtype), .out(sner));
    and_6 sltt(.a(func[5]), .b(not_func[4]), .c(func[3]), .d(not_func[2]), .e(func[1]), .f(not_func[0]), .z(sltx));
    and_n sltf(.a(sltx), .b(rtype), .out(sltr));
    and_6 sgtt(.a(func[5]), .b(not_func[4]), .c(func[3]), .d(not_func[2]), .e(func[1]), .f(func[0]), .z(sgtx));
    and_n sgtf(.a(sgtx), .b(rtype), .out(sgtr));
    and_6 slet(.a(func[5]), .b(not_func[4]), .c(func[3]), .d(func[2]), .e(not_func[1]), .f(not_func[0]), .z(slex));
    and_n slef(.a(slex), .b(rtype), .out(sler));
    and_6 sget(.a(func[5]), .b(not_func[4]), .c(func[3]), .d(func[2]), .e(not_func[1]), .f(func[0]), .z(sgex));
    and_n sgef(.a(sgex), .b(rtype), .out(sger));

    and_6 multt(.a(not_func[5]), .b(not_func[4]), .c(func[3]), .d(func[2]), .e(func[1]), .f(not_func[0]), .z(multx));
    and_n multf(.a(multx), .b(rtype), .out(multr));
    and_6 multut(.a(not_func[5]), .b(func[4]), .c(not_func[3]), .d(func[2]), .e(func[1]), .f(not_func[0]), .z(multux));
    and_n multuf(.a(multux), .b(rtype), .out(multur));

    and_6 nopt(.a(not_func[5]), .b(func[4]), .c(not_func[3]), .d(func[2]), .e(not_func[1]), .f(func[0]), .z(nopx));
    and_n nopf(.a(nopx), .b(rtype), .out(nopr));
////////////////////////////////////////////////////////////////
    or_n setmult(.a(multr), .b(multur), .out(mult)); //set mult = 1 and feed to fatALU


    //regdst is 1 when rtype, otherwise 0 or dont care
    assign RegDst = rtype;
    //ALUsrc is 0 only when its r-type
    not_n alusrcxx(.a(rtype), .out(ALUsrc));

    wire beqzr,bnezr,addir,adduir,subir,subuir,andir,orir,xorir,lhir,jrr,jalrr,sllir,srlir;
    wire srair,seqir,sneir,sltir,sgtir,sleir,sgeir,lbr,lhr,lwr,lbur,lhur,sbr,shr,swr, jr, jalr;

    //J-type
    and_6 jf(.a(not_opc[5]), .b(not_opc[4]), .c(not_opc[3]), .d(not_opc[2]), .e(opc[1]), .f(not_opc[0]), .z(jr));
    and_6 jalf(.a(not_opc[5]), .b(not_opc[4]), .c(not_opc[3]), .d(not_opc[2]), .e(opc[1]), .f(opc[0]), .z(jalr));
    //I-type
    and_6 beqzf(.a(not_opc[5]), .b(not_opc[4]), .c(not_opc[3]), .d(opc[2]), .e(not_opc[1]), .f(not_opc[0]), .z(beqzr));
    and_6 bnezf(.a(not_opc[5]), .b(not_opc[4]), .c(not_opc[3]), .d(opc[2]), .e(not_opc[1]), .f(opc[0]), .z(bnezr));
    and_6 addif(.a(not_opc[5]), .b(not_opc[4]), .c(opc[3]), .d(not_opc[2]), .e(not_opc[1]), .f(not_opc[0]), .z(addir));
    and_6 adduif(.a(not_opc[5]), .b(not_opc[4]), .c(opc[3]), .d(not_opc[2]), .e(not_opc[1]), .f(opc[0]), .z(adduir));
    and_6 subif(.a(not_opc[5]), .b(not_opc[4]), .c(opc[3]), .d(not_opc[2]), .e(opc[1]), .f(not_opc[0]), .z(subir));
    and_6 subuif(.a(not_opc[5]), .b(not_opc[4]), .c(opc[3]), .d(not_opc[2]), .e(opc[1]), .f(opc[0]), .z(subuir));
    and_6 andif(.a(not_opc[5]), .b(not_opc[4]), .c(opc[3]), .d(opc[2]), .e(not_opc[1]), .f(not_opc[0]), .z(andir));
    and_6 orif(.a(not_opc[5]), .b(not_opc[4]), .c(opc[3]), .d(opc[2]), .e(not_opc[1]), .f(opc[0]), .z(orir));
    and_6 xorif(.a(not_opc[5]), .b(not_opc[4]), .c(opc[3]), .d(opc[2]), .e(opc[1]), .f(not_opc[0]), .z(xorir));
    and_6 lhif(.a(not_opc[5]), .b(not_opc[4]), .c(opc[3]), .d(opc[2]), .e(opc[1]), .f(opc[0]), .z(lhir));

    and_6 jrf(.a(not_opc[5]), .b(opc[4]), .c(not_opc[3]), .d(not_opc[2]), .e(opc[1]), .f(not_opc[0]), .z(jrr));
    and_6 jalrf(.a(not_opc[5]), .b(opc[4]), .c(not_opc[3]), .d(not_opc[2]), .e(opc[1]), .f(opc[0]), .z(jalrr));
    and_6 sllif(.a(not_opc[5]), .b(opc[4]), .c(not_opc[3]), .d(opc[2]), .e(not_opc[1]), .f(not_opc[0]), .z(sllir));
    and_6 srlif(.a(not_opc[5]), .b(opc[4]), .c(not_opc[3]), .d(opc[2]), .e(opc[1]), .f(not_opc[0]), .z(srlir));
    and_6 sraif(.a(not_opc[5]), .b(opc[4]), .c(not_opc[3]), .d(opc[2]), .e(opc[1]), .f(opc[0]), .z(srair));
    and_6 seqif(.a(not_opc[5]), .b(opc[4]), .c(opc[3]), .d(not_opc[2]), .e(not_opc[1]), .f(not_opc[0]), .z(seqir));
    and_6 sneif(.a(not_opc[5]), .b(opc[4]), .c(opc[3]), .d(not_opc[2]), .e(not_opc[1]), .f(opc[0]), .z(sneir));
    and_6 sltif(.a(not_opc[5]), .b(opc[4]), .c(opc[3]), .d(not_opc[2]), .e(opc[1]), .f(not_opc[0]), .z(sltir));
    and_6 sgtif(.a(not_opc[5]), .b(opc[4]), .c(opc[3]), .d(not_opc[2]), .e(opc[1]), .f(opc[0]), .z(sgtir));
    and_6 sleif(.a(not_opc[5]), .b(opc[4]), .c(opc[3]), .d(opc[2]), .e(not_opc[1]), .f(not_opc[0]), .z(sleir));
    and_6 sgeif(.a(not_opc[5]), .b(opc[4]), .c(opc[3]), .d(opc[2]), .e(not_opc[1]), .f(opc[0]), .z(sgeir));

    and_6 lbf(.a(opc[5]), .b(not_opc[4]), .c(not_opc[3]), .d(not_opc[2]), .e(not_opc[1]), .f(not_opc[0]), .z(lbr));
    and_6 lhf(.a(opc[5]), .b(not_opc[4]), .c(not_opc[3]), .d(not_opc[2]), .e(not_opc[1]), .f(opc[0]), .z(lhr));
    and_6 lwf(.a(opc[5]), .b(not_opc[4]), .c(not_opc[3]), .d(not_opc[2]), .e(opc[1]), .f(opc[0]), .z(lwr));
    and_6 lbuf(.a(opc[5]), .b(not_opc[4]), .c(not_opc[3]), .d(opc[2]), .e(not_opc[1]), .f(not_opc[0]), .z(lbur));
    and_6 lhuf(.a(opc[5]), .b(not_opc[4]), .c(not_opc[3]), .d(opc[2]), .e(not_opc[1]), .f(opc[0]), .z(lhur));
    and_6 sbf(.a(opc[5]), .b(not_opc[4]), .c(opc[3]), .d(not_opc[2]), .e(not_opc[1]), .f(not_opc[0]), .z(sbr));
    and_6 shf(.a(opc[5]), .b(not_opc[4]), .c(opc[3]), .d(not_opc[2]), .e(not_opc[1]), .f(opc[0]), .z(shr));
    and_6 swf(.a(opc[5]), .b(not_opc[4]), .c(opc[3]), .d(not_opc[2]), .e(opc[1]), .f(opc[0]), .z(swr));
///////////////////////////////////////////////
    wire cond1, cond2;
    or_6 setcond1(.a(seqr), .b(sner), .c(sltr), .d(sgtr), .e(sler), .f(sger), .z(cond1));
    or_6 setcond2(.a(seqir), .b(sneir), .c(sltir), .d(sgtir), .e(sleir), .f(sgeir), .z(cond2));
    or_n setcond(.a(cond1), .b(cond2), .out(cond));
    // a total of 24 instrs would set cond flag

    wire allseq, allsne, allslt, allsgt, allsle, allsge;
    or_n setaa(.a(seqr), .b(seqir), .out(allseq));
    or_n setbb(.a(sner), .b(sneir), .out(allsne));
    or_n setcc(.a(sltr), .b(sltir), .out(allslt));
    or_n setdd(.a(sgtr), .b(sgtir), .out(allsgt));
    or_n setee(.a(sler), .b(sleir), .out(allsle));
    or_n setff(.a(sger), .b(sgeir), .out(allsge));
    assign condOp = (allseq == 1'b1) ? 3'b000 : 
    (allsne == 1'b1) ? 3'b001 : 
    (allslt == 1'b1) ? 3'b011 : 
    (allsgt == 1'b1) ? 3'b101 : 
    (allsle == 1'b1) ? 3'b010 : 
    (allsge == 1'b1) ? 3'b100 : 3'b000;

    wire notzero, branchi, branchii;
    and_n setbranchi(.a(beqzr), .b(ALUzero), .out(branchi));
    not_n fghj(.a(ALUzero), .out(notzero));
    and_n setbranchii(.a(bnezr), .b(notzero), .out(branchii));
    or_n setbranch(.a(branchi), .b(branchii), .out(Branch));

    or_6 setmemreg(.a(lbr), .b(lhr), .c(lwr), .d(lbur), .e(lhur), .f(1'b0), .z(MemReg));
    //Only load set mem2reg

    or_6 setmemw(.a(sbr), .b(shr), .c(swr), .d(1'b0), .e(1'b0), .f(1'b0), .z(MemW));
    //Only store set Memw

    wire invregw1, invregw2;
    or_6 invRW(.a(beqzr), .b(bnezr), .c(nopr), .d(sbr), .e(shr), .f(swr), .z(invregw1));
    or_6 invrwww(.a(jr), .b(jrr), .c(invregw1), .d(1'b0), .e(1'b0), .f(1'b0), .z(invregw2));
    //these 8 ops make regW 0
    not_n setregw(.a(invregw2), .out(RegW));

    /////////////ExtOp ALUop
    wire invExt;
    or_n invext(.a(adduir), .b(subuir), .out(invExt));
    not_n setext(.a(invExt), .out(ExtOp));
    //Only 2 unsigned imm make ExtOp 0, otherwise 1 or dc

    wire alladd, allsub, alland, allor, allxor, allsll, allsrl, allsra;

    or_6 aluadd(.a(addr), .b(addur), .c(addir), .d(adduir), .e(MemReg), .f(MemW), .z(alladd));
    // 4 adds + store + load return 0000 ALUop

    or_6 alusub(.a(subr), .b(subur), .c(subir), .d(subuir), .e(1'b0), .f(1'b0), .z(allsub));

    or_n aluand(.a(andr), .b(andir), .out(alland));
    or_n aluor(.a(orr), .b(orir), .out(allor));
    or_n aluxor(.a(xorr), .b(xorir), .out(allxor));
    or_n alusll(.a(sllr), .b(sllir), .out(allsll));
    or_n alusrl(.a(srlr), .b(srlir), .out(allsrl));
    or_n alusra(.a(srar), .b(srair), .out(allsra));

    assign ALUop = (alladd == 1'b1) ? 4'b0000 : 
    (allsub == 1'b1) ? 4'b0001 : 
    (alland == 1'b1) ? 4'b0100 : 
    (allor == 1'b1) ? 4'b0101 : 
    (allxor == 1'b1) ? 4'b0110 : 
    (allsll == 1'b1) ? 4'b1000 : 
    (allsrl == 1'b1) ? 4'b1001 : 
    (allsra == 1'b1) ? 4'b1010 : 4'b0000;
    
    or_n setds(.a(lwr), .b(swr), .out(dsize[1]));   //if word, dsize 11
    or_6 setds2(.a(lhr), .b(lwr), .c(lhur), .d(shr), .e(swr), .f(1'b0), .z(dsize[0]));
    wire invdext;
    or_n setinvdext(.a(lbur), .b(lhur), .out(invdext));
    not_n setdext(.a(invdext), .out(dextop));

    or_n setjal(.a(jr), .b(jalr), .out(jflag));
    or_n setjalr(.a(jalrr), .b(jrr), .out(jrflag));
    or_n setkkkk(.a(jalr), .b(jalrr), .out(jalflag));
    assign lhiflag = lhir;
    
endmodule

