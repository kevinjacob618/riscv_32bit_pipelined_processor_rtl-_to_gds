`timescale 1ns / 1ps

module Control_Unit_Top(
    input logic [6:0] Op,
    input logic [2:0] funct3,
    input logic funct7b5,
    output logic RegWrite, ALUSrcA, MemWrite, Branch, Jump, PCJalSrcE,
    output logic [1:0] ALUSrcB, ALUOp, ResultSrc,
    output logic [2:0] ImmSrc,
    output logic [3:0] ALUControl
);

    logic Opb5;  // Declare Opb5 properly

    maindec Main_Decoder(
        .Op(Op),  // Ensure correct signal name
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ALUOp(ALUOp),
        .Jump(Jump),
        .PCJalSrcE(PCJalSrcE)
    );

    aludec ALU_Decoder(
        .Opb5(Opb5),   // Match the correct lowercase name
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .ALUControl(ALUControl)
    );

    assign Opb5 = Op[5]; // Ensure it's correctly assigned
endmodule
