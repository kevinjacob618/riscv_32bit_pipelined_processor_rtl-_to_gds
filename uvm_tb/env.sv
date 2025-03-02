`timescale 1ns / 1ps

class risc_env extends uvm_env;
  `uvm_component_utils(risc_env)
  
  
  risc_agent riscv_agent ;
  risc_scoreboard riscv_scoreboard ;
  ral_model ral_model_h;
  risc_coverage riscv_coverage ;
 
  
  
  // Constructor 
    function new(string name = "risc_env" ,uvm_component parent);
         super.new(name,parent); 
    endfunction : new
              
               
  
  // Build Phase 
    function void build_phase(uvm_phase phase);
     super.build_phase(phase); 
           
      ral_model_h   = ral_model::type_id::create("ral_model_h"); 
      ral_model_h.build();
      ral_model_h.lock_model();
      ral_model_h.reset(); 
      uvm_config_db#(ral_model)::set(null, "*", "ral_model_h", ral_model_h);
      
      riscv_agent = risc_agent::type_id::create("riscv_agent",this);  
      riscv_scoreboard = risc_scoreboard::type_id::create("riscv_scoreboard",this);  
      riscv_coverage = risc_coverage::type_id::create("riscv_coverage",this);     
    endfunction :build_phase    
              
  
  
    
  // Connect Phase 
    function void connect_phase (uvm_phase phase);
      super.connect_phase(phase); 
      riscv_agent.riscv_monitor.monitor_ap.connect(riscv_scoreboard.sb_mon_port) ; // Connect monitor to scoreboard by analysis port              
      riscv_agent.riscv_monitor.monitor_ap.connect(riscv_coverage.cov_mon_port) ; // Connect monitor to Coverage by analysis port        
  endfunction :connect_phase
  
  // Run Phase 
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
    endtask : run_phase
  
endclass : risc_env
