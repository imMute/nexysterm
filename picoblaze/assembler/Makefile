.SUFFIXES:

all: nterm.vhd nterm_jtag.vhd

nterm.mem nterm.hex: nterm.psm
	./pBlazASM.exe -m -l -v nterm.psm
	./pBlazASM.exe -x -l -v nterm.psm

nterm.vhd: nterm.mem
	./pBlazMRG.exe -v -c nterm.mem -e nterm -t ROM_form.VHD nterm.vhd

nterm_jtag.vhd: nterm.mem
	./pBlazMRG.exe -v -c nterm.mem -e nterm -t JTAG_Loader_ROM_form.vhd nterm_jtag.vhd
clean:
	-rm CONSTANT.TXT LABELS.TXT *.coe *.log PASS*.DAT
	-rm *.mem *.hex *.lst *.dec 
	-rm nterm.mem nterm.vhd nterm.hex nterm.lst