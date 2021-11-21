comp:
	vlog design.sv testbench.sv -L ${QUESTA_HOME}/uvm-1.2
run_FIFO:
	vsim -c work.top -do "run -all; exit" -L ${QUESTA_HOME}/uvm-1.2 +UVM_TESTNAME=jelly_bean_FIFO_test
run_RANDOM:
	vsim -c work.top -do "run -all; exit" -L ${QUESTA_HOME}/uvm-1.2 +UVM_TESTNAME=jelly_bean_RANDOM_test
run_STRICT_FIFO:
	vsim -c work.top -do "run -all; exit" -L ${QUESTA_HOME}/uvm-1.2 +UVM_TESTNAME=jelly_bean_STRICT_FIFO_test
run_STRICT_RANDOM:
	vsim -c work.top -do "run -all; exit" -L ${QUESTA_HOME}/uvm-1.2 +UVM_TESTNAME=jelly_bean_STRICT_RANDOM_test
run_WEIGHTED:
	vsim -c work.top -do "run -all; exit" -L ${QUESTA_HOME}/uvm-1.2 +UVM_TESTNAME=jelly_bean_WEIGHTED_test
run_USER:
	vsim -c work.top -do "run -all; exit" -L ${QUESTA_HOME}/uvm-1.2 +UVM_TESTNAME=jelly_bean_USER_test
clean:
	rm -rf transcript work


