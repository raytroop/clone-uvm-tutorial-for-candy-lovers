## [UVM Tutorial for Candy Lovers – 26. Sequence Arbitration](http://cluelogic.com/2015/04/uvm-tutorial-for-candy-lovers-sequence-arbitration/)

- UVM_SEQ_ARB_FIFO\
*This is the default arbitration mode and probably the easiest to understand. UVM sequencer grants sequences in FIFO order **regardless of their priorities.***
![UVM_SEQ_ARB_FIFO](http://cluelogic.com/wp-content/uploads/2015/04/uvm_seq_arb_fifo.png)

- UVM_SEQ_ARB_RANDOM\
*This mode should be also easy to understand. It **randomly** grants sequences in the FIFO **regardless of their priorities.***
![UVM_SEQ_ARB_RANDOM](http://cluelogic.com/wp-content/uploads/2015/04/uvm_seq_arb_random.png)

- UVM_SEQ_ARB_STRICT_FIFO\
*This mode always grants the highest priority sequence. If more than one sequence has the same priority, the sequencer grants the one closest to the front of the FIFO.*
![UVM_SEQ_ARB_STRICT_FIFO](http://cluelogic.com/wp-content/uploads/2015/04/uvm_seq_arb_strict_fifo.png)

- UVM_SEQ_ARB_STRICT_RANDOM\
*Similar to the UVM_SEQ_ARB_STRICT_FIFO mode, this mode grants the highest priority sequence. The difference is that when more than one sequence has the same priority, the sequencer selects a sequence randomly from the sequences that have the same priority.*
![UVM_SEQ_ARB_STRICT_RANDOM](http://cluelogic.com/wp-content/uploads/2015/04/uvm_seq_arb_strict_random.png)

- UVM_SEQ_ARB_WEIGHTED\
*This is the most complicated and misleading mode in my opinion. The idea of this mode is that the higher priority sequences will get more chance to be granted. Here is how it works under the hood: This mode totals up the priority numbers in the request FIFO. Let’s say, the sum is 800. Then, it picks a random number between 0 and 799 (800 minus 1). Then, from the front of the FIFO, it accumulates the priority number each sequence has. When the accumulated number becomes more than the randomly selected number (threshold), that sequence is selected.*
![UVM_SEQ_ARB_WEIGHTED](http://cluelogic.com/wp-content/uploads/2015/04/uvm_seq_arb_weighted.png)

- UVM_SEQ_ARB_USER\
*If none of the above modes satisfies your need, you can create your own arbitration scheme. To do that, you need to extend the uvm_sequencer class and define its user_priority_arbitration function. As an example, we created the arbitration scheme that always selects the second entry of the FIFO if it is available. This might be quite artificial, but I hope you get the idea.*
```verilog
class jelly_bean_sequencer extends uvm_sequencer#( jelly_bean_transaction );
  `uvm_component_utils( jelly_bean_sequencer )

  //----------------------------------------------------------------------------
  // Function: new
  //----------------------------------------------------------------------------

  function new( string name, uvm_component parent );
    super.new( name, parent );
  endfunction: new

  //----------------------------------------------------------------------------
  // Function: user_priority_arbitration
  //----------------------------------------------------------------------------

  virtual function integer user_priority_arbitration( integer avail_sequences[$] );
    if ( avail_sequences.size() >= 2 ) return avail_sequences[1]; // second entry of the request FIFO
    else                               return avail_sequences[0];
  endfunction: user_priority_arbitration

endclass: jelly_bean_sequencer
```
![UVM_SEQ_ARB_USER](http://cluelogic.com/wp-content/uploads/2015/04/uvm_seq_arb_user.png)
