//------------------------------------------------------------------------------
// Package: jelly_bean_pkg
//------------------------------------------------------------------------------

package jelly_bean_pkg;
import uvm_pkg::*;

`include "transactions.svh"

   //---------------------------------------------------------------------------
   // Typedef: jelly_bean_sequencer
   //---------------------------------------------------------------------------

   typedef uvm_sequencer#( jelly_bean_transaction ) jelly_bean_sequencer;

`include "sequences.svh"
`include "agent.svh"
`include "env.svh"
`include "test.svh"
endpackage: jelly_bean_pkg

//==============================================================================
// Copyright (c) 2011-2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================