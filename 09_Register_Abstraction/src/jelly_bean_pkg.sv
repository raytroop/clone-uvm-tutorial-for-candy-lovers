//==============================================================================
// Source code for "UVM Tutorial for Candy Lovers" Post #9
//
// The MIT License (MIT)
//
// Copyright (c) 2011-2015 ClueLogic, LLC
// http://cluelogic.com/
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//==============================================================================

//------------------------------------------------------------------------------
// Package: jelly_bean_pkg
//------------------------------------------------------------------------------

package jelly_bean_pkg;
import uvm_pkg::*;

//------------------------------------------------------------------------------
// Class: jelly_bean_types
//------------------------------------------------------------------------------

class jelly_bean_types;
  typedef enum bit [2:0] { NO_FLAVOR, APPLE, BLUEBERRY, BUBBLE_GUM, CHOCOLATE } flavor_e;
  typedef enum bit [1:0] { NO_COLOR, RED, GREEN, BLUE } color_e;
  typedef enum bit [1:0] { NO_TASTE, YUMMY, YUCKY } taste_e;
  typedef enum bit [1:0] { NO_OP = 0, READ = 1, WRITE = 2 } command_e;
endclass: jelly_bean_types

`include "transactions.svh"
`include "ral.svh"
`include "sequences.svh"
`include "agent.svh"
`include "env.svh"
`include "test.svh"
endpackage: jelly_bean_pkg

//==============================================================================
// Copyright (c) 2011-2015 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================