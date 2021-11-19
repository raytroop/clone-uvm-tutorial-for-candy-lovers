comp:
	vlog design.sv testbench.sv -L ${QUESTA_HOME}/uvm-1.2 -timescale=1ns/1ns
run:
	vsim -c work.top -do "run -all; exit" -L ${QUESTA_HOME}/uvm-1.2 +UVM_TESTNAME=jelly_bean_reg_test
clean:
	rm -rf transcript work


