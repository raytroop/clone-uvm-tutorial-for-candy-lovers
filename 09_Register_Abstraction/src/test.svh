//------------------------------------------------------------------------------
// Class: jelly_bean_base_test
//------------------------------------------------------------------------------

class jelly_bean_base_test extends uvm_test;
   `uvm_component_utils( jelly_bean_base_test )

   jelly_bean_env          jb_env;
   jelly_bean_env_config   jb_env_cfg;
   jelly_bean_agent_config jb_agent_cfg;
   jelly_bean_reg_block    jb_reg_block;

   function new( string name, uvm_component parent );
      super.new( name, parent );
   endfunction: new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      jb_reg_block = jelly_bean_reg_block::type_id::create( "jb_reg_block" );
      jb_reg_block.build();

      jb_env_cfg = jelly_bean_env_config::type_id::create( "jb_env_cfg" );
      jb_env_cfg.jb_reg_block = jb_reg_block;

      jb_agent_cfg = jelly_bean_agent_config::type_id::create( "jb_agent_cfg" );
      
      if ( ! uvm_config_db#( virtual jelly_bean_if )::get( .cntxt( this ),
                                                           .inst_name( "" ),
                                                           .field_name( "jb_if" ),
                                                           .value( jb_agent_cfg.jb_if ))) begin
         `uvm_error( "jelly_bean_test", "jb_if not found" )
      end

      jb_env_cfg.jb_agent_cfg = jb_agent_cfg;

      uvm_config_db#(jelly_bean_env_config)::set( .cntxt( null ),
                                                  .inst_name( "*" ),
                                                  .field_name( "jb_env_cfg" ),
                                                  .value( jb_env_cfg ) );
      jb_env = jelly_bean_env::type_id::create( .name( "jb_env" ), 
                                                .parent( this ) );
   endfunction: build_phase

   virtual function void start_of_simulation_phase( uvm_phase phase );
      super.start_of_simulation_phase( phase );
      uvm_top.print_topology();
   endfunction: start_of_simulation_phase

endclass: jelly_bean_base_test

//------------------------------------------------------------------------------
// Class: jelly_bean_reg_test
//------------------------------------------------------------------------------

class jelly_bean_reg_test extends jelly_bean_base_test;
   `uvm_component_utils( jelly_bean_reg_test )

   function new( string name, uvm_component parent );
      super.new( name, parent );
   endfunction: new

   task main_phase( uvm_phase phase );
      jelly_bean_reg_sequence jb_reg_seq;

      phase.raise_objection( .obj( this ) );
      jb_reg_seq = jelly_bean_reg_sequence::type_id::create( .name( "jb_reg_seq" ) );
      jb_reg_seq.model = jb_reg_block;
      jb_reg_seq.start( .sequencer( jb_env.jb_agent.jb_seqr ) );
      
      #100ns;
      phase.drop_objection( .obj( this ) );
      
   endtask: main_phase
endclass: jelly_bean_reg_test

class jelly_bean_reg_simple_test extends jelly_bean_base_test;
   `uvm_component_utils( jelly_bean_reg_simple_test )

   function new( string name, uvm_component parent );
      super.new( name, parent );
   endfunction: new

   task main_phase( uvm_phase phase );
      jelly_bean_reg_simple_sequence jb_reg_seq;

      phase.raise_objection( .obj( this ) );
      jb_reg_seq = jelly_bean_reg_simple_sequence::type_id::create( .name( "jb_reg_seq" ) );
      jb_reg_seq.start( .sequencer( jb_env.jb_agent.jb_seqr ) );
      
      #100ns;
      phase.drop_objection( .obj( this ) );
      
   endtask: main_phase
endclass: jelly_bean_reg_simple_test

//------------------------------------------------------------------------------
// Class: jelly_bean_reg_hw_reset_test
//------------------------------------------------------------------------------

class jelly_bean_reg_hw_reset_test extends jelly_bean_base_test;
   `uvm_component_utils( jelly_bean_reg_hw_reset_test )

   function new( string name, uvm_component parent );
      super.new( name, parent );
   endfunction: new

   task main_phase( uvm_phase phase );
      uvm_reg_hw_reset_seq reg_hw_reset_seq;

      phase.raise_objection( .obj( this ) );
      reg_hw_reset_seq = uvm_reg_hw_reset_seq::type_id::create( .name( "reg_hw_reset_seq" ) );
      reg_hw_reset_seq.model = jb_reg_block;
      reg_hw_reset_seq.start( .sequencer( jb_env.jb_agent.jb_seqr ) );
      
      phase.drop_objection( .obj( this ) );
   endtask: main_phase
endclass: jelly_bean_reg_hw_reset_test

//==============================================================================
// Copyright (c) 2011-2015 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
