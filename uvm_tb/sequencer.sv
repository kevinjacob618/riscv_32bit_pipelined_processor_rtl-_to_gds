`timescale 1ns / 1ps

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "risc_sequence_item.sv" 
  
 
class risc_sequencer extends uvm_sequencer #(risc_sequence_item); 
  `uvm_component_utils(risc_sequencer)
  
  function new (string name = "risc_sequencer", uvm_component parent = null);
    super.new (name, parent);
  endfunction
  
endclass
