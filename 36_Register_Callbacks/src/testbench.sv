//------------------------------------------------------------------------------
// Module: top
//------------------------------------------------------------------------------

module top;
   import uvm_pkg::*;

   reg clk;
   
   jelly_bean_if     jb_if( clk );
   jelly_bean_taster jb_taster( jb_if );

   initial begin
      clk = 0;
      #5ns ;
      forever #5ns clk = ! clk;
   end
  
   initial begin
     $dumpfile( "dump.vcd" );
     $dumpvars;
   end

   initial begin
      uvm_config_db#( virtual jelly_bean_if )::set( .cntxt( null ), 
                                                    .inst_name( "uvm_test_top" ),
                                                    .field_name( "jb_if" ),
                                                    .value( jb_if ) );
      run_test();
   end
endmodule: top

//==============================================================================
// Copyright (c) 2011-2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
