## [UVM Tutorial for Candy Lovers – 24. Register Access through the Back Door](http://cluelogic.com/2014/09/uvm-tutorial-for-candy-lovers-register-access-through-the-back-door/)
*This post will add back-door access to the registers defined in Register Abstraction. With a few additional lines of code, you can access the registers through the back door.*

```verilog
class jelly_bean_reg_sequence extends uvm_reg_sequence;
  `uvm_object_utils( jelly_bean_reg_sequence )

  //----------------------------------------------------------------------------
  // Function: new
  //----------------------------------------------------------------------------

  function new( string name = "" );
    super.new( name );
  endfunction: new

  //----------------------------------------------------------------------------
  // Task: body
  //----------------------------------------------------------------------------

  virtual task body();
    jelly_bean_reg_block jb_reg_block;
    flavor_e             flavor;
    color_e              color;
    bit                  sugar_free;
    bit                  sour;
    uvm_status_e         status;
    uvm_reg_data_t       value;

    $cast( jb_reg_block, model );
    flavor     = APPLE;

     if ( m_sequencer.get_report_verbosity_level() >= UVM_DEBUG ) begin // for debug
         string paths[$];
         uvm_hdl_path_concat pathc[$];

         $display( "--------------------" );
         paths.delete();
         jb_reg_block.get_hdl_path( paths );
         foreach ( paths[i] )
           $display( "jb_reg_block.get_hdl_path[%0d] is '%s'", i, paths[i] );
         paths.delete();
         jb_reg_block.get_full_hdl_path( paths );
         foreach ( paths[i] )
           $display( "jb_reg_block.get_full_hdl_path[%0d] is '%s'", i, paths[i] );

            $display( "--------------------" );
            pathc.delete();
            jb_reg_block.jb_recipe_reg.get_hdl_path( pathc );
            foreach ( pathc[i] )
              foreach ( pathc[i].slices[j] )
                $display( "jb_reg_block.jb_recipe_reg.get_hdl_path[%0d].slices[%0d].path is '%s'",
                          i, j, pathc[i].slices[j].path );

            pathc.delete();
            jb_reg_block.jb_recipe_reg.get_full_hdl_path( pathc );
            foreach ( pathc[i] )
              foreach ( pathc[i].slices[j] )
                $display( "jb_reg_block.jb_recipe_reg.get_hdl_full_path[%0d].slices[%0d].path is '%s'",
                          i, j, pathc[i].slices[j].path );
      end

    color      = GREEN;
    sugar_free = 0;
    sour       = 1;

    // front-door write
    `uvm_info(get_type_name(), "################ <0> write_reg front-door ###############", UVM_DEBUG)
    write_reg( jb_reg_block.jb_recipe_reg, status, { sour, sugar_free, color, flavor } );

    // front-door read
    `uvm_info(get_type_name(), "################ <1> read_reg front-door ################", UVM_DEBUG)
    read_reg( jb_reg_block.jb_taste_reg, status, value );
    #20ns ;

    // back-door writes
    flavor = BLUEBERRY;
    `uvm_info(get_type_name(), "################ <2> poke_reg back-door ################", UVM_DEBUG)
    poke_reg( jb_reg_block.jb_recipe_reg, status, { sour, sugar_free, color, flavor } );
    #10ns ;

    flavor = BUBBLE_GUM;
    `uvm_info(get_type_name(), "################ <3> write_reg back-door ################", UVM_DEBUG)
    write_reg( jb_reg_block.jb_recipe_reg, status, { sour, sugar_free, color, flavor },
               UVM_BACKDOOR );
    #10ns ;

    flavor = CHOCOLATE;
    `uvm_info(get_type_name(), "################ <4> reg.write back-door ################", UVM_DEBUG)
    jb_reg_block.jb_recipe_reg.write( status, { sour, sugar_free, color, flavor },
                                      UVM_BACKDOOR, .parent( this ) );
    #10ns ;

    // back-door reads
    `uvm_info(get_type_name(), "################ <5> peek_reg back-door ################", UVM_DEBUG)
    peek_reg( jb_reg_block.jb_taste_reg, status, value );
    assert( value == YUMMY );

    `uvm_info(get_type_name(), "################ <6> read_reg back-door ################", UVM_DEBUG)
    read_reg( jb_reg_block.jb_taste_reg, status, value, UVM_BACKDOOR );
    assert( value == YUMMY );

    `uvm_info(get_type_name(), "################ <7> reg.read back-door ################", UVM_DEBUG)
    jb_reg_block.jb_taste_reg.read( status, value, UVM_BACKDOOR, .parent( this ) );
    assert( value == YUMMY );
    #10ns ;
  endtask: body

