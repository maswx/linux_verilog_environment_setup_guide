run:
	iverilog -o simv -f tb_file_list.f
	./simv
	gtkwave simv.vcd

clean:
	rm simv
	rm simv.vcd
