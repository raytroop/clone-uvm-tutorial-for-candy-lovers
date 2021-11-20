comp:
	vlog design.sv testbench.sv -L ${QUESTA_HOME}/uvm-1.2 -timescale=1ns/1ns +acc
run:
	vsim -c work.top -do "run -all; exit" -L ${QUESTA_HOME}/uvm-1.2 +UVM_TESTNAME=jelly_bean_reg_test +UVM_VERBOSITY=UVM_DEBUG
clean:
	rm -rf transcript work dump.vcd tr_db.log


