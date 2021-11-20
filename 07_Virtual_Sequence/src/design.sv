`include "uvm_macros.svh"
`include "jelly_bean_pkg.sv"
`include "jelly_bean_if.sv"

   //---------------------------------------------------------------------------
   // Module: jelly_bean_taster
   //   This is the DUT.
   //---------------------------------------------------------------------------

module jelly_bean_taster( jelly_bean_if.slave_mp jb_if );
   import jelly_bean_pkg::*;

   always @ ( posedge jb_if.clk ) begin
      if ( jb_if.flavor == jelly_bean_transaction::NO_FLAVOR ) begin
	 jb_if.taste <= jelly_bean_transaction::UNKNOWN_TASTE;
      end if ( jb_if.flavor == jelly_bean_transaction::CHOCOLATE && jb_if.sour ) begin
	 jb_if.taste <= jelly_bean_transaction::YUCKY;
      end else begin
	 jb_if.taste <= jelly_bean_transaction::YUMMY;
      end
   end
endmodule: jelly_bean_taster

module jelly_bean_subsystem( jelly_bean_if.slave_mp jb_if1,
			     jelly_bean_if.slave_mp jb_if2 );
   import jelly_bean_pkg::*;

   jelly_bean_taster taster1( .jb_if( jb_if1 ) );
   jelly_bean_taster taster2( .jb_if( jb_if2 ) );
endmodule: jelly_bean_subsystem

//==============================================================================
// Copyright (c) 2011-2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================