endclass: jelly_bean_reg_sequence
```
- Log
  - ADDR RECIPE: 0x00
  - ADDR TASETE: 0x01\
![DUT Registers](http://cluelogic.com/wp-content/uploads/2012/11/Registers.png)
```
# --------------------                                                                                                                                                                                                                                                     [32/1938]
# jb_reg_block.get_hdl_path[0] is 'top.dut'
# jb_reg_block.get_full_hdl_path[0] is 'top.dut'
# --------------------
# jb_reg_block.jb_recipe_reg.get_hdl_path[0].slices[0].path is 'flavor'
# jb_reg_block.jb_recipe_reg.get_hdl_path[0].slices[1].path is 'color'
# jb_reg_block.jb_recipe_reg.get_hdl_path[0].slices[2].path is 'sugar_free'
# jb_reg_block.jb_recipe_reg.get_hdl_path[0].slices[3].path is 'sour'
# jb_reg_block.jb_recipe_reg.get_hdl_full_path[0].slices[0].path is 'top.dut.flavor'
# jb_reg_block.jb_recipe_reg.get_hdl_full_path[0].slices[1].path is 'top.dut.color'
# jb_reg_block.jb_recipe_reg.get_hdl_full_path[0].slices[2].path is 'top.dut.sugar_free'
# jb_reg_block.jb_recipe_reg.get_hdl_full_path[0].slices[3].path is 'top.dut.sour'
# UVM_INFO sequences.svh(253) @ 0: uvm_test_top.jb_env.jb_agent.jb_seqr@@jb_reg_seq [jelly_bean_reg_sequence] ################ <0> write_reg front-door ###############
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg_map.svh(1897) @ 0: reporter [uvm_reg_map] Writing 'h51 at 'h0 via map "jb_reg_block.reg_map"...
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg_map.svh(1960) @ 10: reporter [uvm_reg_map] Wrote 'h51 at 'h0 via map "jb_reg_block.reg_map": UVM_IS_OK...
# UVM_INFO @ 10: reporter [RegModel] Wrote register via map jb_reg_block.reg_map: jb_reg_block.jb_recipe_reg=0x51
# UVM_INFO sequences.svh(257) @ 10: uvm_test_top.jb_env.jb_agent.jb_seqr@@jb_reg_seq [jelly_bean_reg_sequence] ################ <1> read_reg front-door ################
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg_map.svh(2035) @ 10: reporter [uvm_reg_map] Reading address 'h1 via map "jb_reg_block.reg_map"...
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg_predictor.svh(218) @ 20: uvm_test_top.jb_env.jb_reg_predictor [REG_PREDICT] Observed WRITE transaction to register jb_reg_block.jb_recipe_reg: value='h51 : updated value = 'h51
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg_map.svh(2102) @ 30: reporter [uvm_reg_map] Read 'h0 at 'h1 via map "jb_reg_block.reg_map": UVM_IS_OK...
# UVM_INFO @ 30: reporter [RegModel] Read  register via map jb_reg_block.reg_map: jb_reg_block.jb_taste_reg=0
# UVM_INFO sequences.svh(263) @ 50: uvm_test_top.jb_env.jb_agent.jb_seqr@@jb_reg_seq [jelly_bean_reg_sequence] ################ <2> poke_reg back-door ################
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2684) @ 50: reporter [RegMem] backdoor_write to top.dut.flavor
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2684) @ 50: reporter [RegMem] backdoor_write to top.dut.color
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2684) @ 50: reporter [RegMem] backdoor_write to top.dut.sugar_free
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2684) @ 50: reporter [RegMem] backdoor_write to top.dut.sour
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2810) @ 50: reporter [RegModel] Poked register "jb_reg_block.jb_recipe_reg": 'h0000000000000052
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg_predictor.svh(223) @ 50: uvm_test_top.jb_env.jb_reg_predictor [REG_PREDICT] Observed READ transaction to register jb_reg_block.jb_recipe_reg: value='h1
# UVM_INFO sequences.svh(268) @ 60: uvm_test_top.jb_env.jb_agent.jb_seqr@@jb_reg_seq [jelly_bean_reg_sequence] ################ <3> write_reg back-door ################
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2721) @ 60: reporter [RegMem] backdoor_read from %s top.dut.flavor
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2721) @ 60: reporter [RegMem] backdoor_read from %s top.dut.color
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2721) @ 60: reporter [RegMem] backdoor_read from %s top.dut.sugar_free
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2721) @ 60: reporter [RegMem] backdoor_read from %s top.dut.sour
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2753) @ 60: reporter [RegMem] returned backdoor value 0x52
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2684) @ 60: reporter [RegMem] backdoor_write to top.dut.flavor
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2684) @ 60: reporter [RegMem] backdoor_write to top.dut.color
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2684) @ 60: reporter [RegMem] backdoor_write to top.dut.sugar_free
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2684) @ 60: reporter [RegMem] backdoor_write to top.dut.sour
# UVM_INFO @ 60: reporter [RegModel] Wrote register via DPI backdoor: jb_reg_block.jb_recipe_reg=0x53
# UVM_INFO sequences.svh(274) @ 70: uvm_test_top.jb_env.jb_agent.jb_seqr@@jb_reg_seq [jelly_bean_reg_sequence] ################ <4> reg.write back-door ################
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2721) @ 70: reporter [RegMem] backdoor_read from %s top.dut.flavor
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2721) @ 70: reporter [RegMem] backdoor_read from %s top.dut.color
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2721) @ 70: reporter [RegMem] backdoor_read from %s top.dut.sugar_free
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2721) @ 70: reporter [RegMem] backdoor_read from %s top.dut.sour
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2753) @ 70: reporter [RegMem] returned backdoor value 0x53
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2684) @ 70: reporter [RegMem] backdoor_write to top.dut.flavor
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2684) @ 70: reporter [RegMem] backdoor_write to top.dut.color
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2684) @ 70: reporter [RegMem] backdoor_write to top.dut.sugar_free
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2684) @ 70: reporter [RegMem] backdoor_write to top.dut.sour
# UVM_INFO @ 70: reporter [RegModel] Wrote register via DPI backdoor: jb_reg_block.jb_recipe_reg=0x54
# UVM_INFO sequences.svh(280) @ 80: uvm_test_top.jb_env.jb_agent.jb_seqr@@jb_reg_seq [jelly_bean_reg_sequence] ################ <5> peek_reg back-door ################
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2721) @ 80: reporter [RegMem] backdoor_read from %s top.dut.taste
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2753) @ 80: reporter [RegMem] returned backdoor value 0x1
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2867) @ 80: reporter [RegModel] Peeked register "jb_reg_block.jb_taste_reg": 'h0000000000000001
# UVM_INFO sequences.svh(284) @ 80: uvm_test_top.jb_env.jb_agent.jb_seqr@@jb_reg_seq [jelly_bean_reg_sequence] ################ <6> read_reg back-door ################
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2721) @ 80: reporter [RegMem] backdoor_read from %s top.dut.taste
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2753) @ 80: reporter [RegMem] returned backdoor value 0x1
# UVM_INFO @ 80: reporter [RegModel] Read  register via DPI backdoor: jb_reg_block.jb_taste_reg=1
# UVM_INFO sequences.svh(288) @ 80: uvm_test_top.jb_env.jb_agent.jb_seqr@@jb_reg_seq [jelly_bean_reg_sequence] ################ <7> reg.read back-door ################
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2721) @ 80: reporter [RegMem] backdoor_read from %s top.dut.taste
# UVM_INFO verilog_src/uvm-1.2/src/reg/uvm_reg.svh(2753) @ 80: reporter [RegMem] returned backdoor value 0x1
# UVM_INFO @ 80: reporter [RegModel] Read  register via DPI backdoor: jb_reg_block.jb_taste_reg=1

```

- Annotated Waveform\
![Annotated Waveform](http://cluelogic.com/wp-content/uploads/2014/09/annotated_backdoor.png)


### Compilation and Run options to access backdoor
- Questasim: **+acc** and **+UVM_VERBOSITY=UVM_DEBUG** are must
```bash
vlog design.sv testbench.sv -L ${QUESTA_HOME}/uvm-1.2 -timescale=1ns/1ns +acc
vsim -c work.top -do "run -all; exit" -L ${QUESTA_HOME}/uvm-1.2 +UVM_TESTNAME=jelly_bean_reg_test +UVM_VERBOSITY=UVM_DEBUG
```
- VCS: **-debug_all** and **+UVM_VERBOSITY=UVM_DEBUG** are must
```bash
vcs -licqueue '-timescale=1ns/1ns' '+vcs+flush+all' '+warn=all' '-sverilog' '-debug_all' +incdir+$UVM_HOME/src $UVM_HOME/src/uvm.sv $UVM_HOME/src/dpi/uvm_dpi.cc -CFLAGS -DVCS design.sv testbench.sv
./simv +vcs+lic+wait '+UVM_TESTNAME=jelly_bean_reg_test' '+UVM_VERBOSITY=UVM_DEBUG'
```
