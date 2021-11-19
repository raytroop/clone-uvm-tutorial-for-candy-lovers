//------------------------------------------------------------------------------
// Class: jelly_bean_recipe_reg
//------------------------------------------------------------------------------

class jelly_bean_recipe_reg extends uvm_reg;
   `uvm_object_utils( jelly_bean_recipe_reg )

   rand uvm_reg_field flavor;
   rand uvm_reg_field color;
   rand uvm_reg_field sugar_free;
   rand uvm_reg_field sour;

   constraint flavor_color_con {
      flavor.value != jelly_bean_types::NO_FLAVOR;
      flavor.value == jelly_bean_types::APPLE
                   -> color.value != jelly_bean_types::BLUE;
      flavor.value == jelly_bean_types::BLUEBERRY
                   -> color.value == jelly_bean_types::BLUE;
      flavor.value <= jelly_bean_types::CHOCOLATE;
   }

   function new( string name = "jelly_bean_recipe_reg" );
      super.new( .name( name ), .n_bits( 7 ), .has_coverage( UVM_NO_COVERAGE ) );
   endfunction: new

   virtual function void build();
      flavor = uvm_reg_field::type_id::create( "flavor" );
      flavor.configure( .parent                 ( this ), 
                        .size                   ( 3    ), 
                        .lsb_pos                ( 0    ), 
                        .access                 ( "WO" ), 
                        .volatile               ( 0    ),
                        .reset                  ( 0    ), 
                        .has_reset              ( 1    ), 
                        .is_rand                ( 1    ), 
                        .individually_accessible( 1    ) );

      color = uvm_reg_field::type_id::create( "color" );
      color.configure( .parent                 ( this ), 
                       .size                   ( 2    ), 
                       .lsb_pos                ( 3    ), 
                       .access                 ( "WO" ), 
                       .volatile               ( 0    ),
                       .reset                  ( 0    ), 
                       .has_reset              ( 1    ), 
                       .is_rand                ( 1    ), 
                       .individually_accessible( 1    ) );

      sugar_free = uvm_reg_field::type_id::create( "sugar_free" );
      sugar_free.configure( .parent                 ( this ), 
                            .size                   ( 1    ), 
                            .lsb_pos                ( 5    ), 
                            .access                 ( "WO" ), 
                            .volatile               ( 0    ),
                            .reset                  ( 0    ), 
                            .has_reset              ( 1    ), 
                            .is_rand                ( 1    ), 
                            .individually_accessible( 1    ) );

      sour = uvm_reg_field::type_id::create( "sour" );
      sour.configure( .parent                 ( this ), 
                      .size                   ( 1    ), 
                      .lsb_pos                ( 6    ), 
                      .access                 ( "WO" ), 
                      .volatile               ( 0    ),
                      .reset                  ( 0    ), 
                      .has_reset              ( 1    ), 
                      .is_rand                ( 1    ), 
                      .individually_accessible( 1    ) );
   endfunction: build
endclass: jelly_bean_recipe_reg

//------------------------------------------------------------------------------
// Class: jelly_bean_taste_reg
//------------------------------------------------------------------------------

class jelly_bean_taste_reg extends uvm_reg;
   `uvm_object_utils( jelly_bean_taste_reg )

   rand uvm_reg_field taste;

   function new( string name = "jelly_bean_taste_reg" );
      super.new( .name( name ), .n_bits( 2 ), .has_coverage( UVM_NO_COVERAGE ) );
   endfunction: new


   virtual function void build();
      taste = uvm_reg_field::type_id::create( "taste" );
      taste.configure( .parent                 ( this ), 
                       .size                   ( 2    ), 
                       .lsb_pos                ( 0    ), 
                       .access                 ( "RO" ), 
                       .volatile               ( 1    ),
                       .reset                  ( 0    ), 
                       .has_reset              ( 1    ), 
                       .is_rand                ( 1    ), 
                       .individually_accessible( 1    ) );
   endfunction: build
endclass: jelly_bean_taste_reg

//------------------------------------------------------------------------------
// Class: jelly_bean_reg_block
//------------------------------------------------------------------------------

