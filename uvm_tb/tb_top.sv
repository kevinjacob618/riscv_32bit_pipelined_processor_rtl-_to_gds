`timescale 1ns / 1ps

`include "uvm_macros.svh"

module tb_top;

   import uvm_pkg::*;
   import risc_pkg::*;

   // Signal declarations
   bit clk;
   bit reset;
   bit [6:0] Op;
   bit [2:0] funct3;
   bit [31:0] PCF, InstrF, ALUResultM, WriteDataM, ReadDataM;
   bit MemWriteM;

   // RAL HDL paths
   string blk_hdl_path = "tb_top.dut";
   string mem_hdl_path = "dmem.RAM";
   string reg_hdl_path = "rv.dp.rf.register[%0d]";

   // Interface Initialization
   intf risc_intf(clk);

   // DUT Instantiation
   top dut (
      .clk(clk),
      .reset(reset),
      .Op(Op),
      .funct3(funct3),
      .PCF(PCF),
      .InstrF(InstrF),
      .MemWriteM(MemWriteM),
      .ALUResultM(ALUResultM),
      .WriteDataM(WriteDataM),
      .ReadDataM(ReadDataM)
   );

   // Clock Generation
   initial begin
      clk = 0;
      forever #5 clk = ~clk; // 10ns clock period
   end

   // Reset and Signal Initialization
   initial begin
      reset = 1;
      Op = 7'b0000000;
      funct3 = 3'b000;
      #20 reset = 0; // Deassert reset after 20ns
   end

   // UVM Configuration
   initial begin
      uvm_config_db #(virtual intf)::set(null, "*", "risc_intf", risc_intf);
      uvm_config_db #(string)::set(null, "*", "blk_hdl_path", blk_hdl_path);
      uvm_config_db #(string)::set(null, "*", "mem_hdl_path", mem_hdl_path);
      uvm_config_db #(string)::set(null, "*", "reg_hdl_path", reg_hdl_path);
      run_test();
   end

   // Dump Waveform for EPWave
   initial begin
      $dumpfile("dump.vcd");
      $dumpvars(0, tb_top);
   end

   // Print Signal Values for Debugging
   always @(posedge clk) begin
      $display("Time: %0t | clk: %b | reset: %b | Op: %b | funct3: %b | MemWriteM: %b | ALUResultM: %h", 
               $time, clk, reset, Op, funct3, MemWriteM, ALUResultM);
   end

   // End Simulation After 500ns
   initial begin
      #500;
      $finish;
   end

endmodule
