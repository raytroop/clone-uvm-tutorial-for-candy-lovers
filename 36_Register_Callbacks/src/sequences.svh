//------------------------------------------------------------------------------
// Class: jelly_bean_sequence
//------------------------------------------------------------------------------
   
class jelly_bean_sequence extends uvm_sequence#( jelly_bean_transaction );
   `uvm_object_utils( jelly_bean_sequence )

   function new( string name = "" );
      super.new( name );
   endfunction: new

   task body();
      jelly_bean_transaction jb_tx;
      jb_tx = jelly_bean_transaction::type_id::create( .name( "jb_tx" ) );
      start_item( jb_tx );
      jb_tx.flavor     = jelly_bean_types::APPLE;
      jb_tx.color      = jelly_bean_types::GREEN;
      jb_tx.sugar_free = 0;
      jb_tx.sour       = 1;
      finish_item(jb_tx);
   endtask: body
endclass: jelly_bean_sequence

//------------------------------------------------------------------------------
// Class: jelly_bean_reg_sequence
//------------------------------------------------------------------------------

class jelly_bean_reg_sequence extends uvm_reg_sequence;
   `uvm_object_utils( jelly_bean_reg_sequence )

   function new( string name = "" );
      super.new( name );
   endfunction: new

   virtual task body();
      jelly_bean_reg_block       jb_reg_block;
      jelly_bean_types::flavor_e flavor;
      jelly_bean_types::color_e  color;
      bit                        sugar_free;
      bit                        sour;
      jelly_bean_types::taste_e  taste;
      uvm_status_e               status;
      uvm_reg_data_t             value;
     
      jelly_bean_recipe_reg_callback jb_recipe_reg_cb;

      $cast( jb_reg_block, model );
      flavor     = jelly_bean_types::APPLE;
      color      = jelly_bean_types::GREEN;
      sugar_free = 0;
      sour       = 1;
      
      jb_recipe_reg_cb = jelly_bean_recipe_reg_callback::type_id::create( "jb_recipe_reg_cb" );
      jb_recipe_reg_cb.jb_taste_reg = jb_reg_block.jb_taste_reg;
      uvm_reg_cb::add( jb_reg_block.jb_recipe_reg, jb_recipe_reg_cb );
      
      jb_reg_block.jb_recipe_reg.write( status, { sour, sugar_free, color, flavor } );
      taste = jelly_bean_types::taste_e'( jb_reg_block.jb_taste_reg.taste.get_mirrored_value() );
      `uvm_info( "body", $sformatf( "taste=%s", taste.name() ), UVM_NONE )
	/*
      read_reg( jb_reg_block.jb_taste_reg, status, value );
      `uvm_info( "body", $sformatf( "value=%0d", value ), UVM_NONE )
      jb_reg_block.jb_taste_reg.mirror( status, UVM_CHECK );
      taste = jelly_bean_types::taste_e'( jb_reg_block.jb_taste_reg.taste.get_mirrored_value() );
     `uvm_info( "body", $sformatf( "status=%s taste=%s", status.name(), taste.name() ), UVM_NONE )
     */
   endtask: body
     
endclass: jelly_bean_reg_sequence

//==============================================================================
// Copyright (c) 2011-2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================