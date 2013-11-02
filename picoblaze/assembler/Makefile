.SUFFIXES:

all: nterm.vhd
#all: nterm_jtag.vhd

SOURCES := main.psm  subroutines.psm  constants.psm 

nterm.mem nterm.hex: $(SOURCES)
	./pBlazASM.exe -mnterm.mem -lnterm.lst -v $^
	./pBlazASM.exe -xnterm.hex -lnterm.lst -v $^

nterm.vhd: nterm.mem
	./pBlazMRG.exe -v -c nterm.mem -e nterm -t ROM_form.VHD nterm.vhd

nterm_jtag.vhd: nterm.mem
	./pBlazMRG.exe -v -c nterm.mem -e nterm -t JTAG_Loader_ROM_form.vhd nterm_jtag.vhd
clean:
	-rm CONSTANT.TXT LABELS.TXT *.coe *.log PASS*.DAT
	-rm *.mem *.hex *.lst *.dec 
	-rm nterm.mem nterm.vhd nterm.hex nterm.lst
