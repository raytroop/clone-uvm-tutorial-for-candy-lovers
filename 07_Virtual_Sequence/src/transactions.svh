   //---------------------------------------------------------------------------
   // Class: jelly_bean_transaction
   //---------------------------------------------------------------------------

class jelly_bean_transaction extends uvm_sequence_item;
   typedef enum bit[2:0] { NO_FLAVOR, APPLE, CHOCOLATE, CINNAMON, COCONUT,
			   LEMON, STRAWBERRY, VANILLA  } flavor_e;
   typedef enum bit[1:0] { RED, GREEN, YELLOW, WHITE   } color_e;
   typedef enum bit[1:0] { UNKNOWN_TASTE, YUMMY, YUCKY } taste_e;

   rand flavor_e flavor;
   rand color_e  color;
   rand bit      sugar_free;
   rand bit      sour;
   taste_e       taste; // response

   constraint flavor_color_con {
      flavor != NO_FLAVOR;
      flavor == APPLE      -> color inside { RED, GREEN };
      flavor == CINNAMON   -> color == RED;
      flavor == COCONUT    -> color == WHITE;
      flavor == LEMON      -> color == YELLOW;
      flavor == STRAWBERRY -> color == RED;
      flavor == VANILLA    -> color == WHITE;
   }

   function new( string name = "" );
      super.new( name );
   endfunction: new

   `uvm_object_utils_begin( jelly_bean_transaction )
      `uvm_field_enum( flavor_e, flavor, UVM_ALL_ON )
      `uvm_field_enum( color_e,  color,  UVM_ALL_ON )
      `uvm_field_int ( sugar_free,       UVM_ALL_ON )
      `uvm_field_int ( sour,             UVM_ALL_ON )
      `uvm_field_enum( taste_e,  taste,  UVM_ALL_ON )
   `uvm_object_utils_end
endclass: jelly_bean_transaction

//==============================================================================
// Copyright (c) 2011-2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================