class jelly_bean_reg_block extends uvm_reg_block;
   `uvm_object_utils( jelly_bean_reg_block )

   rand jelly_bean_recipe_reg jb_recipe_reg;
   rand jelly_bean_taste_reg  jb_taste_reg;
   uvm_reg_map                reg_map;

   function new( string name = "jelly_bean_reg_block" );
      super.new( .name( name ), .has_coverage( UVM_NO_COVERAGE ) );
   endfunction: new

   virtual function void build();
      jb_recipe_reg = jelly_bean_recipe_reg::type_id::create( "jb_recipe_reg" );
      jb_recipe_reg.configure( .blk_parent( this ) );
      jb_recipe_reg.build();

      jb_taste_reg = jelly_bean_taste_reg::type_id::create( "jb_taste_reg" );
      jb_taste_reg.configure( .blk_parent( this ) );
      jb_taste_reg.build();

      reg_map = create_map( .name( "reg_map" ), .base_addr( 8'h00 ), 
                            .n_bytes( 1 ), .endian( UVM_LITTLE_ENDIAN ) );
      reg_map.add_reg( .rg( jb_recipe_reg ), .offset( 8'h00 ), .rights( "WO" ) );
      reg_map.add_reg( .rg( jb_taste_reg  ), .offset( 8'h01 ), .rights( "RO" ) );
      lock_model(); // finalize the address mapping
   endfunction: build

endclass: jelly_bean_reg_block   

//------------------------------------------------------------------------------
// Class: jelly_bean_reg_adapter
//------------------------------------------------------------------------------

class jelly_bean_reg_adapter extends uvm_reg_adapter;
   `uvm_object_utils( jelly_bean_reg_adapter )

   function new( string name = "" );
      super.new( name );
      supports_byte_enable = 0;
      provides_responses   = 0;
   endfunction: new

   virtual function uvm_sequence_item reg2bus( const ref uvm_reg_bus_op rw );
      jelly_bean_transaction jb_tx 
        = jelly_bean_transaction::type_id::create("jb_tx");

      if ( rw.kind == UVM_READ )       jb_tx.command = jelly_bean_types::READ;
      else if ( rw.kind == UVM_WRITE ) jb_tx.command = jelly_bean_types::WRITE;
      else                             jb_tx.command = jelly_bean_types::NO_OP;
      if ( rw.kind == UVM_WRITE )
        { jb_tx.sour, jb_tx.sugar_free, jb_tx.color, jb_tx.flavor } = rw.data;
      return jb_tx;
   endfunction: reg2bus

   virtual function void bus2reg( uvm_sequence_item bus_item,
                                  ref uvm_reg_bus_op rw );
      jelly_bean_transaction jb_tx;

      if ( ! $cast( jb_tx, bus_item ) ) begin
         `uvm_fatal( get_name(),
                     "bus_item is not of the jelly_bean_transaction type." )
         return;
      end

      rw.kind = ( jb_tx.command == jelly_bean_types::READ ) ? UVM_READ : UVM_WRITE;
      if ( jb_tx.command == jelly_bean_types::READ )
        rw.data = jb_tx.taste;
      else if ( jb_tx.command == jelly_bean_types::WRITE )
        rw.data = { jb_tx.sour, jb_tx.sugar_free, jb_tx.color, jb_tx.flavor };
      rw.status = UVM_IS_OK;
   endfunction: bus2reg
endclass: jelly_bean_reg_adapter

//------------------------------------------------------------------------------
// jelly_bean_reg_predictor
//------------------------------------------------------------------------------

typedef uvm_reg_predictor#( jelly_bean_transaction ) jelly_bean_reg_predictor;

//------------------------------------------------------------------------------
// jelly_bean_recipe_reg_callback
//------------------------------------------------------------------------------

class jelly_bean_recipe_reg_callback extends uvm_reg_cbs;
  `uvm_object_utils( jelly_bean_recipe_reg_callback )
  
  jelly_bean_taste_reg jb_taste_reg;
  
  function new( string name = "jelly_bean_recipe_reg_callback" );
    super.new( name );
  endfunction: new
  
  virtual task post_write( uvm_reg_item rw );
    jelly_bean_types::flavor_e flavor;
    bit                        sour;

    flavor = jelly_bean_types::flavor_e'( rw.value[0][2:0] );
    sour   = rw.value[0][6];
    `uvm_info( "post_write", $sformatf( "%s, flavor=%0d sour=%b", rw.convert2string(), flavor, sour ), UVM_DEBUG )

    if ( flavor == jelly_bean_types::CHOCOLATE && sour )
      assert( jb_taste_reg.taste.predict( jelly_bean_types::YUCKY ) );
    else
      assert( jb_taste_reg.taste.predict( jelly_bean_types::YUMMY ) );
  endtask: post_write
  
endclass: jelly_bean_recipe_reg_callback

//==============================================================================
// Copyright (c) 2011-2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================