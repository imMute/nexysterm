.SUFFIXES:

all: nterm.vhd

nterm.mem: nterm.psm
	./pBlazASM.exe -m -k -v nterm.psm

nterm.vhd: nterm.mem
	./pBlazMRG.exe -v -c nterm.mem -e nterm -t ROM_form.VHD nterm.vhd

clean:
	-rm CONSTANT.TXT LABELS.TXT *.coe *.log PASS*.DAT
	-rm *.mem *.hex *.lst *.dec 
	-rm nterm.mem nterm.vhd nterm.hex nterm.lst