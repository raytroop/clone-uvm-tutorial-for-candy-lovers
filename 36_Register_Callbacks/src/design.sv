`include "uvm_macros.svh"
`include "jelly_bean_pkg.sv"
`include "jelly_bean_if.sv"

//------------------------------------------------------------------------------
// Module: jelly_bean_taster
//   This is the DUT.
//------------------------------------------------------------------------------

module jelly_bean_taster( jelly_bean_if.slave_mp jb_slave_if );
   import jelly_bean_pkg::*;

   reg [2:0] flavor;
   reg [1:0] color;
   reg       sugar_free;
   reg       sour;
   reg [1:0] command;
   reg [1:0] taste;

   initial begin
      flavor     = 0;
      color      = 0;
      sugar_free = 0;
      sour       = 0;
      command    = 0;
      taste      = 0;
   end

   always @ ( posedge jb_slave_if.clk ) begin
      if ( jb_slave_if.command == jelly_bean_types::WRITE ) begin
         flavor     <= jb_slave_if.flavor;
         color      <= jb_slave_if.color;
         sugar_free <= jb_slave_if.sugar_free;
         sour       <= jb_slave_if.sour;
      end /*else if ( jb_slave_if.command == jelly_bean_types::READ ) begin
         jb_slave_if.taste <= taste;
      end*/
   end
  
  always @ ( posedge jb_slave_if.clk ) begin
      if ( jb_slave_if.flavor == jelly_bean_types::CHOCOLATE &&
           jb_slave_if.sour ) begin
         taste = jelly_bean_types::YUCKY;
      end else if ( jb_slave_if.flavor != jelly_bean_types::NO_FLAVOR ) begin
         taste = jelly_bean_types::YUMMY;
      end
      jb_slave_if.taste <= taste;
  end
endmodule: jelly_bean_taster

//==============================================================================
// Copyright (c) 2011-2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
