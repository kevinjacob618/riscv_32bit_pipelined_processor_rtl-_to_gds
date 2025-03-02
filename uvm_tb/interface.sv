`timescale 1ns / 1ps

interface intf (input logic clk) ; 
  
  import risc_pkg::* ;
  
     logic reset;
     logic[6:0] Op;
     logic[2:0] funct3;
     logic [31:0] PCF;
     logic MemWriteM;
     logic [31:0] ALUResultM, WriteDataM;
     logic [31:0] ReadDataM;
     logic [31:0] InstrF; 
     instr_type   inst_type  ;
  

endinterface 
