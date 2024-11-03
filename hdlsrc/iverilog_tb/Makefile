file.vcd: wave
	vvp wave
wave: *.v
	iverilog -o wave -y ./ *.v

.PHONY: tb
tb:
	gtkwave file.vcd
