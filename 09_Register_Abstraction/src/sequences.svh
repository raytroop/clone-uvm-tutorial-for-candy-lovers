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
      uvm_status_e               status;
      uvm_reg_data_t             value;

      $cast( jb_reg_block, model );
      flavor     = jelly_bean_types::APPLE;
      color      = jelly_bean_types::GREEN;
      sugar_free = 0;
      sour       = 1;
      
      write_reg( jb_reg_block.jb_recipe_reg, status, { sour, sugar_free, color, flavor } );
      read_reg( jb_reg_block.jb_taste_reg, status, value );
   endtask: body
     
endclass: jelly_bean_reg_sequence

// custom sequence, skip adapter
class jelly_bean_reg_simple_sequence extends uvm_reg_sequence;
   `uvm_object_utils( jelly_bean_reg_simple_sequence )

   function new( string name = "" );
      super.new( name );
   endfunction: new

   virtual task body();
      jelly_bean_transaction jb_tx;

      // read
      jb_tx = jelly_bean_transaction::type_id::create( .name( "jb_tx" ) );
      start_item( jb_tx );
      jb_tx.command = jelly_bean_types::READ;
      finish_item(jb_tx);
      //`uvm_info(get_type_name(), jb_tx.sprint(), UVM_NONE)   // taste NO_TASTE
      // write
      jb_tx = jelly_bean_transaction::type_id::create( .name( "jb_tx" ) );
      start_item( jb_tx );
      jb_tx.flavor     = jelly_bean_types::APPLE;
      jb_tx.color      = jelly_bean_types::GREEN;
      jb_tx.sugar_free = 0;
      jb_tx.sour       = 1;
      jb_tx.command = jelly_bean_types::WRITE;
      finish_item(jb_tx);
      // read
      jb_tx = jelly_bean_transaction::type_id::create( .name( "jb_tx" ) );
      start_item( jb_tx );
      jb_tx.command = jelly_bean_types::READ;
      finish_item(jb_tx);
      //`uvm_info(get_type_name(), jb_tx.sprint(), UVM_NONE)   //taste YUMMY
   endtask: body
     
endclass: jelly_bean_reg_simple_sequence
//==============================================================================
// Copyright (c) 2011-2015 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
