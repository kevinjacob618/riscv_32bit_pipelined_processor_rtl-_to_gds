`timescale 1ns / 1ps

module top(
    input logic clk, reset,
    output logic [6:0] Op,           // Changed to output
    output logic [2:0] funct3,       // Changed to output
    output logic [31:0] PCF,
    output logic MemWriteM,
    output logic [31:0] ALUResultM, WriteDataM,
    output logic [31:0] InstrD,
    output logic StallD, StallF, FlushD, FlushE,
    output logic [1:0] ForwardAE, ForwardBE,
    output logic [31:0] ReadDataM,  // Ensure this is only an input
    input logic [31:0] InstrF       // Ensure this is only an input
);

    logic ALUSrcAE, RegWriteM, RegWriteW, ZeroE, SignE, PCJalSrcE, PCSrcE, RegWriteE;
    logic [1:0] ALUSrcBE;
    logic ResultSrcE0;
    logic [1:0] ResultSrcW; 
    logic [2:0] ImmSrcD;
    logic [3:0] ALUControlE;
    logic [4:0] Rs1D, Rs2D, Rs1E, Rs2E;
    logic [4:0] RdE, RdM, RdW;

    // Ensure ALUResultM is word-aligned (multiple of 4)
    logic [31:0] alignedALUResultM;
    assign alignedALUResultM = ALUResultM & 32'hFFFFFFFC; // Mask lower 2 bits

    // Derive Op and funct3 from InstrF
    assign Op = InstrF[6:0];        // Opcode (7 bits)
    assign funct3 = InstrF[14:12];  // funct3 field (3 bits)

    // Instantiate controller
    controller c(
        .clk(clk), 
        .reset(reset), 
        .Op(Op),
        .funct3(funct3),
        .InstrD(InstrD),            
        .ZeroE(ZeroE), 
        .SignE(SignE), 
        .FlushE(FlushE),
        .ResultSrcE0(ResultSrcE0), 
        .ResultSrcW(ResultSrcW), 
        .MemWriteM(MemWriteM),
        .PCJalSrcE(PCJalSrcE), 
        .PCSrcE(PCSrcE), 
        .ALUSrcAE(ALUSrcAE), 
        .ALUSrcBE(ALUSrcBE),
        .RegWriteE(RegWriteE),
        .RegWriteM(RegWriteM), 
        .RegWriteW(RegWriteW), 
        .ImmSrcD(ImmSrcD), 
        .ALUControlE(ALUControlE)
    );

    // Hazard Unit
    hazardunit h(
        .Rs1D(Rs1D), 
        .Rs2D(Rs2D), 
        .Rs1E(Rs1E), 
        .Rs2E(Rs2E), 
        .RdE(RdE), 
        .RdM(RdM), 
        .RdW(RdW), 
        .RegWriteM(RegWriteM), 
        .RegWriteW(RegWriteW), 
        .ResultSrcE0(ResultSrcE0), 
        .PCSrcE(PCSrcE), 
        .ForwardAE(ForwardAE), 
        .ForwardBE(ForwardBE),
        .StallD(StallD), 
        .StallF(StallF), 
        .FlushD(FlushD), 
        .FlushE(FlushE)
    );

    // Datapath
    datapath dp(
        .clk(clk), 
        .reset(reset), 
        .ResultSrcW(ResultSrcW), 
        .PCJalSrcE(PCJalSrcE), 
        .PCSrcE(PCSrcE), 
        .ALUSrcAE(ALUSrcAE), 
        .ALUSrcBE(ALUSrcBE), 
        .RegWriteW(RegWriteW), 
        .ImmSrcD(ImmSrcD), 
        .ALUControlE(ALUControlE),
        .ZeroE(ZeroE), 
        .SignE(SignE), 
        .PCF(PCF), 
        .InstrF(InstrF), 
        .InstrD(InstrD), 
        .ALUResultM(ALUResultM), 
        .WriteDataM(WriteDataM), 
        .ReadDataM(ReadDataM), 
        .ForwardAE(ForwardAE), 
        .ForwardBE(ForwardBE), 
        .Rs1D(Rs1D), 
        .Rs2D(Rs2D), 
        .Rs1E(Rs1E), 
        .Rs2E(Rs2E), 
        .RdE(RdE), 
        .RdM(RdM), 
        .RdW(RdW), 
        .StallD(StallD), 
        .StallF(StallF), 
        .FlushD(FlushD), 
        .FlushE(FlushE)
    );

    // Data Memory
    dmem dmem(
        .clk(clk), 
        .we(MemWriteM), 
        .a(alignedALUResultM), 
        .wd(WriteDataM), 
        .rd(ReadDataM) 
    );

    // Initialize memory (optional) for simulation
    initial begin
        $display("Memory initialized for simulation.");
    end

    // Log memory writes
    always @(posedge clk) begin
        if (MemWriteM) begin
            $display("Writing data %h to address %h at time %0t", WriteDataM, ALUResultM, $time);
        end
    end

endmodule
