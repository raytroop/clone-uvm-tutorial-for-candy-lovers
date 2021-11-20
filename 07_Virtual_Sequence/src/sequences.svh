//---------------------------------------------------------------------------
// Class: same_flavored_jelly_beans_sequence
//   Sequence of transactions.
//---------------------------------------------------------------------------

class same_flavored_jelly_beans_sequence extends uvm_sequence#( jelly_bean_transaction );

   // knobs

   rand int unsigned num_jelly_beans;
   rand jelly_bean_transaction::flavor_e flavor;

   local same_flavored_jelly_beans_sequence self = this;

   constraint num_jelly_beans_con { num_jelly_beans inside { [1:4] }; }

   function new( string name = "" );
      super.new( name );
   endfunction: new

   task body();
      jelly_bean_transaction jb_tx;
      repeat ( num_jelly_beans ) begin
         jb_tx = jelly_bean_transaction::type_id::create( .name( "jb_tx" ) );
         start_item( jb_tx );
         `ifndef CL_USE_MODELSIM
            // 'this' refers to the jb_tx object (not the current instance of same_flavored_jelly_beans_sequence), 
            // whereas 'self' refers to the current instance of same_flavored_jelly_beans_sequence.
            assert( jb_tx.randomize() with { this.flavor == self.flavor; } );
         `endif
         `uvm_info( get_name(), { "\n", jb_tx.sprint() }, UVM_LOW )
         finish_item( jb_tx );
      end
   endtask: body

   `uvm_object_utils_begin( same_flavored_jelly_beans_sequence )
   `uvm_field_int ( num_jelly_beans,                          UVM_ALL_ON )
   `uvm_field_enum( jelly_bean_transaction::flavor_e, flavor, UVM_ALL_ON )
   `uvm_object_utils_end
endclass: same_flavored_jelly_beans_sequence

//---------------------------------------------------------------------------
// Class: jelly_bean_recipe_virtual_sequence
//---------------------------------------------------------------------------

class jelly_bean_recipe_virtual_sequence extends uvm_sequence#( uvm_sequence_item );
   typedef enum bit[1:0] { LEMON_MERINGUE_PIE,   // 2 LEMON      + 2 COCONUT
      STRAWBERRY_SHORTCAKE, // 2 STRAWBERRY + 2 VANILLA
      CANDY_APPLE           // 2 APPLE      + 1 CINNAMON
   } recipe_e;
   rand recipe_e recipe;

   jelly_bean_sequencer jb_seqr1;
   jelly_bean_sequencer jb_seqr2;

   same_flavored_jelly_beans_sequence jb_seq1;
   same_flavored_jelly_beans_sequence jb_seq2;

   function new( string name = "" );
      super.new( name );
   endfunction: new

   task body();
      jb_seq1 = same_flavored_jelly_beans_sequence::type_id::create( .name( "jb_seq1" ) );
      jb_seq2 = same_flavored_jelly_beans_sequence::type_id::create( .name( "jb_seq2" ) );
      case ( recipe )
         LEMON_MERINGUE_PIE: begin
            jb_seq1.flavor          = jelly_bean_transaction::LEMON;
            jb_seq2.flavor          = jelly_bean_transaction::COCONUT;
            jb_seq1.num_jelly_beans = 2;
            jb_seq2.num_jelly_beans = 2;
         end
         STRAWBERRY_SHORTCAKE: begin
            jb_seq1.flavor          = jelly_bean_transaction::STRAWBERRY;
            jb_seq2.flavor          = jelly_bean_transaction::VANILLA;
            jb_seq1.num_jelly_beans = 2;
            jb_seq2.num_jelly_beans = 2;
         end
         CANDY_APPLE: begin
            jb_seq1.flavor          = jelly_bean_transaction::APPLE;
            jb_seq2.flavor          = jelly_bean_transaction::CINNAMON;
            jb_seq1.num_jelly_beans = 2;
            jb_seq2.num_jelly_beans = 1;
         end
      endcase // case ( recipe )
      `uvm_info( get_name(), { "\n", this.sprint() }, UVM_LOW )
      fork
         jb_seq1.start( .sequencer( jb_seqr1 ), .parent_sequence( this ) );
         jb_seq2.start( .sequencer( jb_seqr2 ), .parent_sequence( this ) );
      join
   endtask: body

   `uvm_object_utils_begin( jelly_bean_recipe_virtual_sequence )
   `uvm_field_enum  ( recipe_e, recipe, UVM_ALL_ON )
   `uvm_field_object( jb_seq1,          UVM_ALL_ON )
   `uvm_field_object( jb_seq2,          UVM_ALL_ON )
   `uvm_object_utils_end
endclass: jelly_bean_recipe_virtual_sequence

//==============================================================================
// Copyright (c) 2011-2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
