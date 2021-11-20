   //---------------------------------------------------------------------------
   // Class: jelly_bean_env_config
   //---------------------------------------------------------------------------

class jelly_bean_env_config extends uvm_object;
   `uvm_object_utils( jelly_bean_env_config )

   bit has_jb_agent1 = 1; // switch to instantiate an agent #1
   bit has_jb_agent2 = 1; // switch to instantiate an agent #2
   bit has_jb_sb1    = 1; // switch to instantiate a scoreboard #1
   bit has_jb_sb2    = 1; // switch to instantiate a scoreboard #2
   
   jelly_bean_agent_config jb_agent_cfg1;
   jelly_bean_agent_config jb_agent_cfg2;

   function new( string name = "" );
      super.new( name );
   endfunction: new
endclass: jelly_bean_env_config

   //---------------------------------------------------------------------------
   // Typedef: jelly_bean_scoreboard
   //---------------------------------------------------------------------------

typedef class jelly_bean_scoreboard;
   
   //---------------------------------------------------------------------------
   // Class: jelly_bean_sb_subscriber
   //---------------------------------------------------------------------------

class jelly_bean_sb_subscriber extends uvm_subscriber#( jelly_bean_transaction );
   `uvm_component_utils( jelly_bean_sb_subscriber )

   function new( string name, uvm_component parent );
      super.new( name, parent );
   endfunction: new

   function void write( jelly_bean_transaction t );
      jelly_bean_scoreboard jb_sb;
      
      $cast( jb_sb, m_parent );
      jb_sb.check_jelly_bean_taste( t );
   endfunction: write
   
endclass: jelly_bean_sb_subscriber

   //---------------------------------------------------------------------------
   // Class: jelly_bean_scoreboard
   //---------------------------------------------------------------------------

class jelly_bean_scoreboard extends uvm_scoreboard;
   `uvm_component_utils( jelly_bean_scoreboard )

   uvm_analysis_export#( jelly_bean_transaction ) jb_analysis_export;
   local jelly_bean_sb_subscriber jb_sb_sub;
   local int unsigned num_failed = 0;
   
   function new( string name, uvm_component parent );
      super.new( name, parent );
   endfunction: new

   function void build_phase( uvm_phase phase );
      super.build_phase( phase );
      jb_analysis_export = new( .name( "jb_analysis_export" ), .parent( this ) );
      jb_sb_sub = jelly_bean_sb_subscriber::type_id::create( .name( "jb_sb_sub" ), .parent( this ) );
   endfunction: build_phase

   function void connect_phase( uvm_phase phase );
      super.connect_phase( phase );
      jb_analysis_export.connect( jb_sb_sub.analysis_export );
   endfunction: connect_phase

   function void report_phase( uvm_phase phase );
      super.report_phase( phase );
      if ( num_failed > 0 ) $display( "=== TEST FAILED (%s num_failed=%0d) ===", get_name(), num_failed );
      else                  $display( "=== TEST PASSED (%s) ===", get_name() );
   endfunction: report_phase

   virtual function void check_jelly_bean_taste( jelly_bean_transaction jb_tx );
      uvm_table_printer p = new;
      if ( jb_tx.flavor == jelly_bean_transaction::CHOCOLATE && jb_tx.sour &&
	   jb_tx.taste  == jelly_bean_transaction::YUMMY ) begin
	 `uvm_error( "jelly_bean_scoreboard", { "You lost sense of taste!\n", jb_tx.sprint(p) } )
	 num_failed++;
      end else begin
	 `uvm_info( get_name(), { "You have a good sense of taste.\n", jb_tx.sprint(p) }, UVM_LOW )
      end
   endfunction: check_jelly_bean_taste

endclass: jelly_bean_scoreboard

   //---------------------------------------------------------------------------
   // Class: jelly_bean_env
   //---------------------------------------------------------------------------

class jelly_bean_env extends uvm_env;
   `uvm_component_utils( jelly_bean_env )

   jelly_bean_env_config jb_env_cfg;
   jelly_bean_agent      jb_agent1;
   jelly_bean_agent      jb_agent2;
   jelly_bean_scoreboard jb_sb1;
   jelly_bean_scoreboard jb_sb2;

   function new( string name, uvm_component parent );
      super.new( name, parent );
   endfunction: new

   function void build_phase( uvm_phase phase );
      super.build_phase( phase );

      if ( ! uvm_config_db#( jelly_bean_env_config )::get
	   ( .cntxt( this ), .inst_name( "" ), .field_name( "jb_env_cfg" ), .value( jb_env_cfg ) ) ) begin
	 `uvm_error( "jelly_bean_env", "jb_env_cfg not found" )
      end

      if ( jb_env_cfg.has_jb_agent1 ) begin
	 uvm_config_db#( jelly_bean_agent_config )::set( .cntxt( this ), .inst_name( "jb_agent1*" ), 
	    .field_name( "jb_agent_cfg" ), .value( jb_env_cfg.jb_agent_cfg1 ) );
	 jb_agent1 = jelly_bean_agent::type_id::create( .name( "jb_agent1" ), .parent( this ) );

	 if ( jb_env_cfg.has_jb_sb1 ) begin
	    jb_sb1 = jelly_bean_scoreboard::type_id::create( .name( "jb_sb1" ), .parent( this ) );
	 end
      end

      if ( jb_env_cfg.has_jb_agent2 ) begin
	 uvm_config_db#( jelly_bean_agent_config )::set( .cntxt( this ), .inst_name( "jb_agent2*" ),
	    .field_name( "jb_agent_cfg" ), .value( jb_env_cfg.jb_agent_cfg2 ) );
	 jb_agent2 = jelly_bean_agent::type_id::create( .name( "jb_agent2" ), .parent( this ) );

	 if ( jb_env_cfg.has_jb_sb2 ) begin
	    jb_sb2 = jelly_bean_scoreboard::type_id::create( .name( "jb_sb2" ), .parent( this ) );
	 end
      end

    endfunction: build_phase

   function void connect_phase( uvm_phase phase );
      super.connect_phase( phase );

      if ( jb_env_cfg.has_jb_agent1 && jb_env_cfg.has_jb_sb1 )
	jb_agent1.jb_ap.connect( jb_sb1.jb_analysis_export );
      if ( jb_env_cfg.has_jb_agent2 && jb_env_cfg.has_jb_sb2 )
	jb_agent2.jb_ap.connect( jb_sb2.jb_analysis_export );
   endfunction: connect_phase
endclass: jelly_bean_env

//==============================================================================
// Copyright (c) 2011-2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================