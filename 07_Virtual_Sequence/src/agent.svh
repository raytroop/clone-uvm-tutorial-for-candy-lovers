   //---------------------------------------------------------------------------
   // Class: jelly_bean_agent_config
   //---------------------------------------------------------------------------

class jelly_bean_agent_config extends uvm_object;
   `uvm_object_utils( jelly_bean_agent_config )

   uvm_active_passive_enum active = UVM_ACTIVE;
   bit has_jb_fc_sub = 1; // switch to instantiate a functional coverage subscriber

   virtual jelly_bean_if jb_if;

   function new( string name = "" );
      super.new( name );
   endfunction: new
endclass: jelly_bean_agent_config

   //---------------------------------------------------------------------------
   // Class: jelly_bean_driver
   //---------------------------------------------------------------------------

class jelly_bean_driver extends uvm_driver#( jelly_bean_transaction );
   `uvm_component_utils( jelly_bean_driver )

   virtual jelly_bean_if jb_if;

   function new( string name, uvm_component parent );
      super.new( name, parent );
   endfunction: new

   function void build_phase( uvm_phase phase );
      super.build_phase( phase );
   endfunction: build_phase

   task main_phase( uvm_phase phase );
      jelly_bean_transaction jb_tx;

      forever begin
	 @jb_if.master_cb;
	 jb_if.master_cb.flavor <= jelly_bean_transaction::NO_FLAVOR;
	 seq_item_port.get_next_item( jb_tx );
	 @jb_if.master_cb;
	 jb_if.master_cb.flavor     <= jb_tx.flavor;
	 jb_if.master_cb.color      <= jb_tx.color;
	 jb_if.master_cb.sugar_free <= jb_tx.sugar_free;
	 jb_if.master_cb.sour       <= jb_tx.sour;
	 seq_item_port.item_done();
      end
   endtask: main_phase
   
endclass: jelly_bean_driver

   //---------------------------------------------------------------------------
   // Class: jelly_bean_monitor
   //---------------------------------------------------------------------------

class jelly_bean_monitor extends uvm_monitor;
   `uvm_component_utils( jelly_bean_monitor )

   uvm_analysis_port#( jelly_bean_transaction ) jb_ap;

   virtual jelly_bean_if jb_if;

   function new( string name, uvm_component parent );
      super.new( name, parent );
   endfunction: new

   function void build_phase( uvm_phase phase );
      super.build_phase( phase );
      jb_ap = new( .name( "jb_ap" ), .parent( this ) );
   endfunction: build_phase

   task main_phase( uvm_phase phase );
      forever begin
	 jelly_bean_transaction jb_tx;
	 @jb_if.slave_cb;
	 if ( jb_if.slave_cb.flavor != jelly_bean_transaction::NO_FLAVOR ) begin
	    jb_tx = jelly_bean_transaction::type_id::create( .name( "jb_tx" ) );
	    jb_tx.flavor     = jelly_bean_transaction::flavor_e'( jb_if.slave_cb.flavor );
	    jb_tx.color      = jelly_bean_transaction::color_e' ( jb_if.slave_cb.color  );
	    jb_tx.sugar_free = jb_if.slave_cb.sugar_free;
	    jb_tx.sour       = jb_if.slave_cb.sour;
	    @jb_if.master_cb;
	    jb_tx.taste = jelly_bean_transaction::taste_e'( jb_if.master_cb.taste );
	    jb_ap.write( jb_tx );
	 end
      end
   endtask: main_phase
endclass: jelly_bean_monitor

   //---------------------------------------------------------------------------
   // Class: jelly_bean_fc_subscriber
   //---------------------------------------------------------------------------

class jelly_bean_fc_subscriber extends uvm_subscriber#( jelly_bean_transaction );
   `uvm_component_utils( jelly_bean_fc_subscriber )

   jelly_bean_transaction jb_tx;

`ifndef CL_USE_MODELSIM
   covergroup jelly_bean_cg;
      flavor_cp:     coverpoint jb_tx.flavor;
      color_cp:      coverpoint jb_tx.color;
      sugar_free_cp: coverpoint jb_tx.sugar_free;
      sour_cp:       coverpoint jb_tx.sour;
      cross flavor_cp, color_cp, sugar_free_cp, sour_cp;
   endgroup: jelly_bean_cg
`endif

   function new( string name, uvm_component parent );
      super.new( name, parent );
`ifndef CL_USE_MODELSIM
      jelly_bean_cg = new;
`endif
   endfunction: new

   function void write( jelly_bean_transaction t );
      jb_tx = t;
`ifndef CL_USE_MODELSIM
      jelly_bean_cg.sample();
`endif
   endfunction: write
endclass: jelly_bean_fc_subscriber

   //---------------------------------------------------------------------------
   // Class: jelly_bean_agent
   //---------------------------------------------------------------------------

class jelly_bean_agent extends uvm_agent;
   `uvm_component_utils( jelly_bean_agent )

   jelly_bean_agent_config  jb_agent_cfg;
   jelly_bean_sequencer     jb_seqr;
   jelly_bean_driver        jb_drvr;
   jelly_bean_monitor       jb_mon;
   jelly_bean_fc_subscriber jb_fc_sub;

   uvm_analysis_port#( jelly_bean_transaction ) jb_ap;

   function new( string name, uvm_component parent );
      super.new( name, parent );
   endfunction: new

   function void build_phase( uvm_phase phase );
      super.build_phase( phase );

      if ( ! uvm_config_db#( jelly_bean_agent_config )::get( .cntxt     ( this ), 
							     .inst_name ( "" ), 
							     .field_name( "jb_agent_cfg" ),
							     .value     (  jb_agent_cfg ) ) ) begin
	 `uvm_error( "jelly_bean_agent", "jb_agent_cfg not found" )
      end

      if ( jb_agent_cfg.active == UVM_ACTIVE ) begin
	 jb_seqr = jelly_bean_sequencer::type_id::create( .name( "jb_seqr" ), .parent( this ) );
	 jb_drvr = jelly_bean_driver   ::type_id::create( .name( "jb_drvr" ), .parent( this ) );
      end

      if ( jb_agent_cfg.has_jb_fc_sub ) begin
	jb_fc_sub = jelly_bean_fc_subscriber::type_id::create( .name( "jb_fc_sub" ), .parent( this ) );
      end

      jb_mon = jelly_bean_monitor::type_id::create( .name( "jb_mon" ), .parent( this ) );
   endfunction: build_phase

   function void connect_phase( uvm_phase phase );
      super.connect_phase( phase );

      jb_mon.jb_if = jb_agent_cfg.jb_if;
      jb_ap = jb_mon.jb_ap;
      
      if ( jb_agent_cfg.active == UVM_ACTIVE ) begin
	 jb_drvr.seq_item_port.connect( jb_seqr.seq_item_export );
	 jb_drvr.jb_if = jb_agent_cfg.jb_if;
      end

      if ( jb_agent_cfg.has_jb_fc_sub ) begin
	 jb_ap.connect( jb_fc_sub.analysis_export );
      end
   endfunction: connect_phase
endclass: jelly_bean_agent

//==============================================================================
// Copyright (c) 2011-2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================