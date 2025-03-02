`timescale 1ns / 1ps

  `uvm_component_utils(risc_agent)
  
  
  risc_driver riscv_driver ;
  risc_monitor riscv_monitor ;
  risc_sequencer riscv_sequencer ;
  
  
  // Constructor  
  function new(string name = "risc_agent" ,uvm_component parent);
    super.new(name,parent);
  endfunction :new
  
  
  
  // Build Phase 
  function void build_phase(uvm_phase phase);  
    super.build_phase(phase);
    riscv_driver    = risc_driver::type_id::create("riscv_driver",this);
    riscv_monitor = risc_monitor::type_id::create("riscv_monitor",this);
    riscv_sequencer = risc_sequencer::type_id::create("riscv_sequencer",this); 
  endfunction : build_phase 
  
  
  
 // Connect Phase 
  function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);	  
	 riscv_driver.risc_sequence_item_port.connect(riscv_sequencer.risc_sequence_item_export); // connect driver to sequencer
  endfunction :connect_phase
  
  
 // Run Phase 
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask : run_phase
  
  
endclass : risc_agent 

