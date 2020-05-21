
module imem(addr, instr);

   parameter SIZE=4096;

   parameter OFFSET=0;


   input [0:31] addr;

   output [0:31] instr;

   reg [0:7] 	 mem[0:(SIZE-1)];


   wire [0:31] 	 phys_addr;


   assign phys_addr = addr - OFFSET;

   assign instr = {mem[phys_addr],mem[phys_addr+1],mem[phys_addr+2],mem[phys_addr+3]};

   endmodule // imem

module dmem(addr, rData, wData, writeEnable, dsize, clk);

   parameter SIZE=32768;


   input [0:31] addr, wData;

   input 	writeEnable, clk;

   input [0:1] 	dsize;
 // equivalent to bytes-1 ( 3=Word, 1=Halfword, 0=Byte)
   output [0:31] rData;

   reg [0:7] 	 mem[0:(SIZE-1)];


    // Write
       always @ (posedge clk) begin
        if (writeEnable) begin
           $display("writing to mem at %x val %x size %2d", addr, wData, dsize);

            case (dsize)
              2'b11: begin
                 // word
		 {mem[addr], mem[addr+1], mem[addr+2], mem[addr+3]} <= wData[0:31];

              end
              2'b10: begin
                 // bad
		 $display("Invalid dsize: %x", dsize);

              end
              2'b01: begin
                 // halfword
		 {mem[addr], mem[addr+1]} <= wData[16:31];

              end
              2'b00: begin
                 // byte
		 mem[addr] <= wData[24:31];

              end
              default: $display("Invalid dsize: %x", dsize);

            endcase
        end
    end
    // Read
   assign rData = {mem[addr], mem[addr+1], mem[addr+2], mem[addr+3]};

endmodule // dmem

// Test module. Loads data files
module memload_example();

   parameter IMEMFILE = "instr.hex";

   parameter DMEMFILE = "data.hex";

   reg [8*80-1:0] filename;

   reg [0:31] 	  iaddr, daddr, dwdata;

   wire [0:31] 	  instr, drdata;

   reg 		  dwrite;

   reg [0:1] 	  dsize;

   reg 		  clk;


   integer 	  dfileobj, dmaddr, r, k, i;


   imem #(.SIZE(1024)) IMEM(.addr(iaddr), .instr(instr));

   dmem #(.SIZE(16384)) DMEM(.addr(daddr), .rData(drdata), .wData(dwdata), .writeEnable(dwrite), .dsize(dsize), .clk(clk));


    initial begin
        // Clear DMEM
       for (i = 0; i < DMEM.SIZE; i = i+1)
         DMEM.mem[i] = 8'h0;


        // Load IMEM from file
               if (!$value$plusargs("instrfile=%s", filename)) begin
		  filename = IMEMFILE;

        end
       $readmemh(filename, IMEM.mem);

        // Load DMEM from file
               if (!$value$plusargs("datafile=%s", filename)) begin
		  filename = DMEMFILE;

        end
       $readmemh(filename, DMEM.mem);


        //// Debug: dump memory
               //$writememh("imem", IMEM.mem);
               //$writememh("dmem", DMEM.mem);
       
        // Read out some values. Note clock ticks between setting values
               // & reading values in tests.
               // - First two instructions
   //    iaddr = 32'h0;

   //     #1
   //       $display("Instr [%x] = %x", iaddr, instr);

    //   iaddr = 32'h4;

    //    #1
    //      $display("Instr [%x] = %x", iaddr, instr);

        // - Some Data values
               // 'monitor' follows signals automatically as they change
    //   $monitor("addr= %x data = %x", daddr, drdata);

    //   daddr = 32'h2000;

    //    #1
    //      daddr = 32'h2001;

    end // initial
   endmodule
// // // // // // // // // // // // // // // // // // // // 	 // 	
