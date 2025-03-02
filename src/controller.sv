module controller (
    input logic clk, reset,
    input logic [6:0] Op,
    input logic [2:0] funct3,
    input logic ZeroE,
    input logic SignE,
    input logic FlushE,
    input logic [31:0] InstrD,
    output logic ResultSrcE0,
    output logic [1:0] ResultSrcW,
    output logic MemWriteM,
    output logic PCJalSrcE, PCSrcE, ALUSrcAE, 
    output logic [1:0] ALUSrcBE,
    output logic RegWriteM, RegWriteW, RegWriteE,
    output logic [2:0] ImmSrcD,
    output logic [3:0] ALUControlE
);
    logic [1:0] ALUOpD;
    logic [1:0] ResultSrcD, ResultSrcE, ResultSrcM;
    logic [3:0] ALUControlD;
    logic BranchD, BranchE, MemWriteD, MemWriteE, JumpD, JumpE;
    logic ALUSrcAD, RegWriteD;
    logic [1:0] ALUSrcBD;
     assign ResultSrcE0 = ResultSrcE[0];

    // Control Unit
    Control_Unit_Top control (
        .Op(InstrD[6:0]),
        .funct3(InstrD[14:12]),
        .funct7b5(InstrD[30]),
        .RegWrite(RegWriteD),
        .ImmSrc(ImmSrcD),
        .ALUSrcA(ALUSrcAD),
        .ALUSrcB(ALUSrcBD),
        .Jump(JumpD),
        .MemWrite(MemWriteD),
        .ResultSrc(ResultSrcD),
        .Branch(BranchD),
        .ALUControl(ALUControlD),
        .ALUOp(ALUOpD),
         .PCJalSrcE(PCJalSrcE)
    );

    // ID/EX Pipeline Register
    c_ID_IEx c_pipreg0 (
        .clk(clk),
        .reset(reset),
        .clear(FlushE),
        .RegWriteD(RegWriteD),
        .MemWriteD(MemWriteD),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .ALUSrcAD(ALUSrcAD),
        .ALUSrcBD(ALUSrcBD),
        .ResultSrcD(ResultSrcD),
        .ALUControlD(ALUControlD),
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),
        .JumpE(JumpE),
        .BranchE(BranchE),
        .ALUSrcAE(ALUSrcAE),
        .ALUSrcBE(ALUSrcBE),
        .ResultSrcE(ResultSrcE),
        .ALUControlE(ALUControlE)
    );

   

    // EX/MEM Pipeline Register
    c_IEx_IM c_pipreg1 (
        .clk(clk),
        .reset(reset),
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),
        .ResultSrcE(ResultSrcE),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM)
    );

    // MEM/WB Pipeline Register
    c_IM_IW c_pipreg2 (
        .clk(clk),
        .reset(reset),
        .RegWriteM(RegWriteM),
        .ResultSrcM(ResultSrcM),
        .RegWriteW(RegWriteW),
        .ResultSrcW(ResultSrcW)
    );

    // Branch Control Module
    BranchControl branch_control (
        .ZeroE(ZeroE),
        .SignE(SignE),
        .funct3(funct3),
        .BranchE(BranchE),
        .JumpE(JumpE),
        .Op(Op),
        .PCSrcE(PCSrcE)
       
    );
    
endmodule
