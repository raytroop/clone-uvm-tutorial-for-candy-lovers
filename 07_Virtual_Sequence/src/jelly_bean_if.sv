//------------------------------------------------------------------------------
// Interface: jelly_bean_if
//------------------------------------------------------------------------------

interface jelly_bean_if( input bit clk );
   logic [2:0] flavor;
   logic [1:0] color;
   logic       sugar_free;
   logic       sour;
   logic [1:0] taste;

   clocking master_cb @( posedge clk );
      default input #1step output #1ns;
      output flavor, color, sugar_free, sour;
      input  taste;
   endclocking: master_cb

   clocking slave_cb @( posedge clk );
      default input #1step output #1ns;
      input  flavor, color, sugar_free, sour;
      output taste;
   endclocking: slave_cb

   modport master_mp( input clk, taste, output flavor, color, sugar_free, sour );
   modport slave_mp ( input clk, flavor, color, sugar_free, sour, output taste );
   modport master_sync_mp( clocking master_cb );
   modport slave_sync_mp ( clocking slave_cb  );
endinterface: jelly_bean_if

//==============================================================================
     // Copyright (c) 2011-2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================