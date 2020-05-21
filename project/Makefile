
ASM = fib/fib.asm
TESTPROG = pp_test_fib8
TOPLEVEL = pptb

#TEST2PROG = test_pipeline
#TOPLEVEL2 = test_find_min

# All verilog files (currently only ".v" files in this directory)
VERILOGFILES = *.v

# Full path to tools (avoids path issues)
IVERILOG = iverilog
DLXASM = /vol/eecs362/scripts/dlxasm

# Generated Files
HEX_DATA = fib/data.hex
HEX_INSTR= fib/instr.hex
HEXFILES = ${HEX_DATA} ${HEX_INSTR}
TEST_GENERATED = ${HEXFILES} ${TESTPROG} ${TEST2PROG}
EXTRA_GENERATED = ${ASM}.exe

default: ${TEST_GENERATED} ;

${TESTPROG}: ${VERILOGFILES} ;
	${IVERILOG} ${VERILOGFILES} -s ${TOPLEVEL} -o ${TESTPROG};

${TEST2PROG}: ${VERILOGFILES} ;
	${IVERILOG} ${VERILOGFILES} -s ${TOPLEVEL2} -o ${TEST2PROG};

# DLXASM generates Verilog-friendly hex files from an ASM file
${HEXFILES}: ${DLXASM} ${ASM} ;
	${DLXASM} -D ${HEX_DATA} -C ${HEX_INSTR} ${ASM}

.PHONY: clean
clean: ;
	rm -f ${TEST_GENERATED} ${EXTRA_GENERATED}
