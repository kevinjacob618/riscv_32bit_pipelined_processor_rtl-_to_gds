`timescale 1ns / 1ps


module BranchControl(
    input logic ZeroE,
    input logic SignE,
    input logic [2:0] funct3,
    input logic BranchE,
    input logic JumpE,
    input logic [6:0] Op,
    output logic PCSrcE
   );

    // Branch condition logic
    logic ZeroOp;
    logic SignOp;
    logic BranchOp;

    assign ZeroOp = ZeroE ^ funct3[0];  // Complements Zero flag for BNE
    assign SignOp = SignE ^ funct3[0];  // Complements Sign for BGE
    assign BranchOp = funct3[2] ? SignOp : ZeroOp;  // Choose between Sign and Zero based on funct3[2]
    assign PCSrcE = (BranchE & BranchOp) | JumpE;  // Branch or jump control
     
endmodule

