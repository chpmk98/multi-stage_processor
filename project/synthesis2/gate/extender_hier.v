
module extender ( extOp, imm16, imm32 );
  input [15:0] imm16;
  output [31:0] imm32;
  input extOp;
  wire   \imm16[15] , \imm32[31] , imm32_14, imm32_13, imm32_12, imm32_11,
         imm32_10, imm32_9, imm32_8, imm32_7, imm32_6, imm32_5, imm32_4,
         imm32_3, imm32_2, imm32_1, imm32_0;
  assign imm32[15] = \imm16[15] ;
  assign \imm16[15]  = imm16[15];
  assign imm32[16] = \imm32[31] ;
  assign imm32[17] = \imm32[31] ;
  assign imm32[18] = \imm32[31] ;
  assign imm32[19] = \imm32[31] ;
  assign imm32[20] = \imm32[31] ;
  assign imm32[21] = \imm32[31] ;
  assign imm32[22] = \imm32[31] ;
  assign imm32[23] = \imm32[31] ;
  assign imm32[24] = \imm32[31] ;
  assign imm32[25] = \imm32[31] ;
  assign imm32[26] = \imm32[31] ;
  assign imm32[27] = \imm32[31] ;
  assign imm32[28] = \imm32[31] ;
  assign imm32[29] = \imm32[31] ;
  assign imm32[30] = \imm32[31] ;
  assign imm32[31] = \imm32[31] ;
  assign imm32[14] = imm32_14;
  assign imm32_14 = imm16[14];
  assign imm32[13] = imm32_13;
  assign imm32_13 = imm16[13];
  assign imm32[12] = imm32_12;
  assign imm32_12 = imm16[12];
  assign imm32[11] = imm32_11;
  assign imm32_11 = imm16[11];
  assign imm32[10] = imm32_10;
  assign imm32_10 = imm16[10];
  assign imm32[9] = imm32_9;
  assign imm32_9 = imm16[9];
  assign imm32[8] = imm32_8;
  assign imm32_8 = imm16[8];
  assign imm32[7] = imm32_7;
  assign imm32_7 = imm16[7];
  assign imm32[6] = imm32_6;
  assign imm32_6 = imm16[6];
  assign imm32[5] = imm32_5;
  assign imm32_5 = imm16[5];
  assign imm32[4] = imm32_4;
  assign imm32_4 = imm16[4];
  assign imm32[3] = imm32_3;
  assign imm32_3 = imm16[3];
  assign imm32[2] = imm32_2;
  assign imm32_2 = imm16[2];
  assign imm32[1] = imm32_1;
  assign imm32_1 = imm16[1];
  assign imm32[0] = imm32_0;
  assign imm32_0 = imm16[0];

  AND2_X4 U2 ( .A1(\imm16[15] ), .A2(extOp), .ZN(\imm32[31] ) );
endmodule

