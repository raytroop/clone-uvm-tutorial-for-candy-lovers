comp:
	vlog tutorial_21.sv -L ${QUESTA_HOME}/uvm-1.2
run:
	vsim -c work.top -do "run -all; exit" -L ${QUESTA_HOME}/uvm-1.2 +UVM_TESTNAME=jelly_bean_test
clean:
	rm -rf transcript work


