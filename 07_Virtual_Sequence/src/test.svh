   //---------------------------------------------------------------------------
   // Class: jelly_bean_base_test
   //---------------------------------------------------------------------------

class jelly_bean_base_test extends uvm_test;
   `uvm_component_utils( jelly_bean_base_test )

   jelly_bean_env          jb_env;
   jelly_bean_env_config   jb_env_cfg;
   jelly_bean_agent_config jb_agent_cfg1;
   jelly_bean_agent_config jb_agent_cfg2;

   function new( string name, uvm_component parent );
      super.new( name, parent );
   endfunction: new

   function void build_phase( uvm_phase phase );
      super.build_phase( phase );

      jb_env_cfg    = jelly_bean_env_config  ::type_id::create( "jb_env_cfg"    );
      jb_agent_cfg1 = jelly_bean_agent_config::type_id::create( "jb_agent_cfg1" );
      jb_agent_cfg2 = jelly_bean_agent_config::type_id::create( "jb_agent_cfg2" );
      
      if ( ! uvm_config_db#( virtual jelly_bean_if )::get
	   ( .cntxt( this ), .inst_name( "" ), .field_name( "jb_if1" ), .value( jb_agent_cfg1.jb_if ) ) ) begin
	 `uvm_error( "jelly_bean_test", "jb_if1 not found" )
      end

      if ( ! uvm_config_db#( virtual jelly_bean_if )::get
	   ( .cntxt( this ), .inst_name( "" ), .field_name( "jb_if2" ), .value( jb_agent_cfg2.jb_if ) ) ) begin
	 `uvm_error( "jelly_bean_test", "jb_if2 not found" )
      end

      jb_env_cfg.jb_agent_cfg1 = jb_agent_cfg1;
      jb_env_cfg.jb_agent_cfg2 = jb_agent_cfg2;

      uvm_config_db#( jelly_bean_env_config )::set
	( .cntxt( this ), .inst_name( "*" ), .field_name( "jb_env_cfg" ), .value( jb_env_cfg ) );

      jb_env = jelly_bean_env::type_id::create( .name( "jb_env" ), .parent( this ) );
   endfunction: build_phase
endclass: jelly_bean_base_test

   //---------------------------------------------------------------------------
   // Class: jelly_bean_recipe_test
   //---------------------------------------------------------------------------

class jelly_bean_recipe_test extends jelly_bean_base_test;
   `uvm_component_utils( jelly_bean_recipe_test )

   function new( string name, uvm_component parent );
      super.new( name, parent );
   endfunction: new

   task main_phase( uvm_phase phase );
      jelly_bean_recipe_virtual_sequence jb_vseq;

      phase.raise_objection( .obj( this ) );
      jb_vseq = jelly_bean_recipe_virtual_sequence::type_id::create( .name( "jb_vseq" ) );
      jb_vseq.jb_seqr1 = jb_env.jb_agent1.jb_seqr;
      jb_vseq.jb_seqr2 = jb_env.jb_agent2.jb_seqr;
`ifndef CL_USE_MODELSIM
      assert( jb_vseq.randomize() );
`endif
      jb_vseq.start( .sequencer( null ) );
      #100ns ;
      phase.drop_objection( .obj( this ) );
   endtask: main_phase
endclass: jelly_bean_recipe_test


//==============================================================================
// Copyright (c) 2011-2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================