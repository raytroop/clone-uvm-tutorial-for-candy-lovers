//------------------------------------------------------------------------------
// Module: top
//------------------------------------------------------------------------------

module top;
   import uvm_pkg::*;

   reg clk;
   
   jelly_bean_if        jb_if1( clk );
   jelly_bean_if        jb_if2( clk );
   jelly_bean_subsystem dut( jb_if1, jb_if2 );

   initial begin
      clk = 0;
      #5ns ;
      forever #5ns clk = ! clk;
   end

   initial begin
      uvm_config_db#( virtual jelly_bean_if )::set
	( .cntxt( null ), .inst_name( "uvm_test_top" ), .field_name( "jb_if1" ), .value( jb_if1 ) );
      uvm_config_db#( virtual jelly_bean_if )::set
	( .cntxt( null ), .inst_name( "uvm_test_top" ), .field_name( "jb_if2" ), .value( jb_if2 ) );
      run_test();
   end
endmodule: top
  
//==============================================================================
// Copyright (c) 2011-2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================