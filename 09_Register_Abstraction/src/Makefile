comp:
	vlog design.sv testbench.sv -L ${QUESTA_HOME}/uvm-1.1d
run:
	vsim -c work.top -do "run -all; exit" -L ${QUESTA_HOME}/uvm-1.1d +UVM_TESTNAME=jelly_bean_reg_test
run_simple:
	vsim -c work.top -do "run -all; exit" -L ${QUESTA_HOME}/uvm-1.1d +UVM_TESTNAME=jelly_bean_reg_simple_test
clean:
	rm -rf transcript